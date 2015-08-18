//
//  ModuleDetailViewController.m
//  sLMS
//
//  Created by Mayank on 20/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ModuleDetailViewController.h"
#import "CustomContentView.h"
#import "ContentCellTableViewCell.h"
#import "AssignmentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "AppEngine.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VedioPlayViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "SubCommentTableViewCell.h"

@interface ModuleDetailViewController ()
{
    NSMutableArray *contentList;
    NSMutableArray *assignmentList;
    Resourse *selectedResource;
    BOOL IsCommentExpended;
    BOOL IsAsignmentExpended;
    BOOL IsRelatedConentExpended;
    CGRect txtframe;
    ActionOn    actionOn;
    NSString    *selectedResourceId,*selectedCommentId;
    NSString    *searchText;
    NSString* relatedURL;
    BOOL isSearching;
    NSString *moduleId,*moduleName;
}


@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) NSArray *pageImages;
//somewhere in the header
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat lastContentOffsetOfTable;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
- (IBAction)btnProfileClick:(id)sender;

@end

@implementation ModuleDetailViewController
@synthesize btnAssignment,btnCourses,btnMore,btnNotification,btnUpdates,txtSearchBar,feedId,scollViewContainer;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize pageViews = _pageViews;
@synthesize pageImages = _pageImages;
@synthesize step,title,txtViewCMT,objCustom;;
@synthesize moviePlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set up the image we want to scroll & zoom and add it to the scroll view
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Set up the array to hold the views for each page
    [self setSearchUI];

  self.scrollView.clipsToBounds=NO;
   

    
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
     txtframe=frame1;
    self.cmtview.frame=frame1;
    [self.view addSubview:self.cmtview];
    btnCourses.selected=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
    objCustom = [[CustomProfileView alloc] init];
    NSLog(@"%f,%f",self.view.frame.size.height,self.view.frame.size.width);
    objCustom.center = CGPointMake(200, 400);
    CGRect profileFrame=objCustom.view.frame ;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    profileFrame.size.height=screenHeight-50;
    profileFrame.size.width=screenWidth;//200;
    objCustom.view.frame=profileFrame;
   [objCustom.btnLogout  addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(feedId==nil){
        
        [self getModuleDetail:@""];
        
    }else{
      [self getModuleDetailByFeed];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    step=0;
    self.lastContentOffsetOfTable=tblViewContent.contentOffset.y;;
    searchText=@"";
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [objCustom.view addGestureRecognizer:recognizer];    //set Profile
    [objCustom setUserProfile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
    [txtViewCMT resignFirstResponder];
    isSearching=NO;
    txtViewCMT.text=@"";
    step=0;
}

-(void)viewDidDisappear:(BOOL)animated
{
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];
 
}
-(void)setSearchUI
{
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if( screenHeight < screenWidth ){
            screenHeight = screenWidth;
        }
        
        if( screenHeight > 480 && screenHeight < 667 ){
            NSLog(@"iPhone 5/5s");
        } else if ( screenHeight > 480 && screenHeight < 736 ){
            NSLog(@"iPhone 6");
            [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6Small.png"]];
            
        } else if ( screenHeight > 480 ){
           // [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
            
            NSLog(@"iPhone 6 Plus");
        } else {
            NSLog(@"iPhone 4/4s");
            
        }
        [txtSearchBar setBackgroundColor:[UIColor clearColor]];
        UITextField *txfSearchField = [txtSearchBar valueForKey:@"_searchField"];
        [txfSearchField setBackgroundColor:[UIColor clearColor]];
        //[txfSearchField setLeftView:UITextFieldViewModeNever];
        [txfSearchField setBorderStyle:UITextBorderStyleNone];
        //  [txfSearchField setTextColor:[UIColor whiteColor]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - table cell Action
- (IBAction)btnUserProfileClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    // call the user profile service user profile
    
    NSString *userid=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] getUserDetail:userid success:^(UserDetails *usrDetail) {
        //Hide Indicator
        ProfileViewController *profileView=[[ProfileViewController alloc]init];
        profileView.user=usrDetail;
        [self.navigationController pushViewController:profileView animated:YES];
        [appDelegate hideSpinner];
        
    }
                                 failure:^(NSError *error) {
                                     //Hide Indicator
                                     [appDelegate hideSpinner];
                                     NSLog(@"failure JsonData %@",[error description]);
                                     
                                     [self loginError:error];
                                 }];
    
    
}
- (IBAction)btnMoreCommentClick:(id)sender {
    IsCommentExpended=YES;
    IsRelatedConentExpended=NO;
    IsAsignmentExpended=NO;
    [tblViewContent reloadData];
    
}
- (IBAction)btnMoreRelatedVideoClick:(id)sender {
    IsRelatedConentExpended=YES;
    IsCommentExpended=NO;
    IsAsignmentExpended=NO;
    [tblViewContent reloadData];
}
- (IBAction)btnMoreAssignmentClick:(id)sender {
    IsAsignmentExpended=YES;
    IsRelatedConentExpended=NO;
    IsCommentExpended=NO;
    [tblViewContent reloadData];
   
}
#pragma mark - Comment and like on Resource

- (IBAction)btnPlayAssignmentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"assignmentId == %d", btn.tag];
//    NSArray *filteredArray = [assignmentList filteredArrayUsingPredicate:predicate];
    Assignment *assignment =[assignmentList objectAtIndex: btn.tag];
    [self PlayTheVideo:assignment.attachedResource.resourceUrl];

}
- (IBAction)btnPlayRelatedResourceClick:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"resourceId == %d", btn.tag];
//    NSArray *filteredArray = [assignmentList filteredArrayUsingPredicate:predicate];
//
    Resourse *resource =[selectedResource.relatedResources objectAtIndex:btn.tag];
    [self PlayTheVideo:resource.resourceUrl];
    
}
- (IBAction)btnPlayResourceClick:(id)sender {
   
//    VedioPlayViewController *vedioView= [[VedioPlayViewController alloc]init];
//    NSInteger currentpage=  self.pageControl.currentPage;
//    selectedResource=[contentList objectAtIndex:currentpage];
//    vedioView.filePath=selectedResource.resourceUrl;
//    [self.navigationController pushViewController:vedioView animated:YES];
 
    NSInteger currentpage=  self.pageControl.currentPage;
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    [self PlayTheVideo:selectedResource.resourceUrl];
}
-(void)PlayTheVideo:(NSString *)stringUrl
{
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    self.moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:url];
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
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    

}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
   
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
- (IBAction)btnCommentOnResourceClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    NSInteger currentpage=  self.pageControl.currentPage;
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Resource;
    [txtViewCMT becomeFirstResponder];
    

}
- (IBAction)btnLikeOnResourceClick:(id)sender {
    // call the service
    UIButton *btn=(UIButton *)sender;
    NSInteger currentpage=  self.pageControl.currentPage;
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];

        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
        [[appDelegate _engine] setLikeOnResource:selectedResourceId  success:^(BOOL success) {
    
    
           

            //Hide Indicator
            [appDelegate hideSpinner];
            [self getModuleDetail:searchText];
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                 [self loginError:error];
                                                
    
                                            }];
}
- (IBAction)btnShareOnResourceClick:(id)sender {
}
#pragma mark - Reply and like on Comment

- (IBAction)btnReplyOnCommentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Comment;
    [txtViewCMT becomeFirstResponder];

}
- (IBAction)btnLikeOnCommentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setLikeOnComment:selectedCommentId AndisFeed:NO success:^(BOOL success) {
       //Hide Indicator
        
        [appDelegate hideSpinner];
           [self getModuleDetail:searchText];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                      
                                         [self loginError:error];
                                     }];

}

#pragma mark - tab bar Action
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (IBAction)btnAssignmentClick:(id)sender {
//}
//
//- (IBAction)btnCourseClick:(id)sender {
//}
//
//- (IBAction)btnNotificationClick:(id)sender {
//}
//
//- (IBAction)btnUpdateClick:(id)sender {
//}
//- (IBAction)btnMoreClick:(id)sender {
//}

- (IBAction)btnCommentDone:(id)sender {
    [txtViewCMT resignFirstResponder];
    step=0;
    // call the service
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    if (actionOn==Resource) {
        [[appDelegate _engine] setCommentOnResource:selectedResourceId AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            [appDelegate hideSpinner];
            
            [self getModuleDetail:searchText];
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                [self loginError:error];
                                                
                                            }];

    }else{
        [[appDelegate _engine] setCommentOnComment:selectedCommentId AndisFeed:NO AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            [appDelegate hideSpinner];
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                [self loginError:error];
                                                
                                            }];

    }
    txtViewCMT.text=@"";
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    txtframe=frame1;
   
}

- (IBAction)btnCommentCancle:(id)sender {
     [txtViewCMT resignFirstResponder];
    txtViewCMT.text=@"";
    CGRect frame1 = self.cmtview.frame;
    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    txtframe=frame1;

    step=0;
}
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   
    [txtViewCMT resignFirstResponder];
     isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  //  NSLog(@"Text change - %d");
    
    //Remove all objects first.
    //    [filteredContentList removeAllObjects];
    //
    //    if([searchText length] != 0) {
    //        isSearching = YES;
    //        [self searchTableList];
    //    }
    //    else {
    //        isSearching = NO;
    //    }
    // [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    isSearching=NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    searchText=searchBar.text;
  [self getModuleDetail:searchBar.text];
    // [self searchTableList];
    isSearching=NO;
}
#pragma mark Course Private functions
#pragma mark Course Private functions
-(void) getModuleDetail:(NSString *) txtSearch
{
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance ].userDetail.userId];
    // userid=@"1";
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getModuleDetail:userid AndTextSearch:txtSearch AndSelectModule:self.selectedModule AndSelectCourse:self.selectedCourse success:^(NSDictionary *moduleDetails) {
        
        contentList=[moduleDetails objectForKey:@"resourceList"];
        assignmentList=[moduleDetails objectForKey:@"assignmentList"];
        NSInteger pageCount = [contentList count];
        
        // Set up the page control
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = pageCount;
        // Set up the content size of the scroll view
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
        CGSize pagesScrollViewSize = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+10);
        
        // Load the initial set of pages that are on screen
        [self loadVisiblePages];
        [tblViewContent reloadData];
        
        
        //Hide Indicator
        [appDelegate hideSpinner];
    }
                                   failure:^(NSError *error) {
                                       //Hide Indicator
                                       [appDelegate hideSpinner];
                                       NSLog(@"failure JsonData %@",[error description]);
                                       [self loginError:error];
                                       //                                         [self loginViewShowingLoggedOutUser:loginView];
                                       
                                   }];
    
    
}
-(void) getModuleDetailByFeed
{
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] getModuleDetail:feedId success:^(NSDictionary *moduleDetails)
     {
         //Hide Indicator
        contentList=[moduleDetails objectForKey:@"resourceList"];
        assignmentList=[moduleDetails objectForKey:@"assignmentList"];
        NSInteger pageCount = [contentList count];
        
        // Set up the page control
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = pageCount;
        // Set up the content size of the scroll view
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
        CGSize pagesScrollViewSize = self.scrollView.frame.size;
        self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+10);
        
        // Load the initial set of pages that are on screen
        [self loadVisiblePages];
       [tblViewContent reloadData];
      
        
        //Hide Indicator
        [appDelegate hideSpinner];
    }
                               failure:^(NSError *error) {
                                   //Hide Indicator
                                   [appDelegate hideSpinner];
                                   NSLog(@"failure JsonData %@",[error description]);
                                   [self loginError:error];
                                   //                                         [self loginViewShowingLoggedOutUser:loginView];
                                   
                               }];
    
    
}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}

#pragma mark -

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i< [contentList count]; i++) {
        [self purgePage:i];
    }
    self.lastContentOffset = self.scrollView.contentOffset.y;
    [self.scollViewContainer bringSubviewToFront: self.scrollView];
    }

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= [contentList count]) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first seeing if we've already loaded it
    // set here custom view
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 5.0f, 0.0f);
        Resourse *resource=[contentList objectAtIndex:page];
        CustomContentView *customView= [[CustomContentView alloc]init];
        customView.lblAutherName.text=resource.authorName;
        NSDate *dateSatrtedOn = [AppGlobal convertStringDateToNSDate:resource.startedOn];
        NSDate *dateCompletedOn = [AppGlobal convertStringDateToNSDate:resource.completedOn];
        if(dateSatrtedOn!=nil)
        {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateSatrtedOn]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.startedOn=[NSString stringWithFormat:@"%@ %ld,%ld",monthName,(long)components.day,(long)components.year];
        
        components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateCompletedOn]; // Get necessary date components
        monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.completedOn=[NSString stringWithFormat:@"%@ %ld,%ld",monthName,(long)components.day,(long)components.year];
        }
        customView.lblStartedon.text=resource.startedOn;
        customView.lblCompletedon.text=resource.completedOn;
        if([resource.islike isEqualToString:@"1"])
        {
            customView.btnLike.selected=YES;
            [customView.btnLike setTitle:resource.likeCounts forState:UIControlStateSelected];
        }else
            
        {
             customView.btnLike.selected=NO;
            [customView.btnLike setTitle:resource.likeCounts forState:UIControlStateNormal];
        }
        
       // [customView.btnShare    setTitle:resource.shareCounts forState:UIControlStateNormal];
        [customView.btnComment setTitle:resource.commentCounts forState:UIControlStateNormal];
      // gentrte thumbnail
        // [customView.imgContent setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
       
         if(resource.resourceImageUrl!=nil){
             
             if (resource.resourceImageData==nil) {
                  NSURL *imageURL = [NSURL URLWithString:resource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                           customView.imgContent.image= [UIImage imageWithData: resource.resourceImageData ];
                          [customView.imgContent setBackgroundColor:[UIColor clearColor]];
                        });
                    });
                 
             }else{
                 customView.imgContent.image= [UIImage imageWithData: resource.resourceImageData ];
                 [customView.imgContent setBackgroundColor:[UIColor clearColor]];
             }
         }
        
        [customView.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [customView.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        customView.btnComment.tag=[resource.resourceId integerValue];
        customView.btnLike.tag=[resource.resourceId integerValue];
        // add vedio play
        
        [customView.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];

        // set comment for the content
        // check if comment is available
        if([resource.comments  count]>0)
        {
            Comments *objComment=[resource.comments objectAtIndex:0];
            
            if(objComment.commentByImage!=nil){
                if(objComment.commentByImageData==nil)
                {
                NSURL *imageURL = [NSURL URLWithString:objComment.commentByImage];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    objComment.commentByImageData=imageData;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        //customView.imgViewCmtBy.image= [UIImage imageWithData:imageData];
                        UIImage *img=[UIImage imageWithData:imageData];
                        if(img!=nil)
                            [ customView.btnCmtBy setImage:img forState:UIControlStateNormal];
                            
                            });
                });
                }else{
                 [ customView.btnCmtBy setImage:[UIImage imageWithData: objComment.commentByImageData ] forState:UIControlStateNormal];
                }
            }
        
            customView.lblCmtBy.text=  objComment.commentBy;
            customView.lblCmtTime.text= objComment.commentDate;
            [customView.btnLikeCMT setTitle:objComment.likeCounts forState:UIControlStateNormal];
           // [customView.btnShareCMT    setTitle:objComment.shareCounts forState:UIControlStateNormal];
            [customView.btnCommentCMT setTitle:objComment.commentCounts forState:UIControlStateNormal];
            customView.txtCmtView.text= objComment.commentTxt;
           
            customView.btnCommentCMT.tag=[objComment.commentId integerValue];
            customView.btnLikeCMT.tag=[objComment.commentId integerValue];
            
            //set action for reply and like on comment
       
            [customView.btnCommentCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            [customView.btnLikeCMT addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [customView.btnCmtBy setHidden:YES];
            //[customView.imgViewCmtBy setImage:[UIImage imageWithData:[NSData ns] ]];
           [ customView.lblCmtBy setHidden:YES];
            [customView.lblCmtTime setHidden:YES];
            [customView.btnLikeCMT setHidden:YES];
         //   [customView.btnShareCMT   setHidden:YES];
            [customView.btnCommentCMT setHidden:YES];
            [customView.txtCmtView setHidden:YES];
        }
        
        customView.clipsToBounds=YES    ;
       customView.contentMode = UIViewContentModeScaleAspectFit;
        customView.frame = frame;
        [self.scrollView addSubview:customView];
        [self.pageViews replaceObjectAtIndex:page withObject:customView];
    }
    
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= [contentList count]) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (IBAction)btnProfileClick:(id)sender {
    [self fadeInAnimation:self.view];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES)
    {
        NSLog(@"running");
        ScrollDirection scrollDirection;
        if( scrollView.tag==20){
            if (scrollView.contentOffset.y >10)
            {
                scrollDirection = ScrollDirectionDown;
                
                
                self.lastContentOffset = scrollView.contentOffset.y;
                
                // get current page;
                NSInteger currentpage=  self.pageControl.currentPage;
                // get the current Content
                selectedResource=[contentList objectAtIndex:currentpage];
                // CATransition *animation = [CATransition animation];
                //        animation.type = kCATransitionFade;
                //        animation.duration = 0.0;
                //        [scrollView.layer addAnimation:animation forKey:nil];
                //
                //        scrollView.hidden = YES;
                [UIView transitionWithView:scrollView
                                  duration:0.4
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:NULL
                                completion:NULL];
                self.scrollView.hidden=YES;
                [tblViewContent reloadData];
                tblViewContent.hidden =NO;
                //button.layer.shouldRasterize = YES;
            }else {
                self.lastContentOffset = scrollView.contentOffset.y;
                
            }
        }else if( scrollView.tag==10){
            if (scrollView.contentOffset.y<-10)
            {
                scrollDirection = ScrollDirectionDown;
                
                
                self.lastContentOffsetOfTable = scrollView.contentOffset.y;
                
                [UIView transitionWithView:scrollView
                                  duration:0.4
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:NULL
                                completion:NULL];
                self.scrollView.hidden=NO;
                // [tblViewContent reloadData];
                
                tblViewContent.hidden =YES;
                NSInteger pageCount = [contentList count];
                
                // Set up the page control
                self.pageControl.currentPage = 0;
                self.pageControl.numberOfPages = pageCount;
                // Set up the content size of the scroll view
                // Set up the array to hold the views for each page
                self.pageViews = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < pageCount; ++i) {
                    [self.pageViews addObject:[NSNull null]];
                }
                CGSize pagesScrollViewSize = self.scrollView.frame.size;
                self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+5);
                [self loadVisiblePages];
                //button.layer.shouldRasterize = YES;
            }else {
                self.lastContentOffsetOfTable = scrollView.contentOffset.y;
                
            }
        }

    }
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//  
//    
//    ScrollDirection scrollDirection;
//    if( scrollView.tag==20){
//    if (self.lastContentOffset > self.scrollView.contentOffset.y+5)
//    {
//        scrollDirection = ScrollDirectionDown;
//
//    
//    self.lastContentOffset = scrollView.contentOffset.y;
//    
//    // get current page;
//    NSInteger currentpage=  self.pageControl.currentPage;
//    // get the current Content
//   selectedResource=[contentList objectAtIndex:currentpage];
//       // CATransition *animation = [CATransition animation];
////        animation.type = kCATransitionFade;
////        animation.duration = 0.0;
////        [scrollView.layer addAnimation:animation forKey:nil];
////        
////        scrollView.hidden = YES;
//        [UIView transitionWithView:scrollView
//                          duration:0.4
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        animations:NULL
//                        completion:NULL];
//        self.scrollView.hidden=YES;
//        [tblViewContent reloadData];
//        tblViewContent.hidden =NO;
//        //button.layer.shouldRasterize = YES;
//    }else {
//     self.lastContentOffset = scrollView.contentOffset.y;
//    
//    }
//    }else if( scrollView.tag==10){
//            if (self.lastContentOffsetOfTable <-50)
//            {
//                scrollDirection = ScrollDirectionDown;
//                
//                
//                self.lastContentOffsetOfTable = scrollView.contentOffset.y;
//                
//                [UIView transitionWithView:scrollView
//                                  duration:0.4
//                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                                animations:NULL
//                                completion:NULL];
//                 self.scrollView.hidden=NO;
//               // [tblViewContent reloadData];
//                
//                tblViewContent.hidden =YES;
//                NSInteger pageCount = [contentList count];
//                
//                // Set up the page control
//                self.pageControl.currentPage = 0;
//                self.pageControl.numberOfPages = pageCount;
//                // Set up the content size of the scroll view
//                // Set up the array to hold the views for each page
//                self.pageViews = [[NSMutableArray alloc] init];
//                for (NSInteger i = 0; i < pageCount; ++i) {
//                    [self.pageViews addObject:[NSNull null]];
//                }
//                CGSize pagesScrollViewSize = self.scrollView.frame.size;
//                self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+10);
//                [self loadVisiblePages];
//                //button.layer.shouldRasterize = YES;
//            }else {
//                self.lastContentOffsetOfTable = scrollView.contentOffset.y;
//                
//            }
//        }
//}
#pragma mark - Table view data source

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated];
//    [self.tableView reloadData];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"You are in: %s", __FUNCTION__);
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(selectedResource==nil)
        return 0;
    if(section==0)
        return 1;
    else if(section==1 && IsCommentExpended)
    {
        return [selectedResource.comments count];
    }
    else if(section==1 && !IsCommentExpended)
   {
       if ([selectedResource.comments count]>3) {
           return 3;
       }else{
        return [selectedResource.comments count];
       }
   }
   else if(section==2 && IsRelatedConentExpended)
   {
       return [selectedResource.relatedResources count];
   }
   else if(section==2 && !IsRelatedConentExpended)
   {
       if ([selectedResource.relatedResources count]>3) {
           return 3;
       }else{
           return [selectedResource.relatedResources count];
       }
   }
   else if(section==3 && IsAsignmentExpended)
   {
       return [assignmentList count];
   }
   else if(section==3 && !IsAsignmentExpended)
   {
       if ([assignmentList count]>3) {
           return 3;
       }else{
           return [assignmentList count];
       }
   }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if(indexPath.section==0)
    {
        static NSString *identifier = @"ContentCellTableViewCell";
        ContentCellTableViewCell *cell = (ContentCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }

        cell.lblAutherName.text=selectedResource.authorName;
        
        cell.lblStartedon.text=selectedResource.startedOn;
       
        cell.lblCompletedon.text=selectedResource.completedOn;
        if(selectedResource.resourceImageUrl!=nil){
            
            if (selectedResource.resourceImageData==nil) {
                NSURL *imageURL = [NSURL URLWithString:selectedResource.resourceImageUrl];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    selectedResource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                 dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *img=[UIImage imageWithData:selectedResource.resourceImageData];
                    if(img!=nil)
                    {
                        cell.imgContent.image= img;
                        [cell.imgContent setBackgroundColor:[UIColor clearColor]];
                    }
                });
            });
            }else{
                UIImage *img=[UIImage imageWithData:selectedResource.resourceImageData];
                cell.imgContent.image= img;
                [cell.imgContent setBackgroundColor:[UIColor clearColor]];
            }
        }
        [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        if([selectedResource.islike isEqualToString:@"1"])
        {
            cell.btnLike.selected=YES;
             [cell.btnLike setTitle:selectedResource.likeCounts forState:UIControlStateSelected];
        }else
            
        {
            cell.btnLike.selected=NO;
          [cell.btnLike setTitle:selectedResource.likeCounts forState:UIControlStateNormal];
        }
        
        cell.btnComment.tag=[selectedResource.resourceId integerValue];
        cell.btnLike.tag=[selectedResource.resourceId integerValue];
        cell.btnShare.tag=[selectedResource.resourceId integerValue];
        //set action for comment and like on resource
        [cell.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnShare addTarget:self action:@selector(btnShareOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        
       [cell.btnComment setTitle:selectedResource.commentCounts forState:UIControlStateNormal];
        
        return cell;
    }else if(indexPath.section==1){
        Comments *comment= [selectedResource.comments objectAtIndex:indexPath.row];
        if ([comment.parentCommentId integerValue] ==0) {
            
        
        static NSString *identifier = @"CommentTableViewCell";
        CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        
        //[cell.imgCMT setImage:[AppGlobal generateThumbnail:comment.commentByImage]];
            NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:comment.commentDate];
            
            NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
            //   cell.lblCmtDate.text=comment.commentDate;
            scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
                                                               withString:@""];
            // Set label text to attributed string
            NSString *str = [NSString stringWithFormat:@"%@ %@ ago" ,comment.commentBy,scincetime];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            
            // Set font, notice the range is for the whole string
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [comment.commentBy length])];
            [cell.lblCmtBy setAttributedText:attributedString];     //   cell.lblCmtDate.text=comment.commentDate;
        cell.lblCmtText.text=comment.commentTxt;

        if(comment.commentBy!=nil)
        {
            [cell.btnCommentedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnCommentedBy.tag = [comment.commentById integerValue];
        }

        
        if(comment.commentByImage!=nil){
            if(comment.commentByImageData==nil)
            {

            NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                comment.commentByImageData=imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *img=[UIImage imageWithData:imageData];
                    if(img!=nil)
                       [cell.btnCommentedBy setImage:img forState:UIControlStateNormal];
                    
                });
            });
            }else{
             [cell.btnCommentedBy setImage:[UIImage imageWithData:comment.commentByImageData] forState:UIControlStateNormal];
            }
        }
        if([comment.isLike  isEqualToString:@"1"])
        {
            cell.btnLike.selected=YES;
            [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateSelected];
        }else
            
        {
            cell.btnLike.selected=NO;
            [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateNormal];
        }
       
        [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
      
        cell.btnCMT.tag=[comment.commentId integerValue];
        cell.btnLike.tag=[comment.commentId integerValue];
       
        //set action for reply and like on comment
        [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnMore.hidden=YES;
        cell.imgDevider.hidden=YES;
        cell.lblRelatedVideo.hidden =YES;
        
        if(([selectedResource.comments count]<3) && (indexPath.row==[selectedResource.comments count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=NO;
            cell.lblRelatedVideo.hidden =NO;
            
        }
        else if([selectedResource.comments count]>=3)
        {
            if(IsCommentExpended && (indexPath.row==[selectedResource.comments count]-1))
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.comments count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=YES;
                cell.imgDevider.hidden=NO;
                cell.lblRelatedVideo.hidden =NO;
            }else if(indexPath.row==2 && !IsCommentExpended){
                [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.comments count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=NO;
                cell.imgDevider.hidden=NO;
                cell.lblRelatedVideo.hidden =NO;
            }
            
        }
        return cell;
        }else{
            
            static NSString *identifier = @"SubCommentTableViewCell";
            SubCommentTableViewCell *cell = (SubCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
                [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            }
            
            //[cell.imgCMT setImage:[AppGlobal generateThumbnail:comment.commentByImage]];
            NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:comment.commentDate];
            
            NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
            //   cell.lblCmtDate.text=comment.commentDate;
            scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
                                                 withString:@""];
            // Set label text to attributed string
            NSString *str = [NSString stringWithFormat:@"%@ %@ ago" ,comment.commentBy,scincetime];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            
            // Set font, notice the range is for the whole string
            UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
            [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [comment.commentBy length])];
            [cell.lblCmtBy setAttributedText:attributedString];
           // cell.lblCmtDate.text=comment.commentDate;
            cell.lblCmtText.text=comment.commentTxt;
            
            if(comment.commentBy!=nil)
            {
                [cell.btnCommentedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnCommentedBy.tag = [comment.commentById integerValue];
            }
            
            
            if(comment.commentByImage!=nil){
                if(comment.commentByImageData==nil)
                {
                    
                    NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        comment.commentByImageData=imageData;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            UIImage *img=[UIImage imageWithData:imageData];
                            if(img!=nil)
                                [cell.btnCommentedBy setImage:img forState:UIControlStateNormal];
                            
                        });
                    });
                }else{
                    [cell.btnCommentedBy setImage:[UIImage imageWithData:comment.commentByImageData] forState:UIControlStateNormal];
                }
            }
            if([comment.isLike  isEqualToString:@"1"])
            {
                cell.btnLike.selected=YES;
                [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateSelected];
            }else
                
            {
                cell.btnLike.selected=NO;
                [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateNormal];
            }
            
           // [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
            
         //   cell.btnCMT.tag=[comment.commentId integerValue];
            cell.btnLike.tag=[comment.commentId integerValue];
            
            //set action for reply and like on comment
          //  [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
            cell.lblRelatedVideo.hidden =YES;
            
            if(([selectedResource.comments count]<3) && (indexPath.row==[selectedResource.comments count]-1))
            {
                cell.btnMore.hidden=YES;
                cell.imgDevider.hidden=NO;
                cell.lblRelatedVideo.hidden =NO;
                
            }
            else if([selectedResource.comments count]>=3)
            {
                if(IsCommentExpended && (indexPath.row==[selectedResource.comments count]-1))
                {
                    [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.comments count ]-3]  forState:UIControlStateNormal];
                    cell.btnMore.hidden=YES;
                    cell.imgDevider.hidden=NO;
                    cell.lblRelatedVideo.hidden =NO;
                }else if(indexPath.row==2 && !IsCommentExpended){
                    [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.comments count ]-3]  forState:UIControlStateNormal];
                    cell.btnMore.hidden=NO;
                    cell.imgDevider.hidden=NO;
                    cell.lblRelatedVideo.hidden =NO;
                }
                
            }
            return cell;
        }
        
    }
    else if(indexPath.section==2){
        static NSString *identifier = @"AssignmentTableViewCell";
        AssignmentTableViewCell *cell = (AssignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Resourse *resource= [selectedResource.relatedResources objectAtIndex:indexPath.row];
        
       // [cell.imgContentURL setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
        cell.lblContentName.text= resource.resourceDesc;
        cell.lblContentby.text=resource.authorName;
       // cell.lblSubmittedDate.text=resource.uploadedDate;
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:resource.uploadedDate];
       
        if(resource.resourceImageUrl!=nil){
            NSURL *imageURL = [NSURL URLWithString:resource.resourceImageUrl];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    
                    UIImage *img=[UIImage imageWithData:imageData];
                    if(img!=nil)
                       cell.imgContentURL.image= img;

                });
            });
        }
        
        if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.uploadedDate=[NSString stringWithFormat:@"%@ %ld",monthName,(long)components.day];
        }
      cell.btnPlay.tag= indexPath.row;
        [cell.btnPlay  addTarget:self action:@selector(btnPlayRelatedResourceClick:) forControlEvents:UIControlEventTouchUpInside];

        cell.lblSubmittedDate.text=[NSString stringWithFormat:@"Uploaded on %@",resource.uploadedDate ];
        if(indexPath.row!=([selectedResource.relatedResources count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
             cell.lblAssignment.hidden=YES;
        }else{
            if([selectedResource.relatedResources count]>=3)
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.relatedResources count ]-3]  forState:UIControlStateNormal];
            }else{
                cell.btnMore.hidden=YES;
            }
        }

        cell.btnMore.hidden=YES;
        cell.imgDevider.hidden=YES;
        cell.lblAssignment.hidden =YES;
        
        if(([selectedResource.relatedResources count]<3) && (indexPath.row==[selectedResource.relatedResources count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=NO;
            cell.lblAssignment.hidden =NO;
            
        }
        else if([selectedResource.relatedResources count]>=3)
        {
            if(IsRelatedConentExpended && (indexPath.row==[selectedResource.relatedResources count]-1))
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.relatedResources count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=YES;
                cell.imgDevider.hidden=NO;
                cell.lblAssignment.hidden =NO;
            }else if(indexPath.row==2 && !IsRelatedConentExpended){
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[selectedResource.relatedResources count ]-3]  forState:UIControlStateNormal];
                cell.btnMore.hidden=NO;
                cell.imgDevider.hidden=NO;
                cell.lblAssignment.hidden =NO;
            }
            
        }

        return cell;
        
    }
    else{
        static NSString *identifier = @"AssignmentTableViewCell";
        AssignmentTableViewCell *cell = (AssignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Assignment *assignment= [assignmentList objectAtIndex:indexPath.row];
        Resourse *resource=assignment.attachedResource;
       // [cell.imgContentURL setImage:[AppGlobal generateThumbnail:resource.resourceUrl]];
        cell.lblContentName.text= assignment.assignmentName;
        cell.lblContentby.text=assignment.assignmentSubmittedBy;
        
        
        if(resource.resourceImageUrl!=nil){
            NSURL *imageURL = [NSURL URLWithString:resource.resourceImageUrl];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                if (resource.resourceImageData==nil) {
                     resource.resourceImageData = [NSData dataWithContentsOfURL:imageURL];
                }
               dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    //cell.imgContentURL.image= [UIImage imageWithData:imageData];
                    UIImage *img=[UIImage imageWithData: resource.resourceImageData];
                    if(img!=nil)
                         cell.imgContentURL.image= img;

                });
            });
        }
        
        
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.assignmentSubmittedDate];
       if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
      assignment.assignmentSubmittedDate=[NSString stringWithFormat:@"%@ %ld",monthName,(long)components.day];
       }
        cell.btnPlay.tag= indexPath.row;
        [cell.btnPlay  addTarget:self action:@selector(btnPlayAssignmentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lblSubmittedDate.text=[NSString stringWithFormat:@"Submitted on %@",assignment.assignmentSubmittedDate ];
        if(indexPath.row!=([assignmentList count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
            cell.lblAssignment.hidden=YES;
        }else{
            if([assignmentList count]>3)
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%lu More",[assignmentList count ]-3]  forState:UIControlStateNormal];
            }else{
                cell.btnMore.hidden=YES;
            }
        }
        return cell;
    }

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//    BOOL isChild =
//    currentExpandedIndex > -1
//    && indexPath.row > currentExpandedIndex
//    && indexPath.row <= currentExpandedIndex + [[moduleArray objectAtIndex:currentExpandedIndex] count];
//    
//    if (isChild) {
//        NSLog(@"A child was tapped, do what you will with it");
//        return;
//    }
//    
//    [tableViewCourse beginUpdates];
//    
//    if (currentExpandedIndex == indexPath.row) {
//        [self collapseSubItemsAtIndex:currentExpandedIndex];
//        currentExpandedIndex = -1;
//    }
//    else {
//        
//        BOOL shouldCollapse = currentExpandedIndex > -1;
//        
//        if (shouldCollapse) {
//            [self collapseSubItemsAtIndex:currentExpandedIndex];
//        }
//        
//        currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[moduleArray objectAtIndex:currentExpandedIndex] count] : indexPath.row;
//        
//        [self expandItemAtIndex:currentExpandedIndex];
//    }

    
    
//    [tableViewCourse endUpdates];
    
}

//- (void)expandItemAtIndex:(int)index {
//    
//    NSMutableArray *indexPaths = [NSMutableArray new];
//    //    [indexPaths addObject:[NSIndexPath indexPathForRow:currentExpandedIndex++ inSection:0]];
//    //    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    //    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    
//    
//    NSArray *currentSubItems = [moduleArray objectAtIndex:index];
//    int insertPos = index + 1;
//    for (int i = 0; i < [currentSubItems count]; i++) {
//        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
//    }
//    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    [tableViewCourse scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    
//}
//
//- (void)collapseSubItemsAtIndex:(int)index {
//    NSMutableArray *indexPaths = [NSMutableArray new];
//    for (int i = index + 1; i <= index + [[moduleArray objectAtIndex:index] count]; i++) {
//        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    }
//    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedResource==nil)
        return 0;
    if(indexPath.section==0)
        return 460.0f;
    else if(indexPath.section==1 && selectedResource.comments>0)
    {
        Comments *cmt=selectedResource.comments[indexPath.row];
        CGSize labelSize=[AppGlobal getTheExpectedSizeOfLabel:cmt.commentTxt];
        float height=0.0f;
        NSLog(@"%ld",(long)indexPath.row);
        if(([selectedResource.comments count]<3) && (indexPath.row==[selectedResource.comments count]-1))
        {
           height=80.0f;
                
           
            
        }
        else if([selectedResource.comments count]>=3)
        {
            if(IsCommentExpended && (indexPath.row==[selectedResource.comments count]-1))
            {
                 height=80.0f;
            }else if(indexPath.row==2 && !IsCommentExpended){
             height=80.0f;
            }
            
        }
        
        if(labelSize.height>39)
                return   height=height+80+labelSize.height;
            else
                return  height=height+80;
    }
    else if(indexPath.section==2 )
    {
        float height=0.0f;
       
        if(([selectedResource.relatedResources count]<3) && (indexPath.row==[selectedResource.relatedResources count]-1))
        {
            height=75.0f;
            
            
            
        }
        else if([selectedResource.relatedResources count]>=3)
        {
            if(IsRelatedConentExpended && (indexPath.row==[selectedResource.relatedResources count]-1))
            {
                height=75.0f;
            }else if(indexPath.row==2 && !IsRelatedConentExpended){
                height=75.0f;
            }
            
        }

       
        return  height=height+96.0f;
    
    }
    
    else if(indexPath.section==3)
    {
//        
        float height=0.0f;

        
        return  height=height+96.0f;

    }
    return 44.0f;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    NSLog(@"You are in: %s", __FUNCTION__);
//    //    if (indexPath.row % 2 == 0) //if the row is odd number row
//    //    {
//    //        cell.backgroundColor = [UIColor blackColor];
//    //        cell.textLabel.textColor = [UIColor whiteColor];
//    //    }
//    //    else
//    //    {
//    //        cell.backgroundColor = [UIColor blackColor];
//    //    }
//}
#pragma mark - Keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    //    CGRect frame1 = self.cmtview.frame;
    //    frame1=CGRectMake(0, 400, 320, 40);
    //
    //    self.cmtview.frame=frame1;
    /* Move the toolbar to above the keyboard */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.0];
    if(!isSearching)
    {
    CGRect frame1 = self.cmtview.frame;
    frame1.size.width=keyboardFrameBeginRect.size.width;
    frame1.origin.y = self.view.frame.size.height- (keyboardFrameBeginRect.size.height+39);
    //     frame1.origin.y = self.view.frame.size.height -310;
    //  frame1.origin.y = self.view.frame.size.height -258;
    self.cmtview.frame = frame1;
     txtframe=frame1;
    [self.view bringSubviewToFront: self.cmtview];
    //271-
    }
    //  [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // [keyboardToolbar setItems:cmtview animated:YES];
    /* Move the toolbar back to bottom of the screen */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.3];
    if(!isSearching)
    {
        CGRect frame1 = self.cmtview.frame;
        frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
        self.cmtview.frame = frame1;
     txtframe=frame1;
    }
    //
    //    [UIView commitAnimations];
}
#pragma uitextview deligate and datasource
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //txtview.inputAccessoryView=commentView;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // CGRect frameRect;
    NSString *str=textView.text;
    
    //    NSUInteger count = 0,
    NSUInteger length = [str length];
    
    NSRange range1= [str rangeOfString:@"\n" options:NSBackwardsSearch];
    if((range1.length+range1.location==length)&&[text isEqualToString:@""]&& step>0)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y+30, txtframe.size.width, txtframe.size.height-30);
        
        step=step-1;
    }
    
    if([text isEqualToString:@"\n"]&& step<2)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y-30, txtframe.size.width, txtframe.size.height+30);
        
        step=step+1;
        
    }
    //    CGRect frame1 = frame;
    //    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    
    self.cmtview.frame=txtframe;
    
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}


-(void)fadeInAnimation:(UIView *)aView {
    
    
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
    // [self.view addSubview:objCustom.view];
    [animation setDuration:0.5];
    
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.view layer] addAnimation:animation forKey:nil];
    
    [self.view addSubview:objCustom.view];
    [CATransaction commit];
}


//code for gesture


-(void)fadeInAnimation1:(UIView *)aView {
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [CATransaction setCompletionBlock:^{
    }];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[self.view layer] addAnimation:animation forKey:nil];
    
    
}
- (void)swipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    [self fadeInAnimation1:self.view];
    [objCustom.view removeFromSuperview];
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        // [self.view removeFromSuperview];
        // self.objCustom.view.hidden = NO;
        
        
    }
}
- (IBAction)btnLogoutClick:(id)sender {
    if(  [AppSingleton sharedInstance].isUserFBLoggedIn==YES)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
    }
    [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
    [AppSingleton sharedInstance].isUserLoggedIn=NO;
    [self.tabBarController.tabBar setHidden:YES];
    LoginViewController *viewCont= [[LoginViewController alloc]init];
    [self.navigationController pushViewController:viewCont animated:YES];
    
}

@end
