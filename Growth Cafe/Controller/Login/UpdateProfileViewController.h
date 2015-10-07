//
//  UpdateProfileViewController.h
//  Growth Cafe
//
//  Created by Mayank on 24/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface UpdateProfileViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet FBLoginView *btnFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UIButton *btnTitle;
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
- (IBAction)btnTitleClick:(id)sender;
- (IBAction)btnGroupClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *mViewAccountTypePicker;
- (IBAction)mBtnCancelPicker:(id)sender ;
- (IBAction)btnLogoutClick:(id)sender;
- (IBAction)mBtnDonePicker:(id)sender ;
@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
