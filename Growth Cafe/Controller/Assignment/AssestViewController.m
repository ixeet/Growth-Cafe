//
//  AssestViewController.m
//  Growth Cafe
//
//  Created by Mayank on 14/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "AssestViewController.h"
#import "AssestTableViewCell.h"
@interface AssestViewController ()

@end

@implementation AssestViewController
@synthesize mDelegate;

- (void)viewDidLoad {
      
    [super viewDidLoad];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];

}
- (void) viewWillAppear:(BOOL)animated  {
    
    // collect the photos
    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [AssestViewController defaultAssetsLibrary];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if (group)
        {
        [group setAssetsFilter:[ALAssetsFilter allVideos]];
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if (asset) {
                  [collector addObject:asset];
              }
          }];
         
         self.photos = collector;
         [tblAssest reloadData];
        }
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPlayResourceClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    ALAsset *asset = [self.photos objectAtIndex:btn.tag];
    
    NSMutableDictionary   *dic = [[NSMutableDictionary alloc] init];
    ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
    NSString *uti = [defaultRepresentation UTI];
    NSURL  *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
    NSString *title = [NSString stringWithFormat:@"video %d", arc4random()%100];
    //                     UIImage *image = [self imageFromVideoURL:videoURL];

    [self PlayTheVideo:videoURL];
    
}
-(void)PlayTheVideo:(NSURL *)stringUrl
{
    
  
    self.moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:stringUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object: self.moviePlayer];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    self.moviePlayer.shouldAutoplay = YES;
    [ self.moviePlayer prepareToPlay];
    [self.view addSubview: self.moviePlayer.view];
    [ self.moviePlayer setFullscreen:YES animated:YES];
    [ self.moviePlayer stop];
    [ self.moviePlayer play];
    //    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    //    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    
    
}
- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    [appDelegate self].allowRotation = YES;
}
- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [appDelegate self].allowRotation = NO;
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:moviePlayerController];
    [self.moviePlayer stop];
    //[self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer=nil;
    
}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@synthesize photos = _photos;
//-(void)setSearchUI
//{
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
//        
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        if( screenHeight < screenWidth ){
//            screenHeight = screenWidth;
//        }
//        
//        if( screenHeight > 480 && screenHeight < 667 ){
//            NSLog(@"iPhone 5/5s");
//        } else if ( screenHeight > 480 && screenHeight < 736 ){
//            NSLog(@"iPhone 6");
//            [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6.png"]];
//            
//        } else if ( screenHeight > 480 ){
//            // [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
//            
//            NSLog(@"iPhone 6 Plus");
//        } else {
//            NSLog(@"iPhone 4/4s");
//            
//        }
//        [txtSearchBar setBackgroundColor:[UIColor clearColor]];
//        UITextField *txfSearchField = [txtSearchBar valueForKey:@"_searchField"];
//        [txfSearchField setBackgroundColor:[UIColor clearColor]];
//        //[txfSearchField setLeftView:UITextFieldViewModeNever];
//        [txfSearchField setBorderStyle:UITextBorderStyleNone];
//        //  [txfSearchField setTextColor:[UIColor whiteColor]];
//    }
//}

- (IBAction)btnCancleClick:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//   [ self.navigationController dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [mDelegate DidNoSelectAssesst:self];
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}
-(void)setPhotos:(NSArray *)photos {
    if (_photos != photos) {
        _photos = photos;
        [tblAssest reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//    
//    static NSString *CellIdentifier = @"MyPhotos";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    // Configure the cell...
    // Configure the cell...
    static NSString *identifier = @"AssestTableViewCell";
    AssestTableViewCell *cell = (AssestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }

    ALAsset *asset = [self.photos objectAtIndex:indexPath.row];
    
   // NSMutableDictionary   *dic = [[NSMutableDictionary alloc] init];
                         ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
                         //NSString *uti = [defaultRepresentation UTI];
//                         NSURL  *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
                         NSString *title = [NSString stringWithFormat:@"video %d", arc4random()%100];
    //                     UIImage *image = [self imageFromVideoURL:videoURL];

    [cell.imgAssest setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    [cell.lblAssestName setText:[NSString stringWithFormat:@"%@",title]];
    cell.btnPlay.tag   =indexPath.row;
    [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   ALAsset *assest= [self.photos objectAtIndex:indexPath.row];
    [mDelegate DidSelectAssesst:assest andSender:self ];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    return 108.0f;
    
    
}


@end
