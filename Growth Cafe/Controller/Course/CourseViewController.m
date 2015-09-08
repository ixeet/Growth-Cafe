//
//  CourseViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseTableViewCell.h"
#import "ModuleTableViewCell.h"
#import "Courses.h"
#import "Module.h"
#import "ModuleDetailViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "UpdateProfileViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface CourseViewController ()
{
   
   
    NSMutableArray *moduleArray; // array of arrays
    
    AFNetworkReachabilityStatus previousStatus;
    int currentExpandedIndex;
}
@end

@implementation CourseViewController
@synthesize btnAssignment,btnCourses,btnMore,btnBack,btnNotification,btnUpdates,txtSearchBar,objCustom,coursesList,comeFromUpdate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
            }
    return self;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
     previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    [self setSearchUI];
    btnCourses.selected=YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(dismissKeyboard)];
    tap.minimumPressDuration = 0.2; //seconds
 [self.view addGestureRecognizer:tap];
    //    lpgr.delegate = self;
   // [tableViewCourse  addGestureRecognizer:lpgr];
  
    // Do any additional setup after loading the view from its nib.
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
}
-(void)viewWillAppear:(BOOL)animated    {
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
    
    if(!comeFromUpdate){
        if([coursesList count]==0)
        [self  getCourses:@""];
    }else{
        btnBack.hidden=NO;
        moduleArray     = [NSMutableArray new];
     
        for (Courses *course in coursesList) {
            [moduleArray addObject:course.moduleList];
        }
        
    }
   
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognizer:)];
    
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [objCustom.view addGestureRecognizer:recognizer];    //set Profile
    [objCustom setUserProfile];

}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:tableViewCourse];
    
    NSIndexPath *indexPath = [tableViewCourse indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
    } else {
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Data generators

//- (NSArray *)topLevelItems {
//    NSMutableArray *items = [NSMutableArray array];
//    
//    for (int i = 0; i < 10; i++) {
//        [items addObject:[NSString stringWithFormat:@"Item %d", i + 1]];
//    }
//    
//    return items;
//}
//
//- (NSArray *)subItems:(Courses *)course {
//    NSMutableArray *moduleList = [NSMutableArray array];
//    
//    for (Module *module in course.moduleList) {
//        [items addObject:[NSString stringWithFormat:@"SubItem %d", i + 1]];
//    }
//    
//    return items;
//}
#pragma mark - tab bar Action
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnMenuClick:(id)sender {
//    ProfileViewController *profileViewController=[[ProfileViewController alloc]init];
//    [self.navigationController pushViewController:profileViewController animated:YES];
   [txtSearchBar resignFirstResponder];
//    [self fadeInAnimation:self.view];
    UpdateProfileViewController *updateView=[[UpdateProfileViewController alloc]init];
    [self.navigationController pushViewController:updateView animated:YES];
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
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
   // isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  //  NSLog(@"Text change - %d");
    
    //Remove all objects first.
    //[filteredContentList removeAllObjects];
    
    if([searchText length] == 0) {
        
       
        [searchBar resignFirstResponder];
      [self getCourses:@""];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
    [searchBar resignFirstResponder];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [searchBar resignFirstResponder];
    [self getCourses:searchBar.text];
   // [self searchTableList];
}

#pragma mark Course Private functions
-(void) getCourses:(NSString *) txtSearch
{
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        return;
    }

   NSString *userid=[NSString  stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId];
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getMyCourse:userid  AndTextSearch:txtSearch success:^(NSMutableArray *courses) {
        coursesList=courses;
        moduleArray     = [NSMutableArray new];
        currentExpandedIndex = -1;
        for (Courses *course in coursesList) {
            [moduleArray addObject:course.moduleList];
        }

        [tableViewCourse reloadData];
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
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
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
    NSLog(@"You are in: %s", __FUNCTION__);
    //return [coursesList count] ; // sum of title and detail content rows
     int rowsCount=(int)[coursesList count] + ((int)(currentExpandedIndex > -1) ? (int)[[moduleArray objectAtIndex:currentExpandedIndex] count] : 0);
     NSLog(@"You are in: %s row count=%d", __FUNCTION__,rowsCount);
    return  rowsCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[moduleArray objectAtIndex:currentExpandedIndex] count];
    
    if(!isChild)
    {
        static NSString *identifier = @"CourseTableViewCell";
        CourseTableViewCell *cell = (CourseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        
        
        int topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex)
        ? indexPath.row - [[moduleArray objectAtIndex:currentExpandedIndex] count]
        : indexPath.row;
        
        Courses *course=[coursesList objectAtIndex:topIndex];
        CGFloat stepSize = 0.01f;
      
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSDate *date = [AppGlobal convertStringDateToNSDate: course.startedOn];
        if(date!=nil){
 

        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  date]; // Get necessary date components
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        
        [cell.lblDate setText: [NSString stringWithFormat:@"%@ %ld",monthName,(long)components.day]];
        }
        [cell.lblCourseName setText: course.courseName];
        [cell.probarCourse setProgress:[course.completedPercentStatus floatValue]*stepSize animated:YES  ];
        [cell.lblPercent  setText: [NSString stringWithFormat:@"%@ %s" ,course.completedPercentStatus,"%"]];
        if ([course.completedPercentStatus floatValue]==100.00) {
            cell.probarCourse.progressTintColor=[UIColor greenColor];
        }
        
        return cell;
    }else{
        static NSString *identifier = @"ModuleTableViewCell";
        ModuleTableViewCell *cell = (ModuleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        Module *module= [[moduleArray objectAtIndex:currentExpandedIndex] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
        
        
         CGFloat stepSize = 0.01f;
        // Convert string to date object
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
//        [dateFormat setLocale:[NSLocale currentLocale]];
//       [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
//        [dateFormat setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
       
        NSDate *date = [AppGlobal convertStringDateToNSDate: module.startedOn];
        if(date!=nil)
        {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  date]; // Get necessary date components
 
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        
       
        [cell.lblDate setText: [NSString stringWithFormat:@"%@ %ld",monthName,components.day]];
        }
        [cell.lblModuleName setText: module.moduleName];
        [cell.progressBarModule setProgress:[module.completedPercentStatus floatValue]* stepSize animated:YES  ];
        if ([module.completedPercentStatus floatValue]==100.00) {
            cell.progressBarModule.progressTintColor=[UIColor greenColor];
        }
        [cell.lblPercent  setText: [NSString stringWithFormat:@"%@ %s" ,module.completedPercentStatus,"%"]];
        return cell;
        
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if(previousStatus==AFNetworkReachabilityStatusNotReachable)
        {
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
                       
            return;
        }

    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[moduleArray objectAtIndex:currentExpandedIndex] count];

    if (isChild) {
         Courses *course=      coursesList[currentExpandedIndex];
        Module *module=      course.moduleList[indexPath.row-currentExpandedIndex-1];
        
    ModuleDetailViewController *moduleview= [[ModuleDetailViewController alloc]init];
    moduleview.selectedCourse=course;
    moduleview.selectedModule=module;
    [self.navigationController pushViewController:moduleview animated:YES];

    NSLog(@"A child was tapped, do what you will with it");
    return;
    }

    [tableViewCourse beginUpdates];
    
    if (currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:currentExpandedIndex];
        currentExpandedIndex = -1;
    }
else {
    
    BOOL shouldCollapse = currentExpandedIndex > -1;
    
    if (shouldCollapse) {
        [self collapseSubItemsAtIndex:currentExpandedIndex];
    }
    
    currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[moduleArray objectAtIndex:currentExpandedIndex] count] : indexPath.row;
    
    [self expandItemAtIndex:currentExpandedIndex];
}

[tableViewCourse endUpdates];

}

- (void)expandItemAtIndex:(int)index {
    
    NSMutableArray *indexPaths = [NSMutableArray new];
//    [indexPaths addObject:[NSIndexPath indexPathForRow:currentExpandedIndex++ inSection:0]];
//    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

    
    NSArray *currentSubItems = [moduleArray objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [tableViewCourse insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableViewCourse scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
   }

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[moduleArray objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [tableViewCourse deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"You are in: %s", __FUNCTION__);
//    if (indexPath.row % 2 == 0) //if the row is odd number row
//    {
//        cell.backgroundColor = [UIColor blackColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    }
//    else
//    {
//        cell.backgroundColor = [UIColor blackColor];
//    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:tableViewCourse]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
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
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}
@end
