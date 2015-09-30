//
//  MoreViewController.h
//  sLMS
//
//  Created by Mayank on 27/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
- (IBAction)btnInstructionsClick:(id)sender;
- (IBAction)btnSettingClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnSetting;

@property (strong, nonatomic) IBOutlet UIButton *btnInstructions;
@end
