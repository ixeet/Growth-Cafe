//
//  SearchViewController.m
//  Growth Cafe
//
//  Created by Mayank on 25/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "SearchViewController.h"
#import "NotificationTableViewCell.h"
#import "UpdateDetailViewController.h"
#import "UserProfileTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "ModuleNameTableViewCell.h"
#import "MoreCourseViewController.h"
#import "MoreUpdateViewController.h"
#import "MoreUsersViewController.h"
#import "ProfileViewController.h"
#import "CourseViewController.h"
#import "AssignmentViewController.h"
@interface SearchViewController ()
{
    NSMutableArray *arrayUpdates,*arrayUsers,*arrayCourses,*arrayAsignemnts;
    int selectedRow;
    BOOL viewMoreUpdate,viewMoreUser,viewMoreCourse,viewMoreAsignemnts;

 AFNetworkReachabilityStatus previousStatus;
    CGFloat screenHeight;
    CGFloat screenWidth;

}
@end

@implementation SearchViewController
@synthesize tblViewContent,lblStatus,viewNetwork,txtSearchBar;

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

- (IBAction)btnProfileClick:(id)sender {
}
//
//  SettingViewController.m
//  Growth Cafe
//
//  Created by Mayank on 18/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayUpdates=[[NSMutableArray alloc]init];
    arrayUsers=[[NSMutableArray alloc]init];
    arrayCourses=[[NSMutableArray alloc]init];
    arrayAsignemnts=[[NSMutableArray alloc]init];
    [self setSearchUI];
//    tblViewContent.layer.cornerRadius = 5.0f;
//    [tblViewContent setClipsToBounds:YES];
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(dismissKeyboard)];
    tap.minimumPressDuration = 0.2; //seconds
    [self.view addGestureRecognizer:tap];
   
}
-(void)viewWillAppear:(BOOL)animated
{
//    arrayUpdates=[[NSMutableArray alloc]init];
//    arrayUsers=[[NSMutableArray alloc]init];
//    arrayCourses=[[NSMutableArray alloc]init];
//    arrayAsignemnts=[[NSMutableArray alloc]init];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
   // [txtSearchBar becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    /* remove for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:UIKeyboardWillHideNotification object:nil];


}
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

-(void)setSearchUI
{
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        
     
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
            [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxn_6Plus.png"]];
            

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
        
        [txtSearchBar setBackgroundImage:[UIImage imageNamed:@"img_search-boxnS.png"]];
        
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
    [[appDelegate _engine] getSearchResult:userId AndSearchText:txtSearchBar.text AndCatId:@"" AndCount:@"" success:^(NSDictionary *searchResult) {
        
        arrayUsers=     [searchResult objectForKey:@"user"];
        arrayUpdates=   [searchResult objectForKey:@"update"];
        arrayCourses=   [searchResult objectForKey:@"course"];
        arrayAsignemnts= [searchResult objectForKey:@"assignment"];
        
        if([[searchResult objectForKey:@"totalUsersCount"] integerValue]>0)
            viewMoreUser=YES;
        
        
        if([[searchResult objectForKey:@"totalFeedsCount"] integerValue]>0)
            viewMoreUpdate=YES;
        
        if([[searchResult objectForKey:@"totalCoursesCount"] integerValue]>0)
            viewMoreCourse=YES;
        
        if([[searchResult objectForKey:@"totalAssignmentsCount"] integerValue]>0)
            viewMoreAsignemnts=YES;
        
        if(!([arrayUsers count] >0 || [arrayUpdates count] >0|| [arrayAsignemnts count] >0|| [arrayCourses count] >0))
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
    switch (section) {
        case 0:
            return [arrayUpdates count];
            break;
        case 1:
            return [arrayCourses count];
            break;
        case 2:
            return [arrayAsignemnts count];
            break;
        case 3:
            return [arrayUsers count];
            
            break;
        default:
            break;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
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
//            
//            [ cell.txtView addGestureRecognizer:tap];
//            //   cell.txtView.tag=indexPath.row;
            
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
            
            [cell.txtView setTextColor: [UIColor colorWithRed:20.0/255.0 green:24.0/255.0  blue:35.0/255.0  alpha:1]];
            
            [cell.txtView setAttributedText:attributedString ];
            
            CGPoint origin = [cell.txtView contentOffset];
            [cell.txtView setContentOffset:CGPointMake(origin.x, +11.0)];
            //cell.txtView.delegate=self;
            
            cell.txtView.tag=100;
            
            
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
                      // Set label text to attributed string
            // NSString *str = [NSString stringWithFormat:@"%@ ago" ,scincetime];
            //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            if(update.viewStatus ==1 )
            {
                cell.contentView.backgroundColor=[UIColor lightGrayColor];
                
            }else{
                cell.contentView.backgroundColor=[UIColor clearColor];
                
            }
            cell.imgSeprator.hidden=YES;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 1:
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
            Courses *course=[arrayCourses objectAtIndex:indexPath.row];
            cell.lblCourseName.text=course.courseName;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // cal calculate the time
                        return cell;

        }
            break;
        case 2:
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
            Assignment *assignment=[arrayAsignemnts objectAtIndex:indexPath.row];
            cell.lblCourseName.text= [NSString stringWithFormat:@"%@ assignment assign to %@",assignment.assignmentName,assignment.assignmentSubmittedBy];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // cal calculate the time
            return cell;


        }
            break;
        case 3:
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
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:{
            //show Update Detail
           
             Update *objUpdate=[arrayUpdates objectAtIndex:indexPath.row];;
            //Show Indicator
            [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
            
            [[appDelegate _engine] getUpdatesDetail:objUpdate.updateId   success:^(Update *updates) {
              
                
               
                
                //Hide Indicator
                [appDelegate hideSpinner];
                //[AppSingleton sharedInstance].updatedUpdate=updates;
                 UpdateDetailViewController *updateDetailView=[[UpdateDetailViewController alloc]initWithNibName:@"UpdateDetailViewController" bundle:nil];
                updateDetailView.objUpdate  =updates;
                [self.navigationController pushViewController:updateDetailView animated:YES];
                // [self loginSucessFullWithFB];
                
               
            }
                                            failure:^(NSError *error) {
                                                //Hide Indicator
                                                [appDelegate hideSpinner];
                                                NSLog(@"failure JsonData %@",[error description]);
                                                [self loginError:error];
                                                //                                         [self loginViewShowingLoggedOutUser:loginView];
                                                
                                            }];
          
        }
            break;
        case 1:
            //show Course Detail
        {
            // call the Course Detail Service
            if(previousStatus==AFNetworkReachabilityStatusNotReachable)
            {
                [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
                return;
            }
            Courses *course=[arrayCourses objectAtIndex:indexPath.row];
            [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
            
            
            [[appDelegate _engine] getCourseDetailById:course.courseId success:^(NSMutableArray *courseList) {
                
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
                                               
                                               
                                           }];
            
        }
            break;
        case 2:
        {
             //show Assignment Detail
//            Assignment *assignment=[arrayAsignemnts objectAtIndex:indexPath.row];
//            [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
//            
//            NSString *assignmentid=[NSString stringWithFormat:@"%@",assignment.assignmentId];
//            NSString *userId=[NSString stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId ];
//            
//            [[appDelegate _engine] getAssignmentsById:userId AndAssignment:assignmentid success:^(NSMutableArray *assignmentList) {
//                [appDelegate hideSpinner];
//                //Hide Indicator
//                AssignmentViewController *assignment=[[AssignmentViewController alloc]init];
//                assignment.selectedAssignment=assignmentList;
//               
//                [self.navigationController pushViewController:assignment animated:YES];
//                
//                
//            }
//                                               failure:^(NSError *error) {
//                                                   //Hide Indicator
//                                                   [appDelegate hideSpinner];
//                                                   NSLog(@"failure JsonData %@",[error description]);
//                                                   
//                                                   
//                                               }];
        }
            break;
        case 3:
        {
            //show full Profile
            
            // call the user profi{le service user profile
            UserDetails *usrDetail=[arrayUsers objectAtIndex:indexPath.row];
            ProfileViewController *profileView=[[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
            profileView.user=usrDetail;
            [self.navigationController pushViewController:profileView animated:YES];
             break;
        }
            
           
           
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
            {
                return 90;
               
            }
            return 70;
        }
            break;
        case 1:
            //show Course Detail
            return 30;
            break;
        case 2:
            //show Assignment Detail
                return 30;
            break;
        case 3:
            //show full Profile
                return 30;
            break;
        default:
            break;
    }
    return 0;
    
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"Update";
            break;
        case 1:
            return @"Course";
            break;
        case 2:
            return @"Assignment";
            break;
        case 3:
            return @"Profile";
            
            break;
        default:
            return nil;
            break;
    }
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == tblViewContent) {    // self.tableview
//            CGFloat cornerRadius = 5.f;
//            //  cell.backgroundColor = UIColor.clearColor;
//            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//            CGMutablePathRef pathRef = CGPathCreateMutable();
//            CGRect bounds = CGRectInset(cell.bounds, 5, 0);
//            BOOL addLine = NO;
//            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
//            } else if (indexPath.row == 0) {
//                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
//                addLine = YES;
//            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
//                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
//                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
//                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
//            } else {
//                CGPathAddRect(pathRef, nil, bounds);
//                addLine = YES;
//            }
//            layer.path = pathRef;
//            CFRelease(pathRef);
//            layer.fillColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:224.0/255.0 alpha:1].CGColor;
//            
//            if (addLine == YES) {
//                CALayer *lineLayer = [[CALayer alloc] init];
//                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
//                //  lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//                [layer addSublayer:lineLayer];
//            }
//            UIView *testView = [[UIView alloc] initWithFrame:bounds];
//            [testView.layer insertSublayer:layer atIndex:0];
//            // testView.backgroundColor = UIColor.clearColor;
//            cell.backgroundView = testView;
//        }
//    }
//}
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerview=[[UIView alloc] init];
    footerview.backgroundColor=[UIColor whiteColor];
    if(section==0)
    {
        //        if([arrayUpdates count]>SEARCH_PER_PAGE)
        //        {
        
        UIButton *btnMore=[[UIButton alloc]init];
        btnMore.frame = CGRectMake((screenWidth-150)/2, 0,150,30);
        NSString *title=@"No Record Found";
        if (viewMoreUpdate) {
            title=@"view more";
            [btnMore  addTarget:self action:@selector(btnMoreUpdate:) forControlEvents:UIControlEventTouchUpInside];
        }
        [btnMore setTitle:title forState:UIControlStateNormal];
        
        
        btnMore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        [btnMore setTitleColor:[UIColor colorWithRed:129.0/255.0 green:132.0/255.0 blue:139.0/255.0 alpha:1] forState:UIControlStateNormal];
        [footerview addSubview:btnMore];
        // }
    }else if(section==1)
    {
        //        if([arrayCourses count]>SEARCH_PER_PAGE)
        //        {
        
        UIButton *btnMore=[[UIButton alloc]init];
        btnMore.frame = CGRectMake((screenWidth-150)/2, 0,150,30);
        NSString *title=@"No Record Found";
        if (viewMoreCourse) {
            title=@"view more";
            [btnMore  addTarget:self action:@selector(btnMoreCourse:) forControlEvents:UIControlEventTouchUpInside];
        }
        [btnMore setTitle:title forState:UIControlStateNormal];
        
        btnMore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        [btnMore setTitleColor:[UIColor colorWithRed:129.0/255.0 green:132.0/255.0 blue:139.0/255.0 alpha:1] forState:UIControlStateNormal];
        [footerview addSubview:btnMore];
        //        }
    }
    else if(section==2)
    {
        //        if([arrayAsignemnts count]>SEARCH_PER_PAGE)
        //        {
        
        UIButton *btnMore=[[UIButton alloc]init];
        btnMore.frame = CGRectMake((screenWidth-150)/2, 0,150,30);
        NSString *title=@"No Record Found";
        if (viewMoreAsignemnts) {
            title=@"view more";
            [btnMore  addTarget:self action:@selector(btnMoreAssignment:) forControlEvents:UIControlEventTouchUpInside];
        }
        [btnMore setTitle:title forState:UIControlStateNormal];
        
        btnMore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        [btnMore setTitleColor:[UIColor colorWithRed:129.0/255.0 green:132.0/255.0 blue:139.0/255.0 alpha:1] forState:UIControlStateNormal];
        [footerview addSubview:btnMore];
        // }
    }
    else if(section==3)
    {
        //        if([arrayUsers count]>SEARCH_PER_PAGE)
        //        {
        
        UIButton *btnMore=[[UIButton alloc]init];
        btnMore.frame = CGRectMake((screenWidth-150)/2, 0,150,30);
        NSString *title=@"No Record Found";
        if (viewMoreUser) {
            title=@"view more";
            [btnMore  addTarget:self action:@selector(btnMorePrfile:) forControlEvents:UIControlEventTouchUpInside];
        }
        [btnMore setTitle:title forState:UIControlStateNormal];
        
        btnMore.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        [btnMore setTitleColor:[UIColor colorWithRed:129.0/255.0 green:132.0/255.0 blue:139.0/255.0 alpha:1] forState:UIControlStateNormal];
        [footerview addSubview:btnMore];
        //        }
    }
    //    footerview.layer.cornerRadius = 5.0f;
    //    [footerview setClipsToBounds:YES];
    return footerview;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    if(section==0)
        myLabel.frame = CGRectMake(14, 5,320,25);
    else
        myLabel.frame = CGRectMake(14, 5, 320, 25);
    
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textColor =[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1];
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:214.0/255.0 blue:219.0/255.0 alpha:1];
    [headerView addSubview:myLabel];
    NSLog(@"header section=%ld frame x=%f,y=%f,Width=%f Height=%f",(long)section,headerView.frame.origin.x,headerView.frame.origin.y,headerView.frame.size.width,headerView.frame.size.height);
    return headerView;
}
-(void)loginError:(NSError*)error{
   
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
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

- (IBAction)btnMoreUpdate:(id)sender {
    MoreUpdateViewController *moreViewController=[[MoreUpdateViewController alloc]initWithNibName:@"MoreUpdateViewController" bundle:nil];
    moreViewController.txtSearch=txtSearchBar.text;
    [self.navigationController pushViewController:moreViewController animated:YES];
}
- (IBAction)btnMoreCourse:(id)sender {
    MoreCourseViewController *moreViewController=[[MoreCourseViewController alloc]initWithNibName:@"MoreCourseViewController" bundle:nil];
    moreViewController.txtSearch=txtSearchBar.text;
    moreViewController.isCourse=YES;
    [self.navigationController pushViewController:moreViewController animated:YES];
}
- (IBAction)btnMoreAssignment:(id)sender {
    MoreCourseViewController *moreViewController=[[MoreCourseViewController alloc]initWithNibName:@"MoreCourseViewController" bundle:nil];
    moreViewController.txtSearch=txtSearchBar.text;
    moreViewController.isCourse=NO;
    [self.navigationController pushViewController:moreViewController animated:YES];
}
- (IBAction)btnMorePrfile:(id)sender {
    MoreUsersViewController *moreViewController=[[MoreUsersViewController alloc]initWithNibName:@"MoreUsersViewController" bundle:nil];
    moreViewController.txtSearch=txtSearchBar.text;
    [self.navigationController pushViewController:moreViewController animated:YES];
}
- (IBAction)btnCancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - UISearchBar Delegate Method

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
       
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

