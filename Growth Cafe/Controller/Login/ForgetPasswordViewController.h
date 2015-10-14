//
//  ForgetPasswordViewController.h
//  sLMS
//
//  Created by Mayank on 10/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface ForgetPasswordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
- (IBAction)btnBackClick:(id)sender ;
- (IBAction)btnSubmit:(id)sender ;
- (IBAction)btnLoginClick:(id)sender;
@property (weak, nonatomic) IBOutlet FBLoginView *btnFacebook;
@end
