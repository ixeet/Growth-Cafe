//
//  ProfileViewController.h
//  sLMS
//
//  Created by Mayank on 30/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblSchoolName;
@property (strong, nonatomic) IBOutlet UILabel *lblSchoolAdminEmail;
@property (strong, nonatomic) IBOutlet UILabel *lblClass;
@property (strong, nonatomic) IBOutlet UILabel *lblHomeRoom;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackClick:(id)sender;

@property (strong, nonatomic) IBOutlet UserDetails *user;
@end
