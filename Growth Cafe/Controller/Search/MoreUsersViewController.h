//
//  MoreUsersViewController.h
//  Growth Cafe
//
//  Created by Mayank on 09/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreUsersViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblViewContent;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@property (strong, nonatomic)  NSString *txtSearch;
@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (assign, nonatomic) BOOL  isCourse;
- (IBAction)btnProfileClick:(id)sender;
- (IBAction)btnBackclick:(id)sender;
@end
