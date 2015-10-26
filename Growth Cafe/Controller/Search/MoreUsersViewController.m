//
//  MoreUsersViewController.m
//  Growth Cafe
//
//  Created by Mayank on 09/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "MoreUsersViewController.h"
#import "NotificationTableViewCell.h"
#import "UserProfileTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "ProfileViewController.h"


@interface MoreUsersViewController ()
{
    NSMutableArray *arrayUsers;
    int selectedRow;
    AFNetworkReachabilityStatus previousStatus;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@end

@implementation MoreUsersViewController
@synthesize tblViewContent,lblStatus,viewNetwork,txtSearchBar,txtSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayUsers=[[NSMutableArray alloc]init];
    
   
    txtSearchBar.text=txtSearch;
    [self setSearchUI];
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(dismissKeyboard)];
    tap.minimumPressDuration = 0.2; //seconds
    [self.view addGestureRecognizer:tap];
   
    
   
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
    [[appDelegate _engine] getSearchResult:userId AndSearchText:txtSearchBar.text AndCatId:@"People" AndCount:@"" success:^(NSDictionary *searchResult) {
        
        
        
         arrayUsers=   [searchResult objectForKey:@"user"];
        if(! [arrayUsers count] >0)
        {
            [AppGlobal showAlertWithMessage:NO_RECORD_FOUND_MSG title:@""];
             [appDelegate hideSpinner];
            return ;
        }
        
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [arrayUsers count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section= %ld row of section=%ld",(long)indexPath.row,(long)indexPath.row);
    static NSString *identifier = @"UserProfileTableViewCell";
    UserProfileTableViewCell *cell = (UserProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    UserDetails *userPrfile=[arrayUsers objectAtIndex:indexPath.row];
    cell.lblName.text=userPrfile.userFirstName;
    if(userPrfile.userImage!=nil){
        
        //check image available at local
        //get image name from URL
        if([AppGlobal checkImageAvailableAtLocal:userPrfile.userImage])
        {
            userPrfile.userImageData=[AppGlobal getImageAvailableAtLocal:userPrfile.userImage];
        }
        
        if (userPrfile.userImageData==nil) {
            NSURL *imageURL = [NSURL URLWithString:userPrfile.userImage];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                userPrfile.userImageData  = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *img=[UIImage imageWithData:userPrfile.userImageData];
                    [AppGlobal setImageAvailableAtLocal:userPrfile.userImage AndImageData:userPrfile.userImageData];
                    if(img!=nil)
                    {
                        [cell.imgUserProfile setImage:img];
                        
                        //                                [cell.imgview setBackgroundColor:[UIColor clearColor]];
                        //                                cell.imgview.layer.cornerRadius = cell.imgview.frame.size.width/2;
                        //                                cell.imgview.clipsToBounds = YES;
                    }
                });
            });
        }else{
            
            UIImage *img=[UIImage imageWithData:userPrfile.userImageData];
            [cell.imgUserProfile setImage:img];
            
            //                    [cell.imgview setBackgroundColor:[UIColor clearColor]];
            //                    cell.imgview.layer.cornerRadius = cell.imgview.frame.size.width/2;
            //                    cell.imgview.clipsToBounds = YES;
        }
        
    }
    
    // cal calculate the time
    return cell;





}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // call the user profi{le service user profile
    UserDetails *usrDetail=[arrayUsers objectAtIndex:indexPath.row];
    ProfileViewController *profileView=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
    profileView.user=usrDetail;
    [self.navigationController pushViewController:profileView animated:YES];

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
    
    
    
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//   
//        return  @"Profiles";
//        
//    
//    
//    
//}

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
    [self.navigationController popToRootViewControllerAnimated:NO];
    

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
-(void)dismissKeyboard {
    [txtSearchBar resignFirstResponder];
    
}
@end




