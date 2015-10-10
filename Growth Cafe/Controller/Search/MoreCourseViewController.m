//
//  MoreCourseViewController.m
//  Growth Cafe
//
//  Created by Mayank on 09/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "MoreCourseViewController.h"
#import "NotificationTableViewCell.h"
#import "ModuleNameTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"

@interface MoreCourseViewController ()
{
    NSMutableArray *arrayCourses;
    int selectedRow;
    AFNetworkReachabilityStatus previousStatus;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@end

@implementation MoreCourseViewController
@synthesize tblViewContent,lblStatus,viewNetwork,txtSearchBar,isCourse,txtSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayCourses=[[NSMutableArray alloc]init];
    
   
    txtSearchBar.text=txtSearch;
    [self setSearchUI];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [txtSearchBar becomeFirstResponder];
    [self getSearchResult];
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





/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnProfileClick:(id)sender {
}


-(void)viewWillAppear:(BOOL)animated
{
    //  NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(status==AFNetworkReachabilityStatusNotReachable)
        {   previousStatus=status;
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        }else{
            previousStatus=status;
            [self showNetworkStatus:REESTABLISH_INTERNET_MSG newVisibility:YES];
            [self getSearchResult];

        }
        //       else  if(status!=AFNetworkReachabilityStatusNotReachable)
        //       {
        //           previousStatus=status;
        //           [self showNetworkStatus:@""];
        //
        //       }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
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
        }
        else if ( screenHeight > 480 ){
            // [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn.png"]];
            
            NSLog(@"iPhone 6 Plus");
        }
        
        else {
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
-(void)getSearchResult{
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        tblViewContent.tableHeaderView=nil;
        tblViewContent.tableFooterView=nil;
        
        return;
    }
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    NSString *userId=[NSString stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId ];
    NSString *catid;
    if(isCourse)
        catid=@"Course";
    else
        catid=@"Assignment";
    [[appDelegate _engine] getSearchResult:userId AndSearchText:txtSearchBar.text AndCatId:@"" AndCount:@"" success:^(NSDictionary *searchResult) {
        
        
        
        if(isCourse)
            arrayCourses=   [searchResult objectForKey:@"course"];

        else
            arrayCourses= [searchResult objectForKey:@"assignment"];
        

        
        
        //Hide Indicator
        [appDelegate hideSpinner];
        [tblViewContent reloadData];
        
        
    }
                                   failure:^(NSError *error) {
                                       //Hide Indicator
                                       [appDelegate hideSpinner];
                                       NSLog(@"failure Json Data %@",[error description]);
                                       [self settingError:error];
                                       
                                   }];
    
}

-(void)settingError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
    return  [arrayCourses count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section= %ld row of section=%ld",(long)indexPath.row,(long)indexPath.row);
    static NSString *identifier = @"ModuleNameTableViewCell";
    ModuleNameTableViewCell *cell = (ModuleNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    if(isCourse){
        Courses *course=[arrayCourses objectAtIndex:indexPath.row];
        cell.lblCourseName.text=course.courseName;
    }else{
    Assignment *assignment=[arrayCourses objectAtIndex:indexPath.row];
    cell.lblCourseName.text=assignment.assignmentName;
    
    }
    // cal calculate the time
    return cell;

    
    
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
    
    
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if(isCourse){
//        return  @"Courses";
//    }else{
//        return  @"Assignments";
//        
//    }
//   
//    
//}
////
//-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
//    footerview.backgroundColor=[UIColor whiteColor];
//    //    footerview.layer.cornerRadius = 5.0f;
//    //    [footerview setClipsToBounds:YES];
//    return footerview;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UILabel *myLabel = [[UILabel alloc] init];
//    if(section==0)
//        myLabel.frame = CGRectMake(14, 20, 320, 20);
//    else
//        myLabel.frame = CGRectMake(14, 10, 320, 20);
//    
//    myLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
//    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    myLabel.textColor =[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1];
//    UIView *headerView = [[UIView alloc] init];
//    
//    [headerView addSubview:myLabel];
//    NSLog(@"header section=%ld frame x=%f,y=%f,Width=%f Height=%f",(long)section,headerView.frame.origin.x,headerView.frame.origin.y,headerView.frame.size.width,headerView.frame.size.height);
//    return headerView;
//}
- (IBAction)btnBackclick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    lblStatus.text=status;
    [viewNetwork setHidden:newVisibility];
}
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  
    //    isSearching = YES;
    [self.navigationController popViewControllerAnimated:NO];


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
    
    [self  getSearchResult];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self  getSearchResult];
    [searchBar resignFirstResponder];
    
}

@end



