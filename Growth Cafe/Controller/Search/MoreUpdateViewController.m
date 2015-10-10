//
//  MoreUpdateViewController.m
//  Growth Cafe
//
//  Created by Mayank on 09/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "MoreUpdateViewController.h"
#import "NotificationTableViewCell.h"
#import "UpdateDetailViewController.h"
#import "UserProfileTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "ModuleNameTableViewCell.h"
@interface MoreUpdateViewController ()
{
    NSMutableArray *arrayUpdates;
    int selectedRow;
    AFNetworkReachabilityStatus previousStatus;
    CGFloat screenHeight;
CGFloat screenWidth;
}
@end

@implementation MoreUpdateViewController
@synthesize tblViewContent,lblStatus,viewNetwork,txtSearchBar,txtSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayUpdates=[[NSMutableArray alloc]init];
   
    txtSearchBar.text=txtSearch;
    [self setSearchUI];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    //[txtSearchBar becomeFirstResponder];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//
//  SettingViewController.m
//  Growth Cafe
//
//  Created by Mayank on 18/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//


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
    [[appDelegate _engine] getSearchResult:userId AndSearchText:txtSearchBar.text AndCatId:@"Update" AndCount:@"" success:^(NSDictionary *searchResult) {
        
        
        
        arrayUpdates=   [searchResult objectForKey:@"update"];
        

        
        
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
   return  [arrayUpdates count];
    
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
            for (NSString *strtemp in titleWords) {
                if([update.updateTitleArray count]<=textIndex)
                    break ;
                if([strtemp isEqualToString:@""])
                {
                    //  NSString* tempstr=[update.updateTitleArray objectAtIndex:textIndex];
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
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
    
            //[ cell.txtView addGestureRecognizer:tap];
            //   cell.txtView.tag=indexPath.row;
            
            
            [cell.txtView setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];
            
            [cell.txtView setAttributedText:attributedString ];
            
            CGPoint origin = [cell.txtView contentOffset];
            [cell.txtView setContentOffset:CGPointMake(origin.x, +11.0)];
          //  cell.txtView.delegate=self;
            
            cell.txtView.tag=100;
            
//            if(update.user !=nil)
//            {
//                [cell.btnUpdatedBy addTarget:self action:@selector(btnUserProfileClick:) forControlEvents:UIControlEventTouchUpInside];
//                
//                cell.btnUpdatedBy.tag = [update.user.userId  integerValue];
//            }
    
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
            // cal calculate the time
            NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:update.updatetime];
            
            NSString* scincetime=[AppGlobal timeLeftSinceDate:submittedDate];
            //   cell.lblCmtDate.text=comment.commentDate;
            scincetime = [scincetime stringByReplacingOccurrencesOfString:@"-"
                                                               withString:@""];
            // Set label text to attributed string
            // NSString *str = [NSString stringWithFormat:@"%@ ago" ,scincetime];
            //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            if(update.viewStatus ==1 )
            {
                cell.contentView.backgroundColor=[UIColor lightGrayColor];
                
            }else{
                cell.contentView.backgroundColor=[UIColor clearColor];
                
            }
            return cell;
    


    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
    
    
    
}

//
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


