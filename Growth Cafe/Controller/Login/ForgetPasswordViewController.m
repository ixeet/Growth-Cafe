//
//  ForgetPasswordViewController.m
//  sLMS
//
//  Created by Mayank on 10/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "RegisterationViewController.h"
#import "LoginViewController.h"

@interface ForgetPasswordViewController ()
{
    BOOL isFirstLoginDone;
}
@end

@implementation ForgetPasswordViewController
@synthesize txtUsername,btnFacebook;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    isFirstLoginDone=NO;
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    btnFacebook.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated{
    btnFacebook.delegate=nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnBackClick:(id)sender {
      [self.navigationController popViewControllerAnimated:YES ];
}
- (IBAction)btnSubmit:(id)sender {
    NSString *loginID=[[txtUsername text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([loginID length] <= 0) {
        [AppGlobal showAlertWithMessage:MISSING_FORGET_EMAIL title:@""];
    }
   else if ([AppGlobal validateEmailWithString:loginID]) {
        [AppGlobal showAlertWithMessage:MISSING_VALID_EMAIL_ID title:@""];
    }
    else{
        [txtUsername resignFirstResponder];
      
        
        //Show Indicator
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
        [[appDelegate _engine] ForgetPasswordWithUserName:loginID success:^(BOOL logoutValue) {
           
            [AppGlobal showAlertWithMessage:FORGET_SUCCESS_MSG(loginID) title:@""];
                                             //Hide Indicator
            
                                             [appDelegate hideSpinner];
            LoginViewController *loginview=[[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginview animated:YES];
                                         }
                                         failure:^(NSError *error) {
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
                                             NSLog(@"failure JsonData %@",[error description]);
                                            
                                             [self ForgotPasswordError:error];
                                         }];
    }
    
    
}
-(void)ForgotPasswordError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
- (IBAction)btnLoginClick:(id)sender {
    RegisterationViewController *viewController= [[RegisterationViewController alloc]initWithNibName:@"RegisterationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];


}
#pragma --
#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //[self setPositionOfLoginBaseViewWhenStartEditing];
    
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
   
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}
#pragma mark - Private method implementation
-(void)changeFrameAndBackgroundImg
{
    
    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    for (id loginObject in btnFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
            UIImage *loginImage = [UIImage imageNamed:@"fb_login_blue.png"];
            // loginButton.alpha = 0.7;
            [loginButton setBackgroundColor:[UIColor colorWithRed:186.0 green:0.0 blue:50.0 alpha:0.0]];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            //CGSize constraint = CGSizeMake(400, 220);
            // [loginButton sizeThatFits:constraint];
            //[loginButton sizeToFit];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}
-(void)toggleHiddenState:(BOOL)shouldHide{
    //    self.lblUsername.hidden = shouldHide;
    //    self.lblEmail.hidden = shouldHide;
    //    self.profilePicture.hidden = shouldHide;
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
    [self changeFrameAndBackgroundImg];
}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    
    // Check
    if(isFirstLoginDone) {
        // Execute code I want to run just once
        NSLog(@"fetched");
        return;
    }
    isFirstLoginDone=YES;
    // get user id
    NSLog(@"%@", user);
    //if user is already sign in Then validate with server.
    
    // get user id
    NSString *userid=[NSString  stringWithFormat:@"%@",[user objectForKey:@"id"]];
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] FBloginWithUserID:userid success:^(UserDetails *userDetail) {
        [AppSingleton sharedInstance].userDetail=userDetail;
        [AppSingleton sharedInstance].isUserLoggedIn=YES;
        [AppSingleton sharedInstance].isUserFBLoggedIn=YES;
        [self loginSucessFullWithFB:userid];
        
        //Hide Indicator
        [appDelegate hideSpinner];
    }
                                     failure:^(NSError *error) {
                                         //Hide Indicator
                                         [appDelegate hideSpinner];
                                         NSLog(@"failure JsonData %@",[error description]);
                                         [self loginViewShowingLoggedOutUser:loginView];

                                         [self loginError:error];
                                         
                                     }];
    
    
    // if user valid then navigate to main screen.
    
    //    self.profilePicture.profileID = user.id;
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
}

-(void)loginSucessFullWithFB:(NSString*)userid {
    // if FB Varification is done then navigate the main screen
    
    [AppGlobal  setValueInDefault:userid value:key_FBUSERID];
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}

@end
