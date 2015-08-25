//
//  AssignmentViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "AssignmentViewController.h"
#import "CourseViewController.h"
#import "UpdateViewController.h"
#import "AssignmentDetailTableViewCell.h"
#import "Update.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ModuleDetailViewController.h"
#import "CourseViewController.h"
#import "SubmitAssignmentViewController.h"
#import "SubmitContentViewController.h"

@interface AssignmentViewController ()
{
    NSMutableArray *arrayAssignment;
    BOOL isSearching;
    CGRect txtframe;
    NSString    *searchText;
    NSString *selectedCommentId,*selectedUpdateId;
    ActionOn  actionOn;
    UIWebView *videoView;
}
@end

@implementation AssignmentViewController
@synthesize txtSearchBar,tblViewContent;
@synthesize step, moviePlayer,objCustom;

- (void)viewDidLoad {
    [super viewDidLoad];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    if(  [AppSingleton sharedInstance].isUserLoggedIn!=YES)
    {
        [self.tabBarController.tabBar setHidden:YES];
        HomeViewController *viewController= [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        
        //        FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
        [self.tabBarController.tabBar setHidden:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // Custom initialization
    [self setSearchUI];
    objCustom = [[CustomProfileView alloc] init];
    NSLog(@"%f,%f",self.view.frame.size.height,self.view.frame.size.width);
    objCustom.center = CGPointMake(200, 400);
    CGRect frame1=objCustom.view.frame ;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    frame1.size.height=screenHeight-50;
    frame1.size.width=screenWidth;//200;
    objCustom.view.frame=frame1;
    
    [objCustom.btnLogout  addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
  

//    CGRect cmtFrame = self.cmtview.frame;
//    cmtFrame=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
//    txtframe=cmtFrame;
//    self.cmtview.frame=cmtFrame;
//    [self.view addSubview:self.cmtview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
   // [txtViewCMT resignFirstResponder];
    isSearching=NO;
   // txtViewCMT.text=@"";
    step=0;
    
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
            [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6.png"]];
            
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
        [txfSearchField setTextColor:[UIColor whiteColor]];

    }
}

- (void)viewWillAppear:(BOOL)animated{
    // [super viewWillAppear:animated];
    /* Listen for keyboard */
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [objCustom.view addGestureRecognizer:recognizer];
    NSLog(@"%d", [AppSingleton sharedInstance].isUserLoggedIn);
    
    
    //set Profile
    [objCustom setUserProfile];
    
    [self  getAssignment:@""];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Assignment Private functions
-(void) getAssignment:(NSString *) txtSearch
{
    
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId];
    if([userid isEqualToString:@"(null)"])
        return ;
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getMyAssignments:userid  AndTextSearch:txtSearch success:^(NSMutableArray *assignments) {
        arrayAssignment=assignments;
        
        
        [tblViewContent reloadData];
        // [self loginSucessFullWithFB];
        
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
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    UIViewController *vc = tabBarController.selectedViewController;
//
//    if (tabBarController.selectedIndex == 0) {
//
//    }
//    return YES;
//}

//- (IBAction)btnAssignmentClick:(id)sender {
//}
//
//- (IBAction)btnCourseClick:(id)sender {
//    CourseViewController *courseView= [[CourseViewController alloc]init];
//    [self.navigationController pushViewController:courseView animated:YES];
//
//
//}
//
//- (IBAction)btnNotificationClick:(id)sender {
//}
//
//- (IBAction)btnUpdateClick:(id)sender {
//}
//- (IBAction)btnMoreClick:(id)sender {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    int rowCount=0;
//    Update *update=arrayAssignment[section];
//    
//    if(update.isExpend)
//    {
//        rowCount=[update.comments count]+1;
//    }else{
//        if([update.comments count]<3)
//        {
//            rowCount=[update.comments count]+1;
//        }
//        else{
//            rowCount=3;
//        }
//        
//        
//    }
    return [arrayAssignment count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *identifier = @"AssignmentDetailTableViewCell";
        AssignmentDetailTableViewCell *cell = (AssignmentDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Assignment *assignment=[arrayAssignment objectAtIndex:indexPath.row];
        
        // create custom view for title
        cell.lblAssignmentTitle.text =assignment.assignmentName;
   
               //  cell.viewDetail.frame=CGRectMake(0, 0, x, 60);
    cell.btnExpend.tag=indexPath.row;
    [cell.btnExpend  addTarget:self action:@selector(btnExpendClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnExpend setImage:[UIImage imageNamed:@"icn_arrow.png"] forState:UIControlStateNormal];
    [cell.imgResource setHidden:YES];
    [cell.btnPlay setHidden:YES];
    [cell.lblAssignementDetail  setHidden:YES];
    [cell.lblUploadedDate setHidden:YES];
    [cell.btnSubmit setHidden:YES];
    if(assignment.isExpend){
        
        [cell.btnExpend setImage:[UIImage imageNamed:@"icn_arrow-expand.png"] forState:UIControlStateNormal];
        if(assignment.assignmentDesc!=nil)
        {
            
            cell.lblAssignementDetail.text=assignment.assignmentDesc;
          
            
            //            if(labelSize.height>39)
         
            [cell.lblAssignementDetail  setHidden:NO];
        }
    
        if (assignment.attachedResource!=nil) {
            
            if(assignment.attachedResource.resourceImageUrl!=nil){
                cell.btnPlay.tag=indexPath.row;
                [cell.btnPlay setHidden:NO];
                    [cell.imgResource setHidden:NO];
                [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
                if (assignment.attachedResource.resourceImageData==nil) {
                    NSURL *imageURL = [NSURL URLWithString:assignment.attachedResource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                       assignment.attachedResource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            UIImage *img=[UIImage imageWithData:assignment.attachedResource.resourceImageData];
                            if(img!=nil)
                            {
                                [cell.imgResource setImage:img];
                                
                                [cell.imgResource setBackgroundColor:[UIColor clearColor]];
                            }
                        });
                    });
                }else{
                    UIImage *img=[UIImage imageWithData:assignment.attachedResource.resourceImageData];
                    [cell.imgResource setImage:img];
                    
                    [cell.imgResource setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
    }
    // Set label text to attributed string
    NSString *str = [NSString stringWithFormat:@"%@ > %@" ,assignment.course.courseName,assignment.module.moduleName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    // Set font, notice the range is for the whole string
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [assignment.course.courseName length])];
    
//    // Set foreground color for entire range
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:[UIColor colorWithRed:0.989 green:0.822 blue:0.220 alpha:1.000]
//                             range:NSMakeRange(0, [attributedString length])];
//    
//    // Define Shadow object
//    NSShadow *shadow = [[NSShadow alloc] init];
//    [shadow setShadowColor:[UIColor colorWithRed:0.053 green:0.088 blue:0.205 alpha:1.000]];
//    [shadow setShadowBlurRadius:4.0];
//    [shadow setShadowOffset:CGSizeMake(2, 2)];
    
//    [attributedString addAttribute:NSShadowAttributeName
//                             value:shadow
//                             range:NSMakeRange(0, [attributedString length])];
 
    
    [cell.lblCourse setAttributedText:attributedString];
//    cell.lblCourse.text=assignment.course.courseName;
//    cell.lblModule.text=assignment.module.moduleName;
    cell.btnSubmit.tag =indexPath.row;
    NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.assignmentSubmittedDate];
    if(submittedDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        cell.lblDateAssignment.text=[NSString stringWithFormat:@"%@ %ld",[monthName substringToIndex:3],(long)components.day];
    }
  //  cell.lblDateAssignment.text=assignment.assignmentSubmittedDate;
    
    if([assignment.assignmentStatus isEqualToString:@"1"])
    {
        NSDate *today10am =[NSDate date];
      
        if ([submittedDate compare:today10am] == NSOrderedDescending)
        {
        cell.btnAssignmentStatus.selected=YES;
    
        [cell.btnAssignmentStatus setBackgroundColor:[UIColor whiteColor]];
        [cell.btnSubmit  addTarget:self action:@selector(btnSubmitAssignmentClick:) forControlEvents:UIControlEventTouchUpInside];
       // lblDateAssignment.text
        
      
        cell.lblDateAssignment.textColor =[UIColor blackColor];
        }else{
            
            cell.btnAssignmentStatus.selected=NO;
            [cell.btnSubmit  addTarget:self action:@selector(btnSubmitAssignmentClick:) forControlEvents:UIControlEventTouchUpInside];
           // cell.lblDateAssignment.text=assignment.assignmentSubmittedDate;
            cell.lblDateAssignment.textColor =[UIColor whiteColor];
        
        }
        if(assignment.isExpend)
          [cell.btnSubmit setHidden:NO];
        
    }
    
    else if([assignment.assignmentStatus isEqualToString:@"2"])
    {
        cell.btnAssignmentStatus.highlighted =YES;
        cell.lblDateAssignment.textColor =[UIColor whiteColor];
        
        [cell.btnAssignmentStatus setBackgroundColor:[UIColor greenColor]];
         if(assignment.isExpend)
        [cell.lblUploadedDate setHidden:NO];
     
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.attachedResource.uploadedDate];
        if(submittedDate!=nil){
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
            cell.lblUploadedDate.text=[NSString stringWithFormat:@"Submitted on %@ %ld",[monthName substringToIndex:3],(long)components.day];
        }
    }
    else if([assignment.assignmentStatus isEqualToString:@"3"])
    {
        cell.btnAssignmentStatus.highlighted =YES;
        cell.lblDateAssignment.textColor =[UIColor whiteColor];
        
        [cell.btnAssignmentStatus setBackgroundColor:[UIColor greenColor]];
        if(assignment.isExpend)
            [cell.lblUploadedDate setHidden:NO];
       
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.attachedResource.uploadedDate];
        if(submittedDate!=nil){
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
            cell.lblUploadedDate.text=[NSString stringWithFormat:@"Submitted on %@ %ld",[monthName substringToIndex:3],(long)components.day];
        }
    }
                //set action for comment and like on resource
            
        return cell;
   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//   
//    Assignment *assignment=[arrayAssignment objectAtIndex:indexPath.row];
//    if( assignment.isExpend==YES)
//        assignment.isExpend=NO;
//    else
//        assignment.isExpend=YES;
//    [tblViewContent reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([arrayAssignment count]==0)
        return 0;
    Assignment *assignment=arrayAssignment[indexPath.row];
    if(assignment.isExpend==NO)
    {
        return 90.0f;
        
    }else{
        float height=90.0f;
        if(assignment.attachedResource!=nil)
        {
            
            height=height+163.0f;
        }
        if(assignment.assignmentDesc!=nil){
            
            CGSize labelSize=[AppGlobal getTheExpectedSizeOfLabel:assignment.assignmentDesc];
            NSLog(@"%ld",(long)indexPath.row);
            
            if(labelSize.height>20)
                height=height+labelSize.height;
        }
        if(assignment.course.courseName!=nil){
            
            CGSize labelSize=[AppGlobal getTheExpectedSizeOfLabel:assignment.course.courseName];
            NSLog(@"%ld",(long)indexPath.row);
            
                     if(labelSize.height>20)
            height=height+labelSize.height;
        }
        

        if(![assignment.assignmentStatus isEqualToString:@"3"])
        {
            height=height+42.0f;
        }// if assignment not submitted
        return height;
    }
  
    
    

}
#pragma mark - table cell Action


- (IBAction)btnExpendClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    Assignment *assignment=[arrayAssignment objectAtIndex:btn.tag];
    if( assignment.isExpend==YES)
      assignment.isExpend=NO;
    else
         assignment.isExpend=YES;
    [tblViewContent reloadData];
}
- (IBAction)btnSubmitAssignmentClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    Assignment *assignment=[arrayAssignment objectAtIndex:btn.tag];
    SubmitAssignmentViewController *submitViewController=[[SubmitAssignmentViewController alloc]init];
    submitViewController.assignment=assignment;
    [self.navigationController pushViewController:submitViewController animated:YES];
 // [AppGlobal showAlertWithMessage:MISSING_SUBMIT_FUNC title:@""];
    
    
//    SubmitContentViewController *submitViewController=[[SubmitContentViewController alloc]init];
//      submitViewController.assignment=assignment;
//    [self.navigationController pushViewController:submitViewController animated:YES];
}

#pragma mark - Comment and like on Assignment

- (IBAction)btnPlayResourceClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    Assignment *assign=[arrayAssignment objectAtIndex:btn.tag];
    Resourse *resourse =assign.attachedResource;
       if([resourse.resourceUrl containsString:@"youtube"])
    {
        [self embedYouTube:resourse.resourceUrl  frame:self.view.frame];
      [appDelegate self].allowRotation = YES;
    }else {
        [self PlayTheVideo:resourse.resourceUrl];

    }
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
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    
    
    
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



- (IBAction)btnProfileClick:(id)sender {
    [txtSearchBar resignFirstResponder];
    [self fadeInAnimation:self.view];
}



#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
   // [txtViewCMT resignFirstResponder];
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
    [self  getAssignment:txtSearchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    searchText=searchBar.text;
    [self  getAssignment:txtSearchBar.text];
    [searchBar resignFirstResponder];
    isSearching=NO;
}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}


-(void)fadeInAnimation:(UIView *)aView {
    
    
    [CATransaction begin];
    CATransition *animation = [CATransition animation];
   
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

- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
        background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:videoView];
    }
    [videoView loadHTMLString:html baseURL:nil];
    
    videoView.delegate=self;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
@end
