//
//  UpdateProfileViewController.h
//  Growth Cafe
//
//  Created by Mayank on 24/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface UpdateProfileViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet FBLoginView *btnFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UIButton *btnMr;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
- (IBAction)btnDeprtmentClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *mDataPickerView;
@property (strong, nonatomic) IBOutlet UIButton *btnDeprtment;
- (IBAction)btnOrgClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnOrg;
@property (strong, nonatomic) IBOutlet UIButton *btnGroup;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnPhotoClick:(id)sender;
- (IBAction)btnMrClick:(id)sender;
- (IBAction)btnGroupClick:(id)sender;

@end