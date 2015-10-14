//
//  FilterDetailViewController.h
//  Growth Cafe
//
//  Created by Mayank on 19/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterDetailViewController : UIViewController

- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tblContentView;

@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@end
