//
//  RegisterationViewController.h
//  sLMS
//
//  Created by Mayank on 09/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface RegisterationViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtCnfPwd;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtAdminEmail;

@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet FBLoginView *btnFacebook;
@property (strong, nonatomic) IBOutlet UIButton *btnSchool;
@property (strong, nonatomic) IBOutlet UIButton *btnClass;
@property (strong, nonatomic) IBOutlet UIButton *btnHome;
@property (strong, nonatomic) IBOutlet UIButton *btnTitle;

- (IBAction)btnBcakClick:(id)sender ;
- (IBAction)btnSubmitClick:(id)sender;
- (IBAction)btnTitleClick:(id)sender;
- (IBAction)btnSignInClick:(id)sender;
- (IBAction)btnSchoolClick:(id)sender;
- (IBAction)btnClassClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIPickerView *mDataPickerView;
- (IBAction)btnHomeClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewLogin;
@property (strong, nonatomic) IBOutlet UIView *mViewAccountTypePicker;
- (IBAction)mBtnCancelPicker:(id)sender ;
- (IBAction)mBtnDonePicker:(id)sender ;
@end
