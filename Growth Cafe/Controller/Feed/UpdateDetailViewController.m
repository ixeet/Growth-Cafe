//
//  FeedViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "UpdateDetailViewController.h"
#import "CourseViewController.h"
#import "CourseViewController.h"
#import "UpdateViewController.h"
#import "AssignmentViewController.h"
#import "UpdateTableViewCell.h"
#import "Update.h"
#import "HomeViewController.h"
#import "CommentTableViewCell.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ModuleDetailViewController.h"
#import "CourseViewController.h"
#import "SubCommentTableViewCell.h"
#import "UpdateProfileViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import <Social/Social.h>
@interface UpdateDetailViewController ()
{
   
    BOOL isSearching;
    CGRect txtframe;
    NSString    *searchText;
    NSString *selectedCommentId,*selectedUpdateId;
    ActionOn  actionOn;
    NSString* useremail;
    NSString* userpassword;
    CGFloat screenHeight ;
    CGFloat screenWidth ;
    NSMutableArray  *cellCMTHeight;
   
    float cellMainHeight;
    AFNetworkReachabilityStatus previousStatus;
    NSMutableArray  *subCommentArray;
    NSInteger startIndex,totalCount;
   float currentTextHeight;
}

@end

@implementation UpdateDetailViewController
@synthesize txtSearchBar,tblViewContent;
@synthesize step,txtViewCMT,objCustom,objUpdate;

- (void)viewDidLoad {
    [super viewDidLoad];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
    previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
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
    
    frame1.size.height=screenHeight-50;
    frame1.size.width=screenWidth;//200;
    objCustom.view.frame=frame1;
    
    [objCustom.btnLogout  addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect cmtFrame = self.cmtview.frame;
    cmtFrame=CGRectMake(0, 1200,self.view.frame.size.width, 40);
    txtframe=cmtFrame;
    self.cmtview.frame=cmtFrame;
    [self.view addSubview:self.cmtview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    self.totalRecord=[objUpdate.commentCount integerValue];
    self.pendingRecord= self.totalRecord-[objUpdate.comments count];
    self.offsetRecord=self.offsetRecord+COMMENT_PER_PAGE;
    subCommentArray=[[NSMutableArray alloc]init];
}

-(void)loginSucessFull{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:useremail     forKey:@"loginName"];
    [defaults setObject:userpassword  forKey:@"Password"];
    
    
}

-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
    [txtViewCMT resignFirstResponder];
    isSearching=NO;
    txtViewCMT.text=@"";
    step=0;
    
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
    [super viewWillAppear:animated];
    // [super viewWillAppear:animated];
    /* Listen for keyboard */
    startIndex=0;
    totalCount=0;
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
    objCustom.btnFacebook.delegate=objCustom;
    [objCustom setUserProfile];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [objCustom.view addGestureRecognizer:recognizer];
    NSLog(@"%d", [AppSingleton sharedInstance].isUserLoggedIn);
   
    //set Profile
    // [objCustom setUserProfile];
    
    //[self  getUpdate:@""];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];
    objCustom.btnFacebook.delegate=nil;
    objUpdate.isExpend=NO;
    [AppSingleton sharedInstance].updatedUpdate=objUpdate;
    
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

//#pragma mark Update Private functions
-(void) getUpdatedUpdate:(NSString *) txtSearch
{
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId];
    if([userid isEqualToString:@"(null)"])
        return ;
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getUpdatesDetail:objUpdate.updateId   success:^(Update *updates) {
        objUpdate=updates;
        
        if([objUpdate.comments count]>=COMMENT_PER_PAGE){
            NSUInteger location=COMMENT_PER_PAGE-1;
            NSUInteger length=[objUpdate.comments count]-COMMENT_PER_PAGE;
            //  NSRange range = NSMakeRange(0, [string length]);
            NSRange range= NSMakeRange(location,length);
            
            [objUpdate.comments removeObjectsInRange:range] ;
            self.totalRecord=[objUpdate.commentCount integerValue];
            self.pendingRecord= self.totalRecord-[objUpdate.comments count];
            self.offsetRecord=self.offsetRecord+COMMENT_PER_PAGE;
        }
        objUpdate.isExpend=NO;
        [AppSingleton sharedInstance].updatedUpdate=objUpdate;

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

//#pragma mark Update Private functions
-(void) getMoreComment
{
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    //Show Indicator
    if( self.offsetRecord==0 && tblViewContent.tableHeaderView==nil){
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    }
    [[appDelegate _engine] getMoreComment:objUpdate.updateId   Offset:(int)self.offsetRecord  NoOfRecords:COMMENT_PER_PAGE  success:^(NSMutableDictionary *dicUpdates) {
        
        
        self.totalRecord=[[dicUpdates objectForKey:@"updatesCount"] integerValue] ;
        self.pendingRecord=self.totalRecord-(self.offsetRecord+COMMENT_PER_PAGE);
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        // [self loginSucessFullWithFB];
        if( self.offsetRecord==0){
            //Hide Indicator
            
            
            objUpdate.comments=[dicUpdates objectForKey:@"comments"]  ;
            [tblViewContent reloadData];
            [appDelegate hideSpinner];
            
        }else{
 
            [ objUpdate.comments addObjectsFromArray:[dicUpdates objectForKey:@"comments"] ]  ;
           
           
            [tblViewContent reloadData];
        }
        
        self.offsetRecord=self.offsetRecord+COMMENT_PER_PAGE;
        
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
//    NSInteger childCount=0;
    [subCommentArray removeAllObjects];
    for (Comments *cmt in objUpdate.comments) {
        //childCount=childCount+[cmt.subComments count];
        [subCommentArray addObject:cmt];
        [subCommentArray addObjectsFromArray:cmt.subComments];
    }
    //childCount=[subCommentArray count]+1;
 return [subCommentArray count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section= %ld row of section=%ld",(long)indexPath.section,(long)indexPath.row);
    if(indexPath.row==0)
    {
        static NSString *identifier = @"UpdateTableViewCell";
        UpdateTableViewCell *cell = (UpdateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
       
        
        // create custom view for title
        NSString *titleString =objUpdate.updateTitle;
        NSArray *titleWords = [titleString componentsSeparatedByString:@"$"];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 50.0f;
        paragraphStyle.maximumLineHeight = 50.0f;
        paragraphStyle.minimumLineHeight = 50.0f;
        NSDictionary *ats = @{
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:ats];
        int textIndex=0;
        for (NSString *strtemp in titleWords) {
            if([objUpdate.updateTitleArray count]<=textIndex)
                break ;
            if([strtemp isEqualToString:@""])
            {
                //  NSString* tempstr=[update.updateTitleArray objectAtIndex:textIndex];
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
                
                NSDictionary *dictext= objUpdate.updateTitleArray[textIndex];
                if([[dictext objectForKey:@"type"] isEqualToString:@"user"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"User" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                    
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"course"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Course" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                }
                else  if([[dictext objectForKey:@"type"] isEqualToString:@"module"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Module" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                    
                    
                }
                
                else  if([[dictext objectForKey:@"type"] isEqualToString:@"resource"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Resource" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                }
                
                
                
            }else {
                
                
                UIFont *font = [UIFont fontWithName:@"Helvetica neue" size:14];
                
                NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:strtemp ];
                
                [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[strtemp length] )];
                [attributedString appendAttributedString:attributedStringtemp];
                
                UIFont *Boldfont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
                
                NSDictionary *dictext= objUpdate.updateTitleArray[textIndex];
                if([[dictext objectForKey:@"type"] isEqualToString:@"user"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"User" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:Boldfont range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                    
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"course"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Course" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:Boldfont range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"module"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Module" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:Boldfont range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                    
                }
                else  if([[dictext objectForKey:@"type"] isEqualToString:@"resource"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Resource" : @(YES) }];
                    
                    [attributedStringtemp addAttribute:NSFontAttributeName value:Boldfont range:NSMakeRange(0,[tempstr length] )];
                    [attributedString appendAttributedString:attributedStringtemp];
                }
                
                
            }
            
            textIndex=textIndex+1;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
        
        [ cell.txtView addGestureRecognizer:tap];
        //   cell.txtView.tag=indexPath.row;
        
        [cell.txtView setAttributedText:attributedString ];
        [cell.txtView setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];
        CGPoint origin = [cell.txtView contentOffset];
        [cell.txtView setContentOffset:CGPointMake(origin.x, +11.0)];
        cell.txtView.delegate=self;
        if(objUpdate.updateDesc!=nil)
        {
            cell.txtviewDetail.text=objUpdate.updateDesc;
        }else{
            [cell.txtviewDetail  setHidden:YES];
        }
        
        [cell.btnPlay setHidden:YES];
        if (objUpdate.resource!=nil) {
            
            if(objUpdate.resource.resourceImageUrl!=nil){
                [cell.btnPlay setHidden:NO];
                [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
                if([AppGlobal checkImageAvailableAtLocal:objUpdate.resource.resourceImageUrl])
                {
                    objUpdate.resource.resourceImageData=[AppGlobal getImageAvailableAtLocal:objUpdate.resource.resourceImageUrl];
                }

                if (objUpdate.resource.resourceImageData==nil) {
                    NSURL *imageURL = [NSURL URLWithString:objUpdate.resource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        objUpdate.resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            UIImage *img=[UIImage imageWithData:objUpdate.resource.resourceImageData];
                            [AppGlobal setImageAvailableAtLocal:objUpdate.resource.resourceImageUrl AndImageData:objUpdate.resource.resourceImageData];
                            if(img!=nil)
                            {
                                [cell.imgResorces setImage:img];
                                
                                [cell.imgResorces setBackgroundColor:[UIColor clearColor]];
                            }
                        });
                    });
                }else{
                    UIImage *img=[UIImage imageWithData:objUpdate.resource.resourceImageData];
                    [cell.imgResorces setImage:img];
                    
                    [cell.imgResorces setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        if(objUpdate.user !=nil)
        {
            [cell.btnUpdatedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnUpdatedBy.tag = [objUpdate.user.userId  integerValue];
        }
        if([objUpdate.comments count]==0)
        {cell.imgBelowLine8.hidden=NO;
            cell.imgBelowLine1.hidden=YES;
            
            
        }else{
            
            cell.imgBelowLine8.hidden=YES;
            cell.imgBelowLine1.hidden=NO;
        }
        
        cell.txtView.tag=indexPath.section;
        cell.txtView.selectable=YES;
        if(objUpdate.updateCreatedByImage!=nil){
            
            
            if([AppGlobal checkImageAvailableAtLocal:objUpdate.updateCreatedByImage])
            {
                objUpdate.updateCreatedByImageData=[AppGlobal getImageAvailableAtLocal:objUpdate.updateCreatedByImage];
            }
            if (objUpdate.updateCreatedByImageData==nil) {
                NSURL *imageURL = [NSURL URLWithString:objUpdate.updateCreatedByImage];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    objUpdate.updateCreatedByImageData  = [NSData dataWithContentsOfURL:imageURL];
                    
                    [AppGlobal setImageAvailableAtLocal:objUpdate.updateCreatedByImage AndImageData:objUpdate.updateCreatedByImageData ];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        UIImage *img=[UIImage imageWithData:objUpdate.updateCreatedByImageData ];
                        if(img!=nil)
                        {
                            [cell.btnUpdatedBy setImage:img forState:UIControlStateNormal];                   [cell.btnUpdatedBy setBackgroundColor:[UIColor clearColor]];
                        }
                    });
                });
            }else{
                UIImage *img=[UIImage imageWithData:objUpdate.updateCreatedByImageData ];
                [cell.btnUpdatedBy setImage:img forState:UIControlStateNormal];
                [cell.btnUpdatedBy setBackgroundColor:[UIColor clearColor]];
            }
        }
        NSString *strCount;
        if(objUpdate.likeCount  !=nil)
        {
            strCount=[NSString stringWithFormat:@"%@ Likes",objUpdate.likeCount] ;
        }else{
            strCount=@"";
        }
        if(objUpdate.commentCount  !=nil)
        {
            strCount=[NSString stringWithFormat:@"%@ %@ Comments",strCount,objUpdate.commentCount] ;
            
        }else{
            strCount=[NSString stringWithFormat:@"%@",strCount] ;
        }
        cell.lblLikeAndCmtConut.text=strCount;
        if([objUpdate.isLike  isEqualToString:@"1"])
        {
            cell.btnLike.selected=YES;
            
        }else
            
        {
            cell.btnLike.selected=NO;
            [cell.btnLike addTarget:self action:@selector(btnLikeOnUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        // cell.lblUpdateBy.text=update.updateCreatedBy;
        cell.btnComment.tag=indexPath.section  ;
        cell.btnLike.tag=indexPath.section  ;
        cell.btnShare.tag=indexPath.section  ;
        //set action for comment and like on resource
        [cell.btnComment addTarget:self action:@selector(btnCommentOnUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.btnShare addTarget:self action:@selector(btnShareOnUpdateClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // cal calculate the time
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:objUpdate.updatetime];
        
        NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
        //   cell.lblCmtDate.text=comment.commentDate;
        scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
                                                           withString:@""];
        // Set label text to attributed string
        NSString *str = [NSString stringWithFormat:@"%@ ago" ,scincetime];
        //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        cell.lblUpdateTime.text=str;
        
        return cell;
    }
    else{
        Comments *comment= [subCommentArray objectAtIndex:indexPath.row-1];
        if([comment.parentCommentId integerValue] ==0)
        {
           
           

            static NSString *identifier = @"CommentTableViewCell";
            CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
                [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            }
//            if([comment.subComments count]>0)
//            {
//                subCommentArray=comment.subComments;
//                startIndex=0;
//                totalCount=[subCommentArray count];
//            }
            //[cell.imgCMT setImage:[AppGlobal generateThumbnail:comment.commentByImage]];
            cell.lblCmtBy.text= comment.commentBy;
            // cal calculate the time
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
            [cell.lblCmtBy  setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];
            cell.lblCmtText.text=comment.commentTxt;
            
            cell.lblRelatedVideo.hidden=YES;
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
            if(comment.commentBy!=nil)
            {
                [cell.btnCommentedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnCommentedBy.tag = [comment.commentById integerValue];
            }
            if([comment.isLike  isEqualToString:@"1"])
            {
                cell.btnLike.selected=YES;
                
            }else
                
            {
                cell.btnLike.selected=NO;
                [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if(comment.likeCounts  !=nil)
            {
                [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateNormal];
            }else{
                [cell.btnLike setTitle:@" " forState:UIControlStateNormal];
            }
            if(comment.commentCounts  !=nil)
            {
                [cell.btnCMT setTitle:comment.commentCounts forState:UIControlStateNormal];
            }else{
                [cell.btnCMT setTitle:@" " forState:UIControlStateNormal];
            }
            cell.btnCMT.tag=[comment.commentId integerValue];
            cell.btnLike.tag=[comment.commentId integerValue];
            cell.btnMore.tag=indexPath.section;
            //set action for reply and like on comment
            [cell.btnCMT addTarget:self action:@selector(btnReplyOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
            cell.btnMore.tag=indexPath.section;
//            if(indexPath.row==[objUpdate.comments count])
//            {
//                cell.btnMore.hidden=YES;
//                cell.imgDevider.hidden=NO;
//                
//                
//            }
//            else if([objUpdate.comments count]>=10)
//            {
//                if(objUpdate.isExpend && (indexPath.row==[objUpdate.comments count]))
//                {
//                    [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[objUpdate.comments count ]-10]  forState:UIControlStateNormal];
//                    cell.btnMore.hidden=YES;
//                    cell.imgDevider.hidden=NO;
//                    
//                }else if(indexPath.row==10 && !objUpdate.isExpend){
//                    [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[objUpdate.comments count ]-10]  forState:UIControlStateNormal];
//                    cell.btnMore.hidden=NO;
//                    cell.imgDevider.hidden=NO;
//                    if([objUpdate.comments count]==10)
//                    {
//                        cell.btnMore.hidden=YES;
//                        cell.imgHalfDevider.hidden=YES;
//                        
//                    }
//                    
//                    
//                }
//                
//            }
            return cell;
        }else{
           // Comments *comment= [subCommentArray objectAtIndex:startIndex];
           // startIndex=startIndex+1;

            static NSString *identifier = @"SubCommentTableViewCell";
            SubCommentTableViewCell *cell = (SubCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                // Load the top-level objects from the custom cell XIB.
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
                
                // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                cell = [topLevelObjects objectAtIndex:0];
                [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
            }
            
            
//            if(startIndex==totalCount)
//            {
//                [subCommentArray removeAllObjects];
//                startIndex=0;
//                totalCount=0;
//            }

            //[cell.imgCMT setImage:[AppGlobal generateThumbnail:comment.commentByImage]];
            cell.lblCmtBy.text= comment.commentBy;
            //cell.lblCmtDate.text=comment.commentDate;
            cell.lblCmtText.text=comment.commentTxt;
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
            
            cell.lblRelatedVideo.hidden=YES;
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
            if(comment.commentBy!=nil)
            {
                [cell.btnCommentedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.btnCommentedBy.tag = [comment.commentById integerValue];
            }
            if([comment.isLike  isEqualToString:@"1"])
            {
                cell.btnLike.selected=YES;
                
            }else
                
            {
                cell.btnLike.selected=NO;
                [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            // cell.btnCMT.tag=[comment.commentId integerValue];
            cell.btnLike.tag=[comment.commentId integerValue];
            if(comment.likeCounts  !=nil)
            {
                [cell.btnLike setTitle:comment.likeCounts forState:UIControlStateSelected];
            }else{
                [cell.btnLike setTitle:@"" forState:UIControlStateSelected];
            }
            
            //set action for reply and like on comment
            
            //           [cell.btnLike addTarget:self action:@selector(btnLikeOnCommentClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnMore.hidden=YES;
            cell.imgDevider.hidden=YES;
            cell.btnMore.tag=indexPath.section;
//            if(([objUpdate.comments count]<10) && (indexPath.row==[objUpdate.comments count]))
//            {
//                cell.btnMore.hidden=YES;
//                cell.imgDevider.hidden=NO;
//                
//                
//            }
//            else if([objUpdate.comments count]>=10)
//            {
//                if(objUpdate.isExpend && (indexPath.row==[objUpdate.comments count]))
//                {
//                    [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[objUpdate.comments count ]-1]  forState:UIControlStateNormal];
//                    cell.btnMore.hidden=YES;
//                    cell.imgDevider.hidden=NO;
//                    
//                }else if(indexPath.row==10 && !objUpdate.isExpend){
//                    [cell.btnMore addTarget:self action:@selector(btnMoreCommentClick:) forControlEvents:UIControlEventTouchUpInside];
//                    [cell.btnMore setTitle:[NSString stringWithFormat:@"+%ld More",(long)[objUpdate.comments count ]-10]  forState:UIControlStateNormal];
//                    cell.btnMore.hidden=NO;
//                    cell.imgDevider.hidden=NO;
//                    
//                }else if(indexPath.row==10 && objUpdate.isExpend){
//                    
//                    cell.btnMore.hidden=YES;
//                    cell.imgHalfDevider.hidden=NO;
//                    
//                    cell.imgDevider.hidden=YES;
//                    
//                }
//                
//            }
            return cell;
        }
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"height==%ld",indexPath.row);
    
    if(indexPath.row==0)
    {
        float height=0.0f;
        if(objUpdate.resource!=nil)
        {
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                height=200.0f;
            }
            
            
            else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                height=300.0f;
            }
        }

       
        
        NSString *titleString =objUpdate.updateTitle;
        NSArray *titleWords = [titleString componentsSeparatedByString:@"$"];
        float x,y;
        x=0.0f;
        y=0.0f;
        int textIndex=0;
        for (NSString *strtemp in titleWords) {
            UILabel *lbltitle=[[UILabel alloc]init];
            [lbltitle setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];                NSString *strtrim = [strtemp stringByTrimmingCharactersInSet:
                                                                                                                                                       [NSCharacterSet whitespaceCharacterSet]];
            lbltitle.text=strtrim;
            [lbltitle setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
            CGSize textSize = [[lbltitle text] sizeWithAttributes:@{NSFontAttributeName:[lbltitle font]}];
            
            CGFloat strikeWidth = textSize.width+5;
            lbltitle.frame=CGRectMake(x, y, strikeWidth, 21);
            if (x>97 && y==0) {
                y=y+21;
                x=0;
            }
            
            
            if([titleWords count]-1!=textIndex)
            {
                x=x+strikeWidth;
                UIButton *btnAction=[[UIButton alloc]init];
                
                NSDictionary *dictext= objUpdate.updateTitleArray[textIndex];
                btnAction.tag =(int) objUpdate.updateId;
                NSString *strtrim = [[dictext objectForKey:@"value"] stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceCharacterSet]];
                
                [btnAction setTitle:strtrim forState:UIControlStateNormal];
                [btnAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [btnAction.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
                textSize = [[lbltitle text] sizeWithAttributes:@{NSFontAttributeName:[lbltitle font]}];
                textSize=[AppGlobal getTheExpectedSizeOfLabel:strtrim];
                
                strikeWidth = textSize.width;
                
                if([[dictext objectForKey:@"type"] isEqualToString:@"user"])
                {
                    btnAction.tag = [[dictext objectForKey:@"key"] integerValue];
                    [btnAction addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"course"])
                {
                    btnAction.tag =[ [dictext objectForKey:@"key"]integerValue];
                    [btnAction addTarget:self action:@selector(btnCourseDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"module"])
                {
                    btnAction.tag = [[dictext objectForKey:@"key"] integerValue];
                    [btnAction addTarget:self action:@selector(btnModuleDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                else  if([[dictext objectForKey:@"type"] isEqualToString:@"resource"])
                {
                    btnAction.tag =[ [dictext objectForKey:@"key"]integerValue];
                    [btnAction addTarget:self action:@selector(btnResourceDetailClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                
                btnAction.frame=CGRectMake(x, y, strikeWidth, 21);
                textIndex=textIndex+1;
                x=x+strikeWidth;
                
            }
        }
        if (y>21) {
            height=height+y;
        }
        if(cellMainHeight<height+160)
        {
            cellMainHeight=height+160;
        }

        return height=height+160;
    }
    else if(objUpdate.comments>0)
    {
        Comments *cmt=subCommentArray[indexPath.row-1];
        CGSize labelSize=[AppGlobal getTheExpectedSizeOfLabel:cmt.commentTxt];
        float height=0.0f;
        NSLog(@"%ld",(long)indexPath.row);
//        if( indexPath.row==[objUpdate.comments count])
//        {
//            height=35.0f;
//        }
//        else if([objUpdate.comments count]>=COMMENT_PER_PAGE)
//        {
//            if(objUpdate.isExpend && (indexPath.row==[objUpdate.comments count]))
//            {
//                height=35.0f;
//            }else if(indexPath.row==11 && !objUpdate.isExpend){
//                height=35.0f;
//            }
//            
//        }
        if([cmt.parentCommentId integerValue] !=0 && (labelSize.height<17))
        {
            height=height-10;
        }
        
        
        if(labelSize.height>17)
        {
            //           cellHeight=cellHeight+height+65+labelSize.height;
          height=height+65+labelSize.height;
          
            [cellCMTHeight removeObjectAtIndex:indexPath.section];
            [cellCMTHeight insertObject:[NSString stringWithFormat:@"%f",height] atIndex:indexPath.section];
            
            return  height;
        }
        else{
            //             cellHeight=cellHeight+height+80;
           height=height+75;
            [cellCMTHeight removeObjectAtIndex:indexPath.section];
            [cellCMTHeight insertObject:[NSString stringWithFormat:@"%f",height] atIndex:indexPath.section];
            return  height;
        }

    }
    
    
    return 0.0;
    
    
}
#pragma mark - table cell Action

- (IBAction)btnResourceDetailClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    // call the Resource detail service
    
    //    ProfileViewController *profileView=[[ProfileViewController alloc]init];
    //    profileView.userid=[NSString stringWithFormat:@"%ld", btn.tag];
    //    [self.navigationController pushViewController:profileView animated:YES];
}
- (IBAction)btnCourseDetailClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    // call the Course Detail Service
    NSString *feedId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] getCourseDetail:feedId success:^(NSMutableArray *courseList) {
        
        //Hide Indicator
        CourseViewController *courseView=[[CourseViewController alloc]init];
        courseView.coursesList=courseList;
        courseView.comeFromUpdate=YES;
        [self.navigationController pushViewController:courseView animated:YES];
        [appDelegate hideSpinner];
        
    }
                                   failure:^(NSError *error) {
                                       //Hide Indicator
                                       [appDelegate hideSpinner];
                                       NSLog(@"failure JsonData %@",[error description]);
                                       
                                       [self loginError:error];
                                   }];
    
    
}

- (IBAction)btnModuleDetailClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    // call the Module Detail Service
    // call the Course Detail Service
    NSString *feedId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    //    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    //
    //
    //    [[appDelegate _engine] getModuleDetail:feedId success:^(NSDictionary *moduleDetail)
    //        {
    //Hide Indicator
    ModuleDetailViewController *moduleView=[[ModuleDetailViewController alloc]init];
    //  profileView.userid=[NSString stringWithFormat:@"%ld", btn.tag];
    moduleView.feedId=feedId;
    [self.navigationController pushViewController:moduleView animated:YES];
    //        [appDelegate hideSpinner];
    //
    //    }
    //                                 failure:^(NSError *error) {
    //                                     //Hide Indicator
    //                                     [appDelegate hideSpinner];
    //                                     NSLog(@"failure JsonData %@",[error description]);
    //
    //                                     [self loginError:error];
    //                                 }];
    //
    
}
- (IBAction)btnUserProfileClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
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
    UIButton *btn=(UIButton *)sender;
//    
//    for (Update *update in arrayUpdates) {
//        update.isExpend=NO;
//    }
//    Update *update=[arrayUpdates objectAtIndex:btn.tag];
//    objUpdate.isExpend=YES;
//    [tblViewContent reloadData];
    
}
#pragma mark - Comment and like on Update

- (IBAction)btnPlayResourceClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
 
    Resourse *resourse =objUpdate.resource;
    [self PlayTheVideo:resourse.resourceUrl];
    
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
- (IBAction)btnCommentOnUpdateClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
  //  UIButton *btn=(UIButton *)sender;
    //  NSInteger currentpage=  self.pageControl.currentPage;
    // get the current Content
//    Update *update=[arrayUpdates objectAtIndex:btn.tag];
    selectedUpdateId=objUpdate.updateId;
    
    actionOn=UpdateOn;
    [txtViewCMT becomeFirstResponder];
    
    
}
- (IBAction)btnLikeOnUpdateClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    // call the service
    //UIButton *btn=(UIButton *)sender;
    // get the current Content
    //Update *update=[arrayUpdates objectAtIndex:btn.tag];
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setLikeOnUpdate:objUpdate.updateId  success:^(BOOL success) {
        
        
        
        
        //Hide Indicator
        [appDelegate hideSpinner];
        objUpdate.isLike=@"1";
        int count=0;
        if (objUpdate.likeCount!=nil) {
            count=[objUpdate.likeCount intValue]+1;
        }
        objUpdate.likeCount=[NSString stringWithFormat:@"%d",count];
         [tblViewContent reloadData];
        //[self getUpdate:txtSearchBar.text];
    }
                                   failure:^(NSError *error) {
                                       //Hide Indicator
                                       [appDelegate hideSpinner];
                                       NSLog(@"failure JsonData %@",[error description]);
                                       [self loginError:error];
                                       
                                       
                                   }];
}
- (IBAction)btnShareOnUpdateClick:(id)sender {
    
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        return;
    }
    // call the service
    UIButton *btn=(UIButton *)sender;
    // get the current Content
    Update *update=objUpdate;
    NSURL *url = [NSURL URLWithString: update.resource.resourceUrl];
    
    if([SLComposeViewController
        isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController * fbSheetOBJ = [SLComposeViewController
                                                composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSString *strText = [NSString stringWithFormat:@"%@ \n%@",[self updateTitle:update],update.resource.resourceDesc];
        [fbSheetOBJ  setInitialText:strText];
        
        
        // NSString* facebookText = @"Awesome App";
        
        [fbSheetOBJ addImage:[UIImage
                              imageWithData:update.resource.resourceImageData]];
        
        [fbSheetOBJ addURL:url];
        
        
        
        
        [self presentViewController:fbSheetOBJ animated:YES
                         completion:Nil];
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign  in!" message:@"Please Facebook Log In first !" delegate:nil
                                             cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
}
-(NSString*)updateTitle:(Update*)update
{
    
    NSString *titleString =update.updateTitle;
    NSArray *titleWords = [titleString componentsSeparatedByString:@"$"];
    
    NSMutableString *attributedString = [[NSMutableString alloc]
                                         initWithString:@""];
    int textIndex=0;
    for (NSString *strtemp in titleWords) {
        if([update.updateTitleArray count]<=textIndex)
            break ;
//        NSString* tempstr=[update.updateTitleArray
//                           objectAtIndex:textIndex];
        NSDictionary *dictext= update.updateTitleArray[textIndex];
        if(![strtemp isEqualToString:@""])
        {
            
            [attributedString appendString: strtemp];
            
        }
        if([[dictext objectForKey:@"type"] isEqualToString:@"user"])
        {
            NSString* tempstr=[dictext objectForKey:@"value"];
            [attributedString appendString: tempstr];
            
        }else  if([[dictext objectForKey:@"type"]
                   isEqualToString:@"course"])
        {
            NSString* tempstr=[dictext objectForKey:@"value"];
            [attributedString appendString: tempstr];
        }
        else  if([[dictext objectForKey:@"type"]
                  isEqualToString:@"module"])
        {
            NSString* tempstr=[dictext objectForKey:@"value"];
            [attributedString appendString: tempstr];
            
        }
        
        else  if([[dictext objectForKey:@"type"]
                  isEqualToString:@"resource"])
        {
            NSString* tempstr=[dictext objectForKey:@"value"];
            [attributedString appendString: tempstr];
        }
        
        textIndex=textIndex+1;
        
    }
    
    
    
    return attributedString;
}

#pragma mark - Reply and like on Comment

- (IBAction)btnReplyOnCommentClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    actionOn=Comment;
    [txtViewCMT becomeFirstResponder];
    
}
- (IBAction)btnLikeOnCommentClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    UIButton *btn=(UIButton *)sender;
    selectedCommentId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setLikeOnComment:selectedCommentId AndisFeed:YES success:^(BOOL success) {
        //Hide Indicator
        
        for (Comments *cmt in objUpdate.comments) {
            if([cmt.commentId integerValue] == [selectedCommentId integerValue])
            {
                cmt.isLike=@"1";
                int count=0;
                if (cmt.likeCounts!=nil) {
                    count=[cmt.likeCounts intValue]+1;
                }
                cmt.likeCounts=[NSString stringWithFormat:@"%d",count];

            }
        }
        [tblViewContent reloadData];
         [appDelegate hideSpinner];
       // [self  getUpdate:txtSearchBar.text];
    }
                                    failure:^(NSError *error) {
                                        //Hide Indicator
                                        [appDelegate hideSpinner];
                                        NSLog(@"failure JsonData %@",[error description]);
                                        
                                        [self loginError:error];
                                    }];
    
}

- (IBAction)btnCommentDone:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    [txtViewCMT resignFirstResponder];
    
    if([txtViewCMT.text isEqualToString:@""])
    {
        //[AppGlobal showAlertWithMessage:MISSING_COMMENT title:@""];
        step=0;
        txtViewCMT.text=@"";
        CGRect frame1 =CGRectMake(0, self.view.frame.size.height+30, 320, 40);
        txtframe=frame1;
        return;
    }
    
    // call the service
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    if (actionOn==UpdateOn) {
        [[appDelegate _engine] setCommentOnUpdate:selectedUpdateId AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            //Hide Indicator
            
           

            [appDelegate hideSpinner];
            
            [self getUpdatedUpdate:@""];

        }
                                          failure:^(NSError *error) {
                                              //Hide Indicator
                                              [appDelegate hideSpinner];
                                              NSLog(@"failure JsonData %@",[error description]);
                                              [self loginError:error];
                                              
                                          }];
        
    }else{
        [[appDelegate _engine] setCommentOnComment:selectedCommentId AndisFeed:YES AndCommentText:txtViewCMT.text success:^(BOOL success) {
            
            
            // [self loginSucessFullWithFB];
            
            
            [tblViewContent reloadData];

            //Hide Indicator
            [appDelegate hideSpinner];
           [self getUpdatedUpdate:@""];
        }
                                           failure:^(NSError *error) {
                                               //Hide Indicator
                                               [appDelegate hideSpinner];
                                               NSLog(@"failure JsonData %@",[error description]);
                                               [self loginError:error];
                                               
                                           }];
        
    }
    txtViewCMT.text=@"";
    CGRect frame1  =CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    txtframe=frame1;
    
}

- (IBAction)btnCommentCancle:(id)sender {
    [txtViewCMT resignFirstResponder];
    txtViewCMT.text=@"";
    txtframe =CGRectMake(0, self.view.frame.size.height+30, 320, 40);
  
    
    step=0;
}

- (IBAction)btnProfileClick:(id)sender {
    //    [txtSearchBar resignFirstResponder];
    //    [txtViewCMT resignFirstResponder];
    //    [self fadeInAnimation:self.view];
    
    UpdateProfileViewController *updateView=[[UpdateProfileViewController alloc]init];
    [self.navigationController pushViewController:updateView animated:YES];
    
}

- (IBAction)btnBackClick:(id)sender {
      objUpdate.isExpend=NO;
    [AppSingleton sharedInstance].updatedUpdate=objUpdate;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -  UITextView deligate and datasource

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //txtview.inputAccessoryView=commentView;
    if(textView.tag ==100)
        return NO;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.tag ==100)
        return NO;
    
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
    
    float floatCheck=  [self doesFit:textView string:text range:range];
    if([text isEqualToString:@"\n"]&& step<2)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y-30, txtframe.size.width, txtframe.size.height+30);
        
        step=step+1;
        
    }else if (!floatCheck && step<2)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y-30, txtframe.size.width, txtframe.size.height+30);
        
        step=step+1;
        
        
    }
    else if (floatCheck==2 && step >0)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y+30, txtframe.size.width, txtframe.size.height-30);
        
        step=step-1;
        
    }
    
    //    CGRect frame1 = frame;
    //    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    
    self.cmtview.frame=txtframe;
    
    
    return YES;
    // Check if the text exceeds the size of the UITextView
    
    
}
- (float)doesFit:(UITextView*)textView string:(NSString *)myString range:(NSRange) range;
{
    // Get the textView frame
    float viewHeight = textView.frame.size.height;
    float width = textView.textContainer.size.width;
    
    NSMutableAttributedString *atrs = [[NSMutableAttributedString alloc] initWithAttributedString: textView.textStorage];
    [atrs replaceCharactersInRange:range withString:myString];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:atrs];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: CGSizeMake(width, FLT_MAX)];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    float textHeight = [layoutManager
                        usedRectForTextContainer:textContainer].size.height;
    
    if (textHeight >= viewHeight - 1) {
        currentTextHeight=textHeight;
        return NO;
    } else if(currentTextHeight>textHeight)
    {
        currentTextHeight=textHeight;
        return 2.0;
        
    }else{
        
        return YES;
    }
    return 0;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
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
        CGRect frame1 =CGRectMake(0, self.view.frame.size.height+30, 320, 40);
        self.cmtview.frame = frame1;
        txtframe=frame1;
    }
    //
    //    [UIView commitAnimations];
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
   // [self  getUpdate:txtSearchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    searchText=searchBar.text;
 //   [self  getUpdate:txtSearchBar.text];
    [searchBar resignFirstResponder];
    isSearching=NO;
}
-(void)loginError:(NSError*)error{
    tblViewContent.tableFooterView =nil;
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
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
        
        
        
    }
}
- (IBAction)btnLogoutClick:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    objCustom.btnFacebook.delegate=nil;
    [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
    [AppSingleton sharedInstance].isUserLoggedIn=NO;
    // [objCustom removeFromSuperview ];
    [self.tabBarController.tabBar setHidden:YES];
    LoginViewController *viewCont= [[LoginViewController alloc]init];
    [self.navigationController pushViewController:viewCont animated:YES];
    
}
- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    //UILabel *lblview= (UILabel *)recognizer.view;
    UITextView *textView = (UITextView *)recognizer.view;
    
    //  Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < textView.textStorage.length) {
        
        NSRange range;
        id user = [textView.attributedText attribute:@"User" atIndex:characterIndex effectiveRange:&range];
        id course = [textView.attributedText attribute:@"Course" atIndex:characterIndex effectiveRange:&range];
        id module = [textView.attributedText attribute:@"Module" atIndex:characterIndex effectiveRange:&range];
        id resourse = [textView.attributedText attribute:@"Resource" atIndex:characterIndex effectiveRange:&range];
        if(user!=nil)
        {
            UIButton *btn=[[UIButton alloc]init];
            
            // update.updateTitleArray;
            for (NSDictionary *user in objUpdate.updateTitleArray) {
                if([[user objectForKey:@"type"] isEqualToString:@"user"])
                {
                    btn.tag=[[user objectForKey:@"key"]  integerValue];
                    [self btnUserProfileClick:btn];
                    
                }
            }
            
            
        }else if(course!=nil)        // Handle as required...
        {
            UIButton *btn=[[UIButton alloc]init];
           
            btn.tag=[objUpdate.updateId integerValue];
            [self btnCourseDetailClick:btn];
        }else if(module!=nil)        // Handle as required...
        {
            UIButton *btn=[[UIButton alloc]init];
            btn.tag=[objUpdate.updateId integerValue];
            [self btnModuleDetailClick:btn];
        }else if(resourse!=nil)        // Handle as required...
        {
            UIButton *btn=[[UIButton alloc]init];
          
            btn.tag=[objUpdate.updateId integerValue];
            [self btnCourseDetailClick:btn];
        }
        
        NSLog(@"%@, %d, %d", user, range.location, range.length);
        
    }
    
    CGPoint touchPoint = [recognizer locationInView: textView];
    
    //modify the validFrame that you would like to enable the touch
    //or get the frame from _yourLabel using the NSMutableAttributedString, if possible
    CGRect validFrame = CGRectMake(0, 0, 300, 200);
    
    if ( CGRectContainsPoint(validFrame, touchPoint ))
    {
        //handle here.
        NSLog(@"hit");
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag==12)
    {

    if(tblViewContent.tableHeaderView!=nil ||tblViewContent.tableFooterView!=nil)
    {
        return ;
    }
    
    
    float cellCMTHeightTotal=0.0;
    
    
    for (id height in cellCMTHeight) {
        cellCMTHeightTotal=cellCMTHeightTotal+[height floatValue];
    }
    float cellheight=cellMainHeight+cellCMTHeightTotal;
    
    NSLog(@"Offset=%f height=%f,tableCell height=%f",scrollView.contentOffset.y ,scrollView.frame.size.height,cellheight);
    
    BOOL endOfTable = (scrollView.contentOffset.y >= (cellheight- scrollView.frame.size.height)); // Here 40 is row height
    // tblViewContent.tableFooterView = footerView;
    //    tblViewContent.tableHeaderView = footerView;
    [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
    
    if (self.pendingRecord>0 && endOfTable&& !scrollView.dragging && !scrollView.decelerating)
    {
        [self initFooterView];
        tblViewContent.tableFooterView = footerView;
        
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
        [self getMoreComment];
   }//else  if (scrollView.contentOffset.y<=0  && !scrollView.dragging && !scrollView.decelerating)
//    {
//        [self initFooterView];
//        tblViewContent.tableHeaderView = footerView;
//        
//        [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
//       
//        [self getUpdatedUpdate:@""];
//        
//    }
    else{
        [footerView removeFromSuperview];
        //        tblViewContent.tableFooterView=nil;
        //        tblViewContent.tableHeaderView=nil;
        
    }
    }
}
-(void)initFooterView
{
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 40.0)];
    
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    
    actInd.frame = CGRectMake((screenWidth-20)/2, 5.0, 20.0, 20.0);
    
    actInd.hidesWhenStopped = YES;
    
    [footerView addSubview:actInd];
    
    actInd = nil;
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITextView class]])
    {
        if(sender.tag!=11)
        {
            CGPoint origin = [sender contentOffset];
            [sender setContentOffset:CGPointMake(origin.x, +11.0)];
        }
    }
}
@end
