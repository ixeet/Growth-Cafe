//
//  CustomContentView.h
//  sLMS
//
//  Created by Mayank on 22/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
@interface CustomProfileView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet FBLoginView *btnFacebook;
@property (strong, nonatomic) IBOutlet UILabel *lblClass;
@property (strong, nonatomic) IBOutlet UILabel *lblHome;

@property (strong, nonatomic) IBOutlet UILabel *lblSchoolName;
@property (strong, nonatomic) IBOutlet UIButton *btnImg;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
-(void)setUserProfile;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;


@end
 