//
//  SettingViewController.h
//  Growth Cafe
//
//  Created by Mayank on 18/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    IBOutlet UITableView *tblSetting;
    
}
- (IBAction)btnBackclick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@end
