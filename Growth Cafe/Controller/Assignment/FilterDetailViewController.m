//
//  FilterDetailViewController.m
//  Growth Cafe
//
//  Created by Mayank on 19/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "FilterDetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface FilterDetailViewController ()
{
    NSMutableArray *arrayAllData;
    AFNetworkReachabilityStatus previousStatus;
}
@end



@implementation FilterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arrayAllData=[AppGlobal getDropdownList:SCHOOL_DATA];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnDoneClick:(id)sender {
}

- (IBAction)btnBackClick:(id)sender {
}
- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
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
    return  [arrayAllData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = ( UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    NSDictionary *dic = arrayAllData[indexPath.row];
    
    cell.textLabel.text=[dic objectForKey:@"Title"];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    cell.textLabel.font=font;
    return cell;
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = arrayAllData[indexPath.row];
    
}

@end
//
