//
//  NotificationViewController.m
//  sLMS
//
//  Created by Mayank on 06/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "NotificationViewController.h"
#import "CourseViewController.h"
#import "CourseViewController.h"
#import "UpdateViewController.h"
#import "AssignmentViewController.h"
#import "NotificationTableViewCell.h"
#import "Update.h"
#import "HomeViewController.h"
#import "CommentTableViewCell.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "ModuleDetailViewController.h"
#import "CourseViewController.h"
#import "SubCommentTableViewCell.h"
#import "UpdateProfileViewController.h"
#import "UpdateDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UpdateDetailViewController.h"
#import "SearchViewController.h"

#import <Social/Social.h>
@interface NotificationViewController ()
{
    NSMutableArray *arrayUpdates;
    BOOL isSearching;
    CGRect txtframe;
    NSString    *searchText;
    NSString *selectedCommentId,*selectedUpdateId;
    ActionOn  actionOn;
    NSString* useremail;
    NSString* userpassword;
    NSMutableArray *cellCMTHeight;
    CGFloat screenHeight;
    CGFloat screenWidth;
    NSMutableArray  *cellMainHeight;
    AFNetworkReachabilityStatus previousStatus;
    BOOL ForNew;
}

@end

@implementation NotificationViewController
@synthesize txtSearchBar,tblViewContent;
@synthesize step,objCustom;

- (void)viewDidLoad {
    [super viewDidLoad];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    // Do any additional setup after loading the view from its nib.
    previousStatus=AFNetworkReachabilityStatusUnknown;
   
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.minimumPressDuration = 0.2; //seconds
    [self.view addGestureRecognizer:tap];
    self.isLoading=true;
    // Custom initialization
    [self setSearchUI];
    objCustom = [[CustomProfileView alloc] init];
    NSLog(@"%f,%f",self.view.frame.size.height,self.view.frame.size.width);
    objCustom.center = CGPointMake(200, 400);
    CGRect frame1=objCustom.view.frame ;
    //    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    frame1.size.height=screenHeight-50;
    frame1.size.width=screenWidth;//200;
    objCustom.view.frame=frame1;
    
    [objCustom.btnLogout  addTarget:self action:@selector(btnLogoutClick:) forControlEvents:UIControlEventTouchUpInside];
    
   
    
    cellMainHeight=[[NSMutableArray alloc]initWithCapacity:10000];
    
    cellCMTHeight=[[NSMutableArray alloc]initWithCapacity:10000];
    
    
}

-(void)loginSucessFull{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:useremail     forKey:@"loginName"];
    [defaults setObject:userpassword  forKey:@"Password"];
    
    
}

-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
    isSearching=NO;
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
    }else{
        
        [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
        
        //@2x~ipad
        
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
    /* Listen for keyboard */
    
    //  NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
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
    // [objCustom setUserProfile];
    if([arrayUpdates count]==0)
    {
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
        
        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [objCustom.view addGestureRecognizer:recognizer];
        NSLog(@"%d", [AppSingleton sharedInstance].isUserLoggedIn);
        
        
        //set Profile
        
        self.offsetRecord=0;
        ForNew=YES;
        [self  getNotification:@""];
    }else {
        if( [AppSingleton sharedInstance].updatedUpdate!=nil)
        {
            NSUInteger index=-1;
            for (Update *update in arrayUpdates) {
                if([[AppSingleton sharedInstance].updatedUpdate.updateId integerValue]==[update.updateId integerValue])
                {
                    index=[arrayUpdates indexOfObject:update];
                    break;
                }
            }
            if(index!=-1)
            {
                [arrayUpdates removeObjectAtIndex:index];
                [arrayUpdates insertObject:[AppSingleton sharedInstance].updatedUpdate atIndex:index];
                [AppSingleton sharedInstance].updatedUpdate=nil;
            }
        }
        [tblViewContent reloadData];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];
    objCustom.btnFacebook.delegate=nil;
    
    
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
#pragma mark - Keyboard notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
   // CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    //    CGRect frame1 = self.cmtview.frame;
    //    frame1=CGRectMake(0, 400, 320, 40);
    //
    //    self.cmtview.frame=frame1;
    /* Move the toolbar to above the keyboard */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.0];
   
    //  [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // [keyboardToolbar setItems:cmtview animated:YES];
    /* Move the toolbar back to bottom of the screen */
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.3];
    
    //
    //    [UIView commitAnimations];
}

#pragma mark Update Private functions
-(void) getNotification:(NSString *) txtSearch
{
    
    NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId];
    if([userid isEqualToString:@"(null)"])
        return ;
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    if( self.offsetRecord==0 && tblViewContent.tableHeaderView==nil){
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
    }
    [[appDelegate _engine] getNotification:userid  AndTextSearch:txtSearch Offset:(int)self.offsetRecord  NoOfRecords:NOTIFICATION_PER_PAGE  success:^(NSMutableDictionary *dicUpdates) {
        
       
        
        self.totalRecord=[[dicUpdates objectForKey:@"updatesCount"] integerValue] ;
        if( [[dicUpdates objectForKey:@"updates"] count]==0)
        {
            [AppGlobal showAlertWithMessage:NO_RECORD_FOUND_MSG title:@""];
            [appDelegate hideSpinner];
            return ;
        }
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        // [self loginSucessFullWithFB];
        if( self.offsetRecord==0){
            //Hide Indicator
            
            
            NSMutableArray *tempArray  =[dicUpdates objectForKey:@"updates"]  ;
            
            //           if(ForNew && [arrayUpdates count]>0)
            //           {
            //               ForNew=NO;
            //
            //               Update *tempUpdate=[tempArray objectAtIndex:0];
            //               Update *tempUpdate1=[arrayUpdates objectAtIndex:0];
            //               if(![tempUpdate.updateId isEqualToString: tempUpdate1.updateId] )
            //               {
            //                   arrayUpdates=tempArray;
            //                    self.pendingRecord=self.totalRecord-(self.offsetRecord+UPDATE_PER_PAGE);
            //               }else{
            //
            //                   self.pendingRecord=self.totalRecord-[arrayUpdates count];
            //               }
            //
            //           }else{
            arrayUpdates=tempArray;
            self.pendingRecord=self.totalRecord-(self.offsetRecord+NOTIFICATION_PER_PAGE);
            // }
            
            [appDelegate hideSpinner];
            
        }else{
            [arrayUpdates addObjectsFromArray: [dicUpdates objectForKey:@"updates"]]  ;
            self.pendingRecord=self.totalRecord-(self.offsetRecord+NOTIFICATION_PER_PAGE);
            
        }
        [cellMainHeight removeAllObjects];
        [cellCMTHeight removeAllObjects];
        for (Update *update in arrayUpdates) {
            [cellMainHeight addObject:@"0"];
            [cellCMTHeight addObject:@"0"];
        }
        [tblViewContent reloadData];
        self.offsetRecord=[arrayUpdates count];
        
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
    return [arrayUpdates count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section= %ld row of section=%ld",(long)indexPath.row,(long)indexPath.row);
    static NSString *identifier = @"NotificationTableViewCell";
        NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Update *update=[arrayUpdates objectAtIndex:indexPath.row];
       // cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        // create custom view for title
        NSString *titleString =update.updateTitle;
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
    NSString *lastValue;
    for (NSString *strtemp in titleWords) {
        if([update.updateTitleArray count]<=textIndex){
            lastValue=strtemp;
            break ;
        }
            if([strtemp isEqualToString:@""])
            {
                
                if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
                
                
                
                    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
                    
                    NSDictionary *dictext= update.updateTitleArray[textIndex];
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
                    else  if([[dictext objectForKey:@"type"] isEqualToString:@"assignment"])
                    {
                        NSString* tempstr=[dictext objectForKey:@"value"];
                        
                        NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Assignment" : @(YES) }];
                        
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
                    
                    

                
                
                } else
                {
                
                
                //  NSString* tempstr=[update.updateTitleArray objectAtIndex:textIndex];
                UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
                
                NSDictionary *dictext= update.updateTitleArray[textIndex];
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
                } else  if([[dictext objectForKey:@"type"] isEqualToString:@"assignment"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Assignment" : @(YES) }];
                    
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
                
                }
                
            }else {
                 if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
                
                 {
                
                
                
                UIFont *font = [UIFont fontWithName:@"Helvetica neue" size:14];
                
                NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:strtemp ];
                
                [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[strtemp length] )];
                [attributedString appendAttributedString:attributedStringtemp];
                 }else {
                 
                 
                 
                 
                 
                     UIFont *font = [UIFont fontWithName:@"Helvetica neue" size:17];
                     
                     NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:strtemp ];
                     
                     [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[strtemp length] )];
                     [attributedString appendAttributedString:attributedStringtemp];
                 
                 
                 }
               
                
              if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
              {
                UIFont *Boldfont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
                                NSDictionary *dictext= update.updateTitleArray[textIndex];
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
                }
                else  if([[dictext objectForKey:@"type"] isEqualToString:@"assignment"])
                {
                    NSString* tempstr=[dictext objectForKey:@"value"];
                    
                    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Assignment" : @(YES) }];
                    
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
                
              }  else {
              
                  {
                      UIFont *Boldfont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
                      
                      
                      
                      
                      
                      NSDictionary *dictext= update.updateTitleArray[textIndex];
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
                      }
                      else  if([[dictext objectForKey:@"type"] isEqualToString:@"assignment"])
                      {
                          NSString* tempstr=[dictext objectForKey:@"value"];
                          
                          NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:tempstr attributes:@{ @"Assignment" : @(YES) }];
                          
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
              
              
              
              
              
              }
            }
            
            textIndex=textIndex+1;
        }
    if([update.updateTitleArray count] <[titleWords count])
    {
        float fontSize=14.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            fontSize=17.0;
        UIFont *font = [UIFont fontWithName:@"Helvetica neue" size:fontSize];
        
        NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:lastValue ];
        
        [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[lastValue length] )];
        [attributedString appendAttributedString:attributedStringtemp];
        
        
    }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
        
        [ cell.txtView addGestureRecognizer:tap];
        //   cell.txtView.tag=indexPath.row;
        
        
     //   [cell.txtView setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];
    // cal calculate the time
    NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:update.updatetime];
    
    NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
    //   cell.lblCmtDate.text=comment.commentDate;
    scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
                                                       withString:@""];
    // Set label text to attributed string
    NSString *str = [NSString stringWithFormat:@"\n%@ ago" ,scincetime];
    //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica neue" size:12];
    
    NSMutableAttributedString *attributedStringtemp = [[NSMutableAttributedString alloc] initWithString:str ];
    
    [attributedStringtemp addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[str length] )];
    [attributedString appendAttributedString:attributedStringtemp];
    
    
        [cell.txtView setAttributedText:attributedString ];
    
        CGPoint origin = [cell.txtView contentOffset];
        [cell.txtView setContentOffset:CGPointMake(origin.x, +11.0)];
        cell.txtView.delegate=self;
        
        cell.txtView.tag=100;
    
        if(update.user !=nil)
        {
            [cell.btnUpdatedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.btnUpdatedBy.tag = [update.user.userId  integerValue];
        }
    
        cell.txtView.tag=indexPath.row;
        cell.txtView.selectable=YES;
        if(update.updateCreatedByImage!=nil){
            if([AppGlobal checkImageAvailableAtLocal:update.updateCreatedByImage])
            {
                update.updateCreatedByImageData=[AppGlobal getImageAvailableAtLocal:update.updateCreatedByImage];
            }
            
            if (update.updateCreatedByImageData==nil) {
                NSURL *imageURL = [NSURL URLWithString:update.updateCreatedByImage];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    update.updateCreatedByImageData  = [NSData dataWithContentsOfURL:imageURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        UIImage *img=[UIImage imageWithData:update.updateCreatedByImageData ];
                        [AppGlobal setImageAvailableAtLocal:update.updateCreatedByImage AndImageData:update.updateCreatedByImageData ];
                        if(img!=nil)
                        {
                            [cell.btnUpdatedBy setImage:img forState:UIControlStateNormal];                   [cell.btnUpdatedBy setBackgroundColor:[UIColor clearColor]];
                        }
                    });
                });
            }else{
                UIImage *img=[UIImage imageWithData:update.updateCreatedByImageData ];
                [cell.btnUpdatedBy setImage:img forState:UIControlStateNormal];
                [cell.btnUpdatedBy setBackgroundColor:[UIColor clearColor]];
            }
        }
//    // cal calculate the time
//    NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:update.updatetime];
//    
//    NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
//    //   cell.lblCmtDate.text=comment.commentDate;
//    scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
//                                                       withString:@""];
//    // Set label text to attributed string
//    NSString *str = [NSString stringWithFormat:@"%@ ago" ,scincetime];
//    //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//    
//    cell.lblUpdateTime.text=str;
    if(update.viewStatus ==1 )
    {
       cell.view.backgroundColor=[UIColor clearColor];
        
    }else{
        
 cell.view.backgroundColor=[UIColor colorWithRed:(222.0/255.0) green:(222.0/255.0) blue:(222.0/255.0) alpha:1.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"NotificationTableViewCell";
//    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    BOOL isChild =
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
     Update * objUpdate=arrayUpdates[indexPath.row];
   
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    [[appDelegate _engine] getUpdatesDetail:objUpdate.updateId   success:^(Update *updates) {
        
        
        if([updates.comments count]>=COMMENT_PER_PAGE){
            NSUInteger location=COMMENT_PER_PAGE-1;
            NSUInteger length=[updates.comments count]-COMMENT_PER_PAGE;
            //  NSRange range = NSMakeRange(0, [string length]);
            NSRange range= NSMakeRange(location,length);
            
            [updates.comments removeObjectsInRange:range] ;
            self.totalRecord=[updates.commentCount integerValue];
            self.pendingRecord= self.totalRecord-[updates.comments count];
            self.offsetRecord=self.offsetRecord+COMMENT_PER_PAGE;
            
         // update the feed status
            
        }
      
      
        
       //          Update *update=arrayUpdates[indexPath.row];
//        UpdateDetailViewController *updateDetailView=[[UpdateDetailViewController alloc]init];
//       updateDetailView.objUpdate= update;
//        [self.navigationController pushViewController:updateDetailView animated:YES];
//
        updates.viewStatus=objUpdate.viewStatus;
        if(objUpdate.viewStatus==0)
        {  objUpdate.viewStatus=1 ;  //   notification  viewed
        [self setUpdateStaus:objUpdate];
            [appDelegate hideSpinner];
            UpdateDetailViewController *updateDetailView=[[UpdateDetailViewController alloc]init];
            updates.viewStatus=objUpdate.viewStatus;
            updateDetailView.objUpdate=updates;
            [self.navigationController pushViewController:updateDetailView animated:YES];
            
            
            
            
        }else{
            [appDelegate hideSpinner];
            UpdateDetailViewController *updateDetailView=[[UpdateDetailViewController alloc]init];
            updates.viewStatus=objUpdate.viewStatus;
            updateDetailView.objUpdate=updates;
            [self.navigationController pushViewController:updateDetailView animated:YES];
        }
        //Hide Indicator
        
     

    }
                                    failure:^(NSError *error) {
                                        //Hide Indicator
                                        [appDelegate hideSpinner];
                                        NSLog(@"failure JsonData %@",[error description]);
                                        [self loginError:error];
                                        //                                         [self loginViewShowingLoggedOutUser:loginView];
                                        
                                    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([arrayUpdates count]==0)
        return 0;
    Update *update=arrayUpdates[indexPath.row];
    
  float height=0.0f;
       
        
        NSString *titleString =update.updateTitle;
        NSArray *titleWords = [titleString componentsSeparatedByString:@"$"];
        float x,y;
        x=0.0f;
        y=0.0f;
        int textIndex=0;
        for (NSString *strtemp in titleWords) {
            UILabel *lbltitle=[[UILabel alloc]init];
            [lbltitle setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];
            NSString *strtrim = [strtemp stringByTrimmingCharactersInSet:
                                                                                                                                                       [NSCharacterSet whitespaceCharacterSet]];
            lbltitle.text=strtrim;
            [lbltitle setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
            CGSize textSize = [[lbltitle text] sizeWithAttributes:@{NSFontAttributeName:[lbltitle font]}];
            
            CGFloat strikeWidth = textSize.width+5;
            lbltitle.frame=CGRectMake(x, y, strikeWidth, 21);
           
            
            if([titleWords count]-1!=textIndex)
            {
               // x=x+strikeWidth;
                UIButton *btnAction=[[UIButton alloc]init];
                
                NSDictionary *dictext= update.updateTitleArray[textIndex];
                btnAction.tag =(int) update.updateId;
                NSString *strtrim = [[dictext objectForKey:@"value"] stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceCharacterSet]];
                
                [btnAction setTitle:strtrim forState:UIControlStateNormal];
               [btnAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [btnAction.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
               // textSize = [[lbltitle text] sizeWithAttributes:@{NSFontAttributeName:[lbltitle font]}];
                textSize=[AppGlobal getTheExpectedSizeOfLabel:strtrim];
                
                strikeWidth = textSize.width;
                
//                if([[dictext objectForKey:@"type"] isEqualToString:@"user"])
//                {
//                    btnAction.tag = [[dictext objectForKey:@"key"] integerValue];
//                    [btnAction addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"course"])
//                {
//                    btnAction.tag =[ [dictext objectForKey:@"key"]integerValue];
//                    [btnAction addTarget:self action:@selector(btnCourseDetailClick:) forControlEvents:UIControlEventTouchUpInside];
//                    
//                }else  if([[dictext objectForKey:@"type"] isEqualToString:@"module"])
//                {
//                    btnAction.tag = [[dictext objectForKey:@"key"] integerValue];
//                    [btnAction addTarget:self action:@selector(btnModuleDetailClick:) forControlEvents:UIControlEventTouchUpInside];
//                }
//                else  if([[dictext objectForKey:@"type"] isEqualToString:@"resource"])
//                {
//                    btnAction.tag =[ [dictext objectForKey:@"key"]integerValue];
//                    [btnAction addTarget:self action:@selector(btnResourceDetailClick:) forControlEvents:UIControlEventTouchUpInside];
//                }
                
                btnAction.frame=CGRectMake(x, y, strikeWidth, 21);
                textIndex=textIndex+1;
                x=x+strikeWidth;
                if (x<97 && y==0) {
                    y=y+21;
                    x=0;
                }

            }
        }
  
        if (y>=21) {
            height=height+y;
        }
        
        //        if(cellMainHeight<height+97)
        //        {
        //            cellMainHeight=height+97;
        //        }
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        height=height+80;
        if( screenHeight > 480 && screenHeight < 667 ){
         height=   height+15;
        }
    }else {
         height=height+70;
    }
        // [cellMainHeight insertObject:[NSString stringWithFormat:@"%f",height] atIndex:indexPath.section];
        NSLog(@"%@",[cellMainHeight objectAtIndex:indexPath.row]);
        [cellMainHeight removeObjectAtIndex:indexPath.row];
        [cellMainHeight insertObject:[NSString stringWithFormat:@"%f",height] atIndex:indexPath.row];
        
        //    else {
        //        [cellMainHeight addObject:[NSString stringWithFormat:@"%f",height]];
        //    }
        return height;
    
    
    
    
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
    UIButton *btn=(UIButton *)sender;
    // call the Course Detail Service
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        return;
    }
    NSString *feedId=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] getCourseDetail:feedId success:^(NSMutableArray *courseList) {
        
        //Hide Indicator
        if([courseList count]==0)
        {
            [AppGlobal showAlertWithMessage:NO_RECORD_FOUND_MSG title:@""];
             [appDelegate hideSpinner];
            return ;
        }
        
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
    UIButton *btn=(UIButton *)sender;
    // call the Module Detail Service
    // call the Course Detail Service
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        return;
    }
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
    UIButton *btn=(UIButton *)sender;
    // call the user profile service user profile
    
    NSString *userid=[NSString stringWithFormat:@"%ld", (long)btn.tag];
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        return;
    }
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


/////////////////////////////////////////////////////////////



// function


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



- (IBAction)btnProfileClick:(id)sender {
    //    [txtSearchBar resignFirstResponder];
    //    [txtViewCMT resignFirstResponder];
    //    [self fadeInAnimation:self.view];
    
    UpdateProfileViewController *updateView=[[UpdateProfileViewController alloc]init];
    [self.navigationController pushViewController:updateView animated:YES];
    
}

- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
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
    
    if([text isEqualToString:@"\n"]&& step<2)
    {
        txtframe=CGRectMake(txtframe.origin.x, txtframe.origin.y-30, txtframe.size.width, txtframe.size.height+30);
        
        step=step+1;
        
    }
    //    CGRect frame1 = frame;
    //    frame1=CGRectMake(0, self.view.frame.size.height+30, 320, 40);
    
  
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
  
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
    [self  getNotification:txtSearchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    self.offsetRecord=0;
    
    
    searchText=searchBar.text;
    [self  getNotification:txtSearchBar.text];
    [searchBar resignFirstResponder];
    isSearching=NO;
}
-(void)loginError:(NSError*)error{
    tblViewContent.tableHeaderView=nil;
    tblViewContent.tableFooterView=nil;
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}

-(void)loginFail:(NSError*)error{
    [self.tabBarController.tabBar setHidden:YES];
    HomeViewController *viewController= [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    
    //        FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
-(void)setUpdateStaus:(Update*)update{
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    
    [[appDelegate _engine] setUpdatesStatus:update.updateId success:^(BOOL logoutValue) {
          update.viewStatus=1;
        [tblViewContent reloadData];
//        [appDelegate hideSpinner];
//        UpdateDetailViewController *updateDetailView=[[UpdateDetailViewController alloc]init];
//        updateDetailView.objUpdate=update;
//        [self.navigationController pushViewController:updateDetailView animated:YES];
    } failure:^(NSError *error) {
        [appDelegate hideSpinner];
        NSLog(@"failure JsonData %@",[error description]);
      
        //[self loginError:error];
    }];
    

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
            Update *update= arrayUpdates[textView.tag];
            // update.updateTitleArray;
            for (NSDictionary *user in update.updateTitleArray) {
                if([[user objectForKey:@"type"] isEqualToString:@"user"])
                {
                    btn.tag=[[user objectForKey:@"key"]  integerValue];
                    [self btnUserProfileClick:btn];
                    
                }
            }
            
            
        }else if(course!=nil)        // Handle as required...
        {
            UIButton *btn=[[UIButton alloc]init];
            Update *update= arrayUpdates[textView.tag];
            btn.tag=[update.updateId integerValue];
            [self btnCourseDetailClick:btn];
        }else if(module!=nil)        // Handle as required...
        {
            UIButton *btn=[[UIButton alloc]init];
            Update *update= arrayUpdates[textView.tag];
            btn.tag=[update.updateId integerValue];
            [self btnModuleDetailClick:btn];
        }else if(resourse!=nil)        // Handle as required...
        {
            UIButton *btn=[[UIButton alloc]init];
            Update *update= arrayUpdates[textView.tag];
            btn.tag=[update.updateId integerValue];
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



-(void)initFooterView
{
    
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 40.0)];
    
    UIActivityIndicatorView * actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    
    actInd.frame = CGRectMake(self.view.frame.size.width/2, 5.0, 20.0, 20.0);
    
    actInd.hidesWhenStopped = YES;
    
    [footerView addSubview:actInd];
    
    actInd = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if(tblViewContent.tableHeaderView!=nil ||tblViewContent.tableFooterView!=nil)
    {
        return ;
    }
    float cellMainHeightTotal=0.0;
    float cellCMTHeightTotal=0.0;
    
    for (id height in cellMainHeight) {
        cellMainHeightTotal=cellMainHeightTotal+[height floatValue];
    }
    for (id height in cellCMTHeight) {
        cellCMTHeightTotal=cellCMTHeightTotal+[height floatValue];
    }
    
    float cellheight=cellMainHeightTotal+cellCMTHeightTotal;
    
    NSLog(@"Offset=%f height=%f,tableCell height=%f",scrollView.contentOffset.y ,scrollView.frame.size.height,cellheight);
    
    BOOL endOfTable = (scrollView.contentOffset.y >= (cellheight- scrollView.frame.size.height)); // Here 40 is row height
    // tblViewContent.tableFooterView = footerView;
    //    tblViewContent.tableHeaderView = footerView;
    [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
    
    if (self.pendingRecord>0 && scrollView.contentOffset.y>0 && endOfTable && !scrollView.dragging && !scrollView.decelerating)
    {
        [self initFooterView];
        tblViewContent.tableFooterView = footerView;
        
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
        [self getNotification:@""];
    }else  if (scrollView.contentOffset.y<=0  && !scrollView.dragging && !scrollView.decelerating)
    {
        [self initFooterView];
        tblViewContent.tableHeaderView = footerView;
        
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
        self.offsetRecord=0;
        ForNew=YES;
        [self getNotification:@""];
        
    }
    else{
        [footerView removeFromSuperview];
         tblViewContent.tableFooterView=nil;
         tblViewContent.tableHeaderView=nil;
        
    }
    
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    // do nothing
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITextView class]])
    {
        CGPoint origin = [sender contentOffset];
        [sender setContentOffset:CGPointMake(origin.x, +11.0)];
    }
}
- (IBAction)btnSearchClick:(id)sender {
    
    
    SearchViewController *viewController= [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:viewController animated:NO];
    
    
}


@end
