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

#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "SubCommentTableViewCell.h"
#import "UpdateProfileViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import <Social/Social.h>
AFNetworkReachabilityStatus previousStatus;

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
    CGPoint mPreviousTouchPoint;
    EGRIDVIEW_SCROLLDIRECTION  mSwipeDirection;
    BOOL isTableSelect;
    CGFloat screenHeight ;
    NSMutableArray *tableViewCellsArray;
      NSMutableArray *tableViewCellsRelatedResourseArray;
    CGFloat screenWidth;
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

@synthesize pageViews = _pageViews;
@synthesize pageImages = _pageImages;
@synthesize step,title,txtViewCMT,objCustom;;
@synthesize moviePlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Set up the image we want to scroll & zoom and add it to the scroll view
    //iOS7 Customization, swipe to pop gesture
    previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
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
   // self.scrollView.contentInset.bottom=200.0f;

   //  self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -5, 0);
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
   screenHeight = [UIScreen mainScreen].bounds.size.height;
   screenWidth = [UIScreen mainScreen].bounds.size.width;
    profileFrame.size.height=screenHeight-50;
    profileFrame.size.width=screenWidth;//200;
    objCustom.view.frame=profileFrame;
   [objCustom.btnLogout  addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    isTableSelect=NO;
    if(feedId==nil){
        
        [self getModuleDetail:@""];
        
    }else{
      [self getModuleDetailByFeed];
        
    }
    
    
    
    

    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(status==AFNetworkReachabilityStatusNotReachable)
        {   previousStatus=status;
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        }else{
            previousStatus=status;
            [self showNetworkStatus:REESTABLISH_INTERNET_MSG newVisibility:YES];
            
        }
        //       else  if(status!=AFNetworkReachabilityStatusNotReachable)
        //       {
        //           previousStatus=status;
        //           [self showNetworkStatus:@""];
        //
        //       }
    }];
 [[AFNetworkReachabilityManager sharedManager] startMonitoring];
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
    tableViewCellsArray=[[NSMutableArray alloc]init];
    tableViewCellsRelatedResourseArray=[[NSMutableArray alloc]init];
    
    
    
    
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
        
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        if( screenHeight < screenWidth ){
            screenHeight = screenWidth;
        }
        
        if( screenHeight > 480 && screenHeight < 667 ){
            NSLog(@"iPhone 5/5s");
        } else if ( screenHeight > 480 && screenHeight < 736 ){
            NSLog(@"iPhone 6");
            [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6Small.png"]];
            
        } else if ( screenHeight > 480 ){
          [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6Small.png"]];
            
            NSLog(@"iPhone 6 Plus");
        } else {
            NSLog(@"iPhone 4/4s");
            
        }
        [txtSearchBar setBackgroundColor:[UIColor clearColor]];
        UITextField *txfSearchField = [txtSearchBar valueForKey:@"_searchField"];
        [txfSearchField setBackgroundColor:[UIColor clearColor]];
        //[txfSearchField setLeftView:UITextFieldViewModeNever];
        [txfSearchField setBorderStyle:UITextBorderStyleNone];
         [txfSearchField setTextColor:[UIColor whiteColor]];
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
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
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
  NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + self.scrollView.frame.size.width) / (self.scrollView.frame.size.width * 2.0f));
    NSInteger currentpage=  page;
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    [self PlayTheVideo:selectedResource.resourceUrl];
}
-(void)PlayTheVideo:(NSString *)stringUrl
{
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
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
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    

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
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    NSInteger currentpage = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + self.scrollView.frame.size.width) / (self.scrollView.frame.size.width * 2.0f));
//    NSInteger currentpage=  page;
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Resource;
    [txtViewCMT becomeFirstResponder];
    

}
- (IBAction)btnLikeOnResourceClick:(id)sender {
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    // call the service
    UIButton *btn=(UIButton *)sender;
    NSInteger currentpage = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + self.scrollView.frame.size.width) / (self.scrollView.frame.size.width * 2.0f));

   
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];

        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
        [[appDelegate _engine] setLikeOnResource:selectedResourceId  success:^(BOOL success) {
    
    
           

            //Hide Indicator
            [appDelegate hideSpinner];
            if(feedId==nil){
                
                [self getModuleDetail:searchText];
                
            }else{
                [self getModuleDetailByFeed];
                
            }

        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                 [self loginError:error];
                                                
    
                                            }];
}
- (IBAction)btnShareOnResourceClick:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    NSInteger currentpage =
    (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f +
                      self.scrollView.frame.size.width) / (self.scrollView.frame.size.width *
                                                           2.0f));
    
    
    // get the current Content
    selectedResource=[contentList objectAtIndex:currentpage];
    selectedResourceId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    
    // get the current Content
    
    // Update *update=[arrayUpdates objectAtIndex:btn.tag];
    NSURL *url = [NSURL URLWithString:selectedResource.resourceUrl];
    if([SLComposeViewController
        isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController * fbSheetOBJ = [SLComposeViewController
                                                composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *strText = [NSString
                             stringWithFormat:@"%@",selectedResource.resourceDesc];
        //      NSString *strText = [NSString stringWithFormat:@"%@\n%@",[self updateTitle:update],update.resource.resourceDesc];
        [fbSheetOBJ  setInitialText:selectedResource.resourceDesc];
        
        [fbSheetOBJ addImage:[UIImage
                              imageWithData:selectedResource.resourceImageData]];
        
        [fbSheetOBJ addURL:url];
        
        
        
        
        [self presentViewController:fbSheetOBJ animated:YES
                         completion:Nil];
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in!" message:@"Please Facebook Log In first !" delegate:nil
                                             cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
    
    
}

#pragma mark - Reply and like on Comment

- (IBAction)btnReplyOnCommentClick:(id)sender {
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Comment;
    [txtViewCMT becomeFirstResponder];

}
- (IBAction)btnLikeOnCommentClick:(id)sender {
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setLikeOnComment:selectedCommentId AndisFeed:NO success:^(BOOL success) {
       //Hide Indicator
        
        [appDelegate hideSpinner];
        
        if(feedId==nil){
            
            [self getModuleDetail:searchText];
            
        }else{
            [self getModuleDetailByFeed];
            
        }

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
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    if([txtViewCMT.text isEqualToString:@""])
    {
      //  [AppGlobal showAlertWithMessage:MISSING_COMMENT title:@""];
        txtViewCMT.text=@"";
        CGRect frame1 = self.cmtview.frame;
        frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
        txtframe=frame1;
         step=0;
    }
   
    // call the service
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    if (actionOn==Resource) {
        [[appDelegate _engine] setCommentOnResource:selectedResourceId AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            [appDelegate hideSpinner];
            txtViewCMT.text=@"";
            if(feedId==nil){
                
                [self getModuleDetail:searchText];
                
            }else{
                [self getModuleDetailByFeed];
                
            }
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
             txtViewCMT.text=@"";
            if(feedId==nil){
                
                [self getModuleDetail:searchText];
                
            }else{
                [self getModuleDetailByFeed];
                
            }
        }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                [self loginError:error];
                                                
                                            }];

    }
   
   
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
    if(feedId==nil){
        
        [self getModuleDetail:searchText];
        
    }else{
        [self getModuleDetailByFeed];
        
    }
    // [self searchTableList];
    isSearching=NO;
}
#pragma mark Course Private functions
-(void) getModuleDetail:(NSString *) txtSearch
{
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance ].userDetail.userId];
    // userid=@"1";
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getModuleDetail:userid AndTextSearch:txtSearch AndSelectModule:self.selectedModule AndSelectCourse:self.selectedCourse success:^(NSDictionary *moduleDetails) {
        
        contentList=[moduleDetails objectForKey:@"resourceList"];
        assignmentList=[moduleDetails objectForKey:@"assignmentList"];
        for (Resourse *resource in contentList) {
            if([resource.resourceId isEqualToString:selectedResource.resourceId])
            {
                selectedResource=resource;
                break;
            }
        }
        
        //Hide Indicator
        [appDelegate hideSpinner];
        if (isTableSelect) {
            [tblViewContent reloadData];
        }else{
            NSInteger pageCount = [contentList count];
            
            // Set up the page control
//            NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + self.scrollView.frame.size.width) / (self.scrollView.frame.size.width * 2.0f));
            
            
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
            
        }
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
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] getModuleDetail:feedId success:^(NSDictionary *moduleDetails)
     {
         //Hide Indicator
        contentList=[moduleDetails objectForKey:@"resourceList"];
        assignmentList=[moduleDetails objectForKey:@"assignmentList"];
         for (Resourse *resource in contentList) {
             if([resource.resourceId isEqualToString:selectedResource.resourceId])
             {
                 selectedResource=resource;
                 break;
             }
         }
         
         //Hide Indicator
         [appDelegate hideSpinner];
         if (isTableSelect) {
             [tblViewContent reloadData];
         }else{
        NSInteger pageCount = [contentList count];
        
        // Set up the page control
         NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + self.scrollView.frame.size.width) / (self.scrollView.frame.size.width * 2.0f));
         

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
         }
      
        
        
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
        frame.origin.y = 10.0f;
        frame = CGRectInset(frame, 5.0f, 0.0f);
        Resourse *resource=[contentList objectAtIndex:page];
        CustomContentView *customView= [[CustomContentView alloc]init];
        customView.lblAutherName.text=resource.authorName;
        NSDate *dateSatrtedOn = [AppGlobal convertStringDateToNSDate:resource.startedOn];
        NSDate *dateCompletedOn = [AppGlobal convertStringDateToNSDate:resource.completedOn];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components ;
        NSString *monthName;
         NSDateFormatter *df = [[NSDateFormatter alloc] init];
        if(dateSatrtedOn!=nil)
        {
         components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dateSatrtedOn]; // Get necessary date components
        monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        resource.startedOn=[NSString stringWithFormat:@"%@ %ld,%ld",monthName,(long)components.day,(long)components.year];
       
        }
        if(dateCompletedOn!=nil){
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
             if([AppGlobal checkImageAvailableAtLocal:resource.resourceImageUrl])
             {
                 resource.resourceImageData=[AppGlobal getImageAvailableAtLocal:resource.resourceImageUrl];
             }
             if (resource.resourceImageData==nil) {
                  NSURL *imageURL = [NSURL URLWithString:resource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                        [AppGlobal setImageAvailableAtLocal:resource.resourceImageUrl AndImageData:resource.resourceImageData];
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
       // customView.imgContent.layer.cornerRadius = 12.0f;
        customView.view.layer.cornerRadius = 12.0f;


        [customView.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [customView.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        [customView.btnShare addTarget:self action:@selector(btnShareOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        customView.btnComment.tag=[resource.resourceId integerValue];
        customView.btnLike.tag=[resource.resourceId integerValue];
        customView.btnShare.tag=[resource.resourceId integerValue];
        // add vedio play
        
        [customView.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];

        // set comment for the content
        // check if comment is available
        if([resource.comments  count]>0)
        {
            Comments *objComment=[resource.comments objectAtIndex:0];
            
            if(objComment.commentByImage!=nil){
                
                if([AppGlobal checkImageAvailableAtLocal:objComment.commentByImage])
                {
                    objComment.commentByImageData=[AppGlobal getImageAvailableAtLocal:objComment.commentByImage];
                }
                if(objComment.commentByImageData==nil)
                {
                NSURL *imageURL = [NSURL URLWithString:objComment.commentByImage];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    objComment.commentByImageData=imageData;
                    [AppGlobal setImageAvailableAtLocal:objComment.commentByImage AndImageData:objComment.commentByImageData];
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
            customView.btnCmtBy.tag =[objComment.commentById integerValue];            [customView.btnCmtBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
            NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:objComment.commentDate];
            
            NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
            //   cell.lblCmtDate.text=comment.commentDate;
            scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
                                                               withString:@""];
            // Set label text to attributed string
            NSString *str = [NSString stringWithFormat:@"%@ %@ ago" ,objComment.commentBy,scincetime];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            
            // Set font, notice the range is for the whole string
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
            [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [objComment.commentBy length])];
            [customView.lblCmtBy  setAttributedText:attributedString];
           
           // customView.lblCmtBy.text setat=  objComment.commentBy;
           
            [customView.btnLikeCMT setTitle:objComment.likeCounts forState:UIControlStateNormal];
           // [customView.btnShareCMT    setTitle:objComment.shareCounts forState:UIControlStateNormal];
            [customView.btnCommentCMT setTitle:objComment.commentCounts forState:UIControlStateNormal];
            customView.txtCmtView.text= objComment.commentTxt;
           
            customView.btnCommentCMT.tag=[objComment.commentId integerValue];
            customView.btnLikeCMT.tag=[objComment.commentId integerValue];
            
            //set action for reply and like on comment
       
            [customView.btnCommentCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            [customView.btnLikeCMT addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            if([objComment.isLike isEqualToString:@"1"])
            {
                customView.btnLikeCMT.selected=YES;
               // [customView.btnLikeCMT setTitle:selectedResource.likeCounts forState:UIControlStateSelected];
            }else
                
            {
                customView.btnLikeCMT.selected=NO;
               // [customView.btnLikeCMT setTitle:selectedResource.likeCounts forState:UIControlStateNormal];
                //[customView.btnLikeCMT addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
            }

        }
        else{
            [customView.btnCmtBy setHidden:YES];
            //[customView.imgViewCmtBy setImage:[UIImage imageWithData:[NSData ns] ]];
           [ customView.lblCmtBy setHidden:YES];
           
            [customView.btnLikeCMT setHidden:YES];
         //   [customView.btnShareCMT   setHidden:YES];
            [customView.btnCommentCMT setHidden:YES];
            [customView.txtCmtView setHidden:YES];
            [customView.lblComment setHidden:YES];
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
     [txtSearchBar resignFirstResponder];
    [txtViewCMT resignFirstResponder];
//    [self fadeInAnimation:self.view];
    UpdateProfileViewController *updateView=[[UpdateProfileViewController alloc]init];
    [self.navigationController pushViewController:updateView animated:YES];
}


-(EGRIDVIEW_SCROLLDIRECTION) getScrollDirection : (CGPoint) startPoint endPoint:(CGPoint) endPoint
{
     EGRIDVIEW_SCROLLDIRECTION direction = eScrollNone;
    
     EGRIDVIEW_SCROLLDIRECTION xDirection;
     EGRIDVIEW_SCROLLDIRECTION yDirection;
    
    int xDirectionOffset = startPoint.x - endPoint.x;
    if(xDirectionOffset > 0)
        xDirection = eScrollLeft;
    else
        xDirection = eScrollRight;
    
    int yDirectionOffset = startPoint.y - endPoint.y;
    if(yDirectionOffset > 0)
        yDirection = eScrollTop;
    else
        yDirection = eScrollBottom;
    
    if(abs(xDirectionOffset) > abs(yDirectionOffset))
        direction = xDirection;
    else
        direction = yDirection;
    
    return direction;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    mPreviousTouchPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGPoint offset = self.scrollView.contentOffset;
    
    //Cool... Restricting diagonal scrolling
     mSwipeDirection = [self getScrollDirection:mPreviousTouchPoint endPoint:self.scrollView.contentOffset];
    switch (mSwipeDirection) {
        case eScrollLeft:
            self.scrollView.contentOffset = CGPointMake(offset.x, mPreviousTouchPoint.y);
            break;
            
        case eScrollRight:
            self.scrollView.contentOffset = CGPointMake(offset.x, mPreviousTouchPoint.y);
            break;
            
        case eScrollTop:
            self.scrollView.contentOffset = CGPointMake(mPreviousTouchPoint.x, offset.y);
            break;
            
        case eScrollBottom:
            self.scrollView.contentOffset = CGPointMake(mPreviousTouchPoint.x, offset.y);
            break;
            
        default:
            break;
    }
//     NSLog(@"running");
//        ScrollDirection scrollDirection;
//        if(  self.scrollView.tag==20){
//            if ( self.scrollView.contentOffset.y >2)
//            {
//                scrollDirection = ScrollDirectionDown;
//                
//                
//                self.lastContentOffset =  self.scrollView.contentOffset.y;
//                
//                // get current page;
//                NSInteger currentpage=  self.pageControl.currentPage;
//                // get the current Content
//                selectedResource=[contentList objectAtIndex:currentpage];
//                // CATransition *animation = [CATransition animation];
//                //        animation.type = kCATransitionFade;
//                //        animation.duration = 0.0;
//                //        [scrollView.layer addAnimation:animation forKey:nil];
//                //
//                //        scrollView.hidden = YES;
//                [UIView transitionWithView: self.scrollView
//                                  duration:0.4
//                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                                animations:NULL
//                                completion:NULL];
//                self.scrollView.hidden=YES;
//                [tblViewContent reloadData];
//                tblViewContent.hidden =NO;
//                //button.layer.shouldRasterize = YES;
//            }else {
//                self.lastContentOffset =  self.scrollView.contentOffset.y;
//                
//            }
//        }else if(  self.scrollView.tag==10){
//            if ( self.scrollView.contentOffset.y<-2)
//            {
//                scrollDirection = ScrollDirectionDown;
//                
//                
//                self.lastContentOffsetOfTable =  self.scrollView.contentOffset.y;
//                
//                [UIView transitionWithView: self.scrollView
//                                  duration:0.4
//                                   options:UIViewAnimationOptionTransitionCrossDissolve
//                                animations:NULL
//                                completion:NULL];
//                self.scrollView.hidden=NO;
//                // [tblViewContent reloadData];
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
//                self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * [contentList count], pagesScrollViewSize.height+5);
//                [self loadVisiblePages];
//                //button.layer.shouldRasterize = YES;
//            }else {
//                self.lastContentOffsetOfTable =  self.scrollView.contentOffset.y;
//                
//            }
//        }
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate==YES)
    {
        NSLog(@"running");
        ScrollDirection scrollDirection;
        if( scrollView.tag==20){
            if (scrollView.contentOffset.y >2)
            {
                scrollDirection = ScrollDirectionDown;
                
                
                self.lastContentOffset = scrollView.contentOffset.y;
                
                // get current page;
                NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + scrollView.frame.size.width) / ( scrollView.frame.size.width * 2.0f));
                
                // Update the page control
                isTableSelect=YES;
                NSInteger currentpage=  page;
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
            if (scrollView.contentOffset.y<-2)
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
                isTableSelect=NO;
                tblViewContent.hidden =YES;
                NSInteger pageCount = [contentList count];
                
                // Set up the page control
               // self.pageControl.currentPage = ;
//                NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + self.scrollView.frame.size.width) / (self.scrollView.frame.size.width * 2.0f));
                

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
            if([AppGlobal checkImageAvailableAtLocal:selectedResource.resourceImageUrl])
            {
                selectedResource.resourceImageData=[AppGlobal getImageAvailableAtLocal:selectedResource.resourceImageUrl];
            }
            if (selectedResource.resourceImageData==nil) {
                NSURL *imageURL = [NSURL URLWithString:selectedResource.resourceImageUrl];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    selectedResource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                    
                    [AppGlobal setImageAvailableAtLocal:selectedResource.resourceImageUrl AndImageData:selectedResource.resourceImageData];
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
             [cell.btnLike addTarget:self action:@selector(btnLikeOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.btnComment.tag=[selectedResource.resourceId integerValue];
        cell.btnLike.tag=[selectedResource.resourceId integerValue];
        cell.btnShare.tag=[selectedResource.resourceId integerValue];
        //set action for comment and like on resource
        [cell.btnComment addTarget:self action:@selector(btnCommentOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
     
        [cell.btnShare addTarget:self action:@selector(btnShareOnResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        
       [cell.btnComment setTitle:selectedResource.commentCounts forState:UIControlStateNormal];
        if([selectedResource.comments count]>0)
        {
            cell.lblNextTitle.text=@"Comments:";
        }else if ([selectedResource.relatedResources count]>0)
        {
            cell.lblNextTitle.text=@"Related Videos:";

        }else if ([assignmentList count]>0)
        {
            cell.lblNextTitle.text=@"Assignment:";

        }else{
            cell.lblNextTitle.hidden=YES;
        }
        [tableViewCellsArray addObject:cell];
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
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
            [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [comment.commentBy length])];
            [cell.lblCmtBy setAttributedText:attributedString];     //   cell.lblCmtDate.text=comment.commentDate;
        cell.lblCmtText.text=comment.commentTxt;

        if(comment.commentBy!=nil)
        {
            [cell.btnCommentedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnCommentedBy.tag = [comment.commentById integerValue];
        }

        
        if(comment.commentByImage!=nil){
            if([AppGlobal checkImageAvailableAtLocal:comment.commentByImage])
            {
                comment.commentByImageData=[AppGlobal getImageAvailableAtLocal:comment.commentByImage];
            }

            if(comment.commentByImageData==nil)
            {

            NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                comment.commentByImageData=imageData;
                [AppGlobal setImageAvailableAtLocal:comment.commentByImage AndImageData:comment.commentByImageData];

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
            [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
        }
       
        [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
      
        cell.btnCMT.tag=[comment.commentId integerValue];
        cell.btnLike.tag=[comment.commentId integerValue];
       
        //set action for reply and like on comment
        [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    
        
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
            if ([selectedResource.relatedResources count]>0)
            {
                cell.lblRelatedVideo.text=@"Related Videos:";
                
            }else if ([assignmentList count]>0)
            {
                cell.lblRelatedVideo.text=@"Assignment:";
                
            }else{
             cell.lblRelatedVideo.hidden=YES;
            }
            [tableViewCellsArray addObject:cell];
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
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
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
                if([AppGlobal checkImageAvailableAtLocal:comment.commentByImage])
                {
                    comment.commentByImageData=[AppGlobal getImageAvailableAtLocal:comment.commentByImage];
                }
                if(comment.commentByImageData==nil)
                {
                    
                    NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                        comment.commentByImageData=imageData;
                        [AppGlobal setImageAvailableAtLocal:comment.commentByImage AndImageData:comment.commentByImageData];

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
                [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
           // [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
            
         //   cell.btnCMT.tag=[comment.commentId integerValue];
            cell.btnLike.tag=[comment.commentId integerValue];
            
            //set action for reply and like on comment
          //  [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
           
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
            if ([selectedResource.relatedResources count]>0)
            {
                cell.lblRelatedVideo.text=@"Related Videos:";
                
            }else if ([assignmentList count]>0)
            {
                cell.lblRelatedVideo.text=@"Assignment:";
                
            }else{
                cell.lblRelatedVideo.hidden=YES;
            }
[tableViewCellsArray addObject:cell];
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
        cell.lblContentName.text= resource.resourceTitle;
        NSString *str = [NSString stringWithFormat:@"by %@" ,resource.authorName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        // Set font, notice the range is for the whole string
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(3, [resource.authorName length])];
        [cell.lblContentby setAttributedText:attributedString];

       // cell.lblSubmittedDate.text=resource.uploadedDate;
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:resource.uploadedDate];
       
        if(resource.resourceImageUrl!=nil){
            if([AppGlobal checkImageAvailableAtLocal:resource.resourceImageUrl])
            {
                resource.resourceImageData=[AppGlobal getImageAvailableAtLocal:resource.resourceImageUrl];
            }
            if(resource.resourceImageData==nil)
            {
            NSURL *imageURL = [NSURL URLWithString:resource.resourceImageUrl];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                resource.resourceImageData = [NSData dataWithContentsOfURL:imageURL];
               [AppGlobal setImageAvailableAtLocal:resource.resourceImageUrl AndImageData:resource.resourceImageData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    
                    UIImage *img=[UIImage imageWithData:resource.resourceImageData];
                    if(img!=nil)
                       cell.imgContentURL.image= img;

                });
            });
        }else{
            UIImage *img=[UIImage imageWithData:resource.resourceImageData];
            cell.imgContentURL.image= img;
            [ cell.imgContentURL setBackgroundColor:[UIColor clearColor]];
        }
        }
        
        if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        cell.lblSubmittedDate.text=[NSString stringWithFormat:@"Uploaded on %@ %ld",monthName,(long)components.day ];
        }
      cell.btnPlay.tag= indexPath.row;
        [cell.btnPlay  addTarget:self action:@selector(btnPlayRelatedResourceClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.imgHalfDevide.hidden=NO;
       
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
                 cell.imgHalfDevide.hidden=YES;
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
        if ([assignmentList count]>0)
        {
            cell.lblAssignment.text=@"Assignment:";
            
        }else{
            cell.lblAssignment.hidden=YES;
        }
[tableViewCellsRelatedResourseArray addObject:cell];
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
        NSString *str = [NSString stringWithFormat:@"by %@" ,assignment.assignmentSubmittedBy];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        // Set font, notice the range is for the whole string
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(3, [assignment.assignmentSubmittedBy length])];
        [cell.lblContentby setAttributedText:attributedString];
        
       
        if(resource!=nil)
        {
        
        if(resource.resourceImageUrl!=nil){
            if([AppGlobal checkImageAvailableAtLocal:resource.resourceImageUrl])
            {
                resource.resourceImageData=[AppGlobal getImageAvailableAtLocal:resource.resourceImageUrl];
            }
            if(resource.resourceImageData==nil)
            {
            NSURL *imageURL = [NSURL URLWithString:resource.resourceImageUrl];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
               
                     resource.resourceImageData = [NSData dataWithContentsOfURL:imageURL];
                  [AppGlobal setImageAvailableAtLocal:resource.resourceImageUrl AndImageData:resource.resourceImageData];
               dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    //cell.imgContentURL.image= [UIImage imageWithData:imageData];
                    UIImage *img=[UIImage imageWithData: resource.resourceImageData];
                    if(img!=nil)
                         cell.imgContentURL.image= img;

                });
            });
        }else{
            UIImage *img=[UIImage imageWithData:resource.resourceImageData];
            cell.imgContentURL.image= img;
            [ cell.imgContentURL setBackgroundColor:[UIColor clearColor]];
        }
        }
        
        
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.assignmentSubmittedDate];
       if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
    
           cell.lblSubmittedDate.text=[NSString stringWithFormat:@"Submitted on %@ %ld",monthName,(long)components.day ];
       }
        
        cell.btnPlay.tag= indexPath.row;
        [cell.btnPlay  addTarget:self action:@selector(btnPlayAssignmentClick:) forControlEvents:UIControlEventTouchUpInside];
        
        }else{
        
            cell.btnPlay.hidden=YES;
            [cell.imgContentURL setImage:[UIImage imageNamed:@"imPending.png"]];
            cell.lblSubmittedDate.hidden=YES;
            
        }
        if(indexPath.row!=([assignmentList count]-1))
        {
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
            cell.lblAssignment.hidden=YES;
        }else{
            if([assignmentList count]>3)
            {
                [cell.btnMore addTarget:self action:@selector(btnMoreRelatedVideoClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnMore setTitle:[NSString stringWithFormat:@"+%u More",[assignmentList count ]-3]  forState:UIControlStateNormal];
            }else{
                cell.btnMore.hidden=YES;
            }
        }
        
         cell.lblAssignment.hidden=YES;
        [tableViewCellsArray addObject:cell];
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
//    int section=indexPath.section;
//    //add the cells to a mutable array
//    if(section==2 && IsRelatedConentExpended)
//    {
//        //the nil scenario happens when the cell is created for first time
//        if([tableViewCellsRelatedResourseArray count]>indexPath.row){
//        UITableViewCell *cell=[tableViewCellsRelatedResourseArray objectAtIndex:indexPath.row];
//        //your code here
//          AssignmentTableViewCell *cmtcell=(AssignmentTableViewCell*)cell;
//            NSLog(@"%f",cmtcell.lblContentName.frame.size.width);
//        }
//
//         [selectedResource.relatedResources count];
//    }
//    else if(section==2 && !IsRelatedConentExpended)
//    {
//        //the nil scenario happens when the cell is created for first time
//       
//        //your code here
//        if([tableViewCellsRelatedResourseArray count]>indexPath.row){
//             UITableViewCell *cell=[tableViewCellsRelatedResourseArray objectAtIndex:indexPath.row];
//        AssignmentTableViewCell *cmtcell=(AssignmentTableViewCell*)cell;
//        NSLog(@"%f",cmtcell.lblContentName.frame.size.width);
//        }
//        
//       
//    }
   
       
    
   
    
    if(selectedResource==nil)
        return 0;
    if(indexPath.section==0)
        return 430.0f;
    else if(indexPath.section==1 && selectedResource.comments>0)
    {
        
        
                      float height=0.0f;
        NSLog(@"%ld",(long)indexPath.row);
        if(([selectedResource.comments count]<3) && (indexPath.row==[selectedResource.comments count]-1))
        {
           height=55.0f;
                
        }
        else if([selectedResource.comments count]>=3)
        {
            if(IsCommentExpended && (indexPath.row==[selectedResource.comments count]-1))
            {
                 height=55.0f;
            }else if(indexPath.row==2 && !IsCommentExpended){
             height=55.0f;
            }
            
        }
        Comments *comment=selectedResource.comments[indexPath.row];
        float width=200;
        if( screenHeight <740 && screenHeight >667 )
        {
            width=298;
            
        }else if  (screenHeight > 568 && screenHeight <= 667 )
        {
            width=270;
        }
        CGSize labelSize=[AppGlobal   getTheExpectedSizeOfLabel:comment.commentTxt andFontSize:13 labelWidth:width];
        if(labelSize.height>17)
                return   height=height+80+labelSize.height-17.0;
            else
                return  height=height+80;
    }
    else if(indexPath.section==2 )
    {
        float height=73.0f;
        static NSString *identifier = @"AssignmentTableViewCell";
        AssignmentTableViewCell *cell = (AssignmentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        NSLog(@"%f",cell.lblContentName.frame.size.width);
        if(([selectedResource.relatedResources count]<3) && (indexPath.row==[selectedResource.relatedResources count]-1))
        {
            height=height+50.0f;
            
            
            
        }
        else if([selectedResource.relatedResources count]>=3)
        {
            if(IsRelatedConentExpended && (indexPath.row==[selectedResource.relatedResources count]-1))
            {
                height=height+60.0f;
            }else if(indexPath.row==2 && !IsRelatedConentExpended){
                height=height+66.0f;
            }
            
        }
       
        Resourse *realtedResource=selectedResource.relatedResources[indexPath.row];
        float width=200;
        if( screenHeight <740 && screenHeight >667 )
        {
            width=298;
            
        }else if  (screenHeight > 568 && screenHeight <= 667 )
        {
            width=270;
        }
        CGSize labelSize=[AppGlobal   getTheExpectedSizeOfLabel:realtedResource.resourceTitle andFontSize:13 labelWidth:width];
        
//        if(labelSize.height>17){
             return  height=height+labelSize.height-17;
       // }
//        else if([realtedResource.resourceTitle length]>34 &&  (screenHeight > 480 && screenHeight < 667 ))
//        {
//            
//            return  height=height+labelSize.height;
//        }else if([realtedResource.resourceTitle length]>42 &&  screenHeight < 480)
//        {
//            
//            return  height=height+labelSize.height;
//        }
        
        return height;
//        else
//            return  height=height+70.0f;;
       
       
    
    }
    
    else if(indexPath.section==3)
    {
//
        float height=73.0f;
        
        if(([assignmentList count]<3) && (indexPath.row==[assignmentList count]-1))
        {
            height=height+30.0f;
            
            
            
        }
        else if([assignmentList count]>=3)
        {
            if(IsAsignmentExpended && (indexPath.row==[assignmentList count]-1))
            {
                height=height+56.0f;
            }else if(indexPath.row==2 && !IsAsignmentExpended){
                height=height+56.0f;
            }
            
        }
        Assignment *assignment=assignmentList[indexPath.row];
       
        float width=200;
        if( screenHeight <740 && screenHeight >667 )
        {
            width=298;
            
        }else if  (screenHeight > 568 && screenHeight <= 667 )
        {
            width=270;
        }
        CGSize labelSize=[AppGlobal   getTheExpectedSizeOfLabel:assignment.assignmentName  andFontSize:13 labelWidth:width];
        
        //        if(labelSize.height>17){
        return  height=height+labelSize.height-17;
        // }

//        
//        if(labelSize.height>17){
//            return  height=height+labelSize.height-10;
//        }else if([assignment.assignmentName length]>34 &&  (screenHeight > 480 && screenHeight < 667 ))
//        {
//            
//            return  height=height+labelSize.height;
//        }else if([assignment.assignmentName length]>42 &&  screenHeight < 480)
//        {
//            
//            return  height=height+labelSize.height;
//        }
       // return height;

    }
    //create cell
    
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
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
    [AppSingleton sharedInstance].isUserLoggedIn=NO;
    [self.tabBarController.tabBar setHidden:YES];
    LoginViewController *viewCont= [[LoginViewController alloc]init];
    [self.navigationController pushViewController:viewCont animated:YES];
    
}

- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}


@end
