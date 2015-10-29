//
//  SettingViewController.m
//  Growth Cafe
//
//  Created by Mayank on 18/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "FollowListViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface SettingViewController ()
{
    NSMutableArray *arraySettingList;
    NSMutableArray *arraySettingImageList;
    int selectedRow;
    AFNetworkReachabilityStatus previousStatus;
    

}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    // Do any additional setup after loading the view from its nib.
    previousStatus=AFNetworkReachabilityStatusUnknown;
    // Do any additional setup after loading the view from its nib.
    arraySettingList=[[NSMutableArray alloc]init];
    [arraySettingList addObject:@"Organizations"];
    [arraySettingList addObject:@"Districts"];
    [arraySettingList addObject:@"Departments"];
    [arraySettingList addObject:@"Groups"];
    [arraySettingList addObject:@"Unfollow people to hide their updates"];
    
    
    arraySettingImageList=[[NSMutableArray alloc]init];
    
    [arraySettingImageList addObject:@"organizations.png"];
    [arraySettingImageList addObject:@"districts.png"];
    [arraySettingImageList addObject:@"departments.png"];
    [arraySettingImageList addObject:@"groups.png"];
    [arraySettingImageList addObject:@"hide_user.png"];
    tblSetting.layer.cornerRadius = 5.0f;
    [tblSetting setClipsToBounds:YES];
   
}


- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
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
     [self getMySetting];
}
    

-(void)getMySetting{
    
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        return;
    }

    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    NSString *userId=[NSString stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId ];
    [[appDelegate _engine] getMySetting:userId success:^(NSDictionary *setting) {
        
        if([setting valueForKey:@"selected"]!=nil)
        {
            selectedRow=(int)[[setting valueForKey:@"selected"] integerValue]-1;
        }
        
        //Hide Indicator
        [appDelegate hideSpinner];
        [tblSetting reloadData];
        
        
    }
                                failure:^(NSError *error) {
                                    //Hide Indicator
                                    [appDelegate hideSpinner];
                                    NSLog(@"failure Json Data %@",[error description]);
                                    [self settingError:error];
                                    
                                }];
    
}
-(void)setMySetting{
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    NSString *userId=[NSString stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId ];
    NSString *settingId=[NSString stringWithFormat:@"%d",selectedRow+1 ];
    [[appDelegate _engine] setMySetting:userId AndSettingId:settingId success:^(BOOL successValue) {
        
        //Hide Indicator
        [appDelegate hideSpinner];
        [tblSetting reloadData];
        
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return [arraySettingList count]-1;
    else return  1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"SettingTableViewCell";
    SettingTableViewCell *cell = (SettingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    
    if(indexPath.section==0)
    {
        
                [cell.imgIcon setImage:[UIImage imageNamed:arraySettingImageList[indexPath.row]]];
        if(selectedRow==indexPath.row)
        {
            
            
            [cell.btnSelected setImage:[UIImage imageNamed:@"notificationticked.png"] forState:UIControlStateNormal];
        }else{
            [cell.btnSelected setImage:[UIImage imageNamed:@"notificationtick.png"] forState:UIControlStateNormal];
            
        }
        cell.lblTitle.text=arraySettingList[indexPath.row];
        
    }else{
        [cell.imgIcon setImage:[UIImage imageNamed:arraySettingImageList[ [arraySettingImageList count]-1]]];
        cell.lblTitle.text=arraySettingList[[arraySettingImageList count]-1];
        [cell.btnSelected setImage:[UIImage imageNamed:@"icn_arrow.png"] forState:UIControlStateNormal];
        
    }
    CGRect frame = cell.backgroundView.frame;
    //cell.backgroundView = [[BackgroundView alloc] initWithFrame:frame];
    
    //    CGFloat corner = 20.0f;
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.backgroundView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)];
    //    CAShapeLayer  *shapeLayer = (CAShapeLayer *)cell.backgroundView.layer;
    //    shapeLayer.path = path.CGPath;
    //    shapeLayer.fillColor = cell.textLabel.backgroundColor.CGColor;
    //    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    //    shapeLayer.lineWidth = 1.0f;
    
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        selectedRow=(int)indexPath.row ;
        [self setMySetting];
        
        
    }else{
        //move to next screen;
        FollowListViewController *viewController= [[FollowListViewController alloc]initWithNibName:@"FollowListViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
    
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return @"WHO CAN SEE MY UPDATES?";
    else
        return @"HIDE POST ON MY TIMELINE";
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == tblSetting) {    // self.tableview
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
//            //testView.backgroundColor = UIColor.clearColor;
//            cell.backgroundView = testView;
//        }
//    }
//     cell.selectionStyle = UITableViewCellSelectionStyleNone;
//}
-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
    footerview.backgroundColor=[UIColor whiteColor];
    //    footerview.layer.cornerRadius = 5.0f;
    //    [footerview setClipsToBounds:YES];
    return footerview;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    if(section==0)
       if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
       {
        myLabel.frame = CGRectMake(14, 25, 320, 20);
       } else{
       
           myLabel.frame = CGRectMake(80, 25, 320, 20);
       
       }
    else
        
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        myLabel.frame = CGRectMake(14, 10, 320, 20);
        }else {
        
         myLabel.frame = CGRectMake(80, 10, 320, 20);
        
        }
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textColor =[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1];
    UIView *headerView = [[UIView alloc] init];
    
    [headerView addSubview:myLabel];
    NSLog(@"header section=%ld frame x=%f,y=%f,Width=%f Height=%f",(long)section,headerView.frame.origin.x,headerView.frame.origin.y,headerView.frame.size.width,headerView.frame.size.height);
    return headerView;
}
- (IBAction)btnBackclick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
