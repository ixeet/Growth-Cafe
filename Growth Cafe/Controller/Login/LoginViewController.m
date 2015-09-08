
//
//  LoginViewController.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomKeyboard.h"
#import "ForgetPasswordViewController.h"
#import "RegisterationViewController.h"
#import "UpdateViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface LoginViewController() <CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextField *activeTextField;
    BOOL isFirstLoginDone;
    AFNetworkReachabilityStatus previousStatus;
}

@end

@implementation LoginViewController
@synthesize btnRemember,txtPassword,txtUsername,imgLogo,btnFacebook;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //init the keyboard
      previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if([AppSingleton sharedInstance].isUserLoggedIn==YES)
    {
        [self.tabBarController.tabBar setHidden:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UIColor *color = [UIColor whiteColor];
    txtUsername.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Email"
     attributes:@{NSForegroundColorAttributeName:color}];

  
    txtPassword.attributedPlaceholder =
    [[NSAttributedString alloc]
     initWithString:@"Password"
     attributes:@{NSForegroundColorAttributeName:color}];

    customKeyboard = [[CustomKeyboard alloc] init];
    customKeyboard.delegate = self;
    
    //Default On Remember Me
    [btnRemember setSelected:YES];
    [self setDataOnView];
    [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
  

}
-(void)viewWillAppear:(BOOL)animated
{
    btnFacebook.delegate=self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(status==AFNetworkReachabilityStatusNotReachable)
        {   previousStatus=status;
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        }else{
            previousStatus=status;
            [self showNetworkStatus:REESTABLISH_INTERNET_MSG newVisibility:YES];
            
        }
        //       else  if(status!=AFNetworkReachabilityStatusNotReachable)
        //       {
        //           previousStatus=status;
        //           [self showNetworkStatus:@""];
        //
        //       }
    }];
 [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
-(void)viewWillDisappear:(BOOL)animated{
    btnFacebook.delegate=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Set data on view
-(void)setDataOnView{
    
    //Set Login Detail
//    BOOL rememberMe=[[AppGlobal getValueInDefault:key_rememberMe] boolValue];
//    if (rememberMe) {  //Save Login Detail In user default
//        NSString *loginID=[AppGlobal getValueInDefault:key_loginId];
//        NSString *loginPassword=[AppGlobal getValueInDefault:key_loginPassword];
//        [self.txtUsername setText:loginID];
//        [self.txtPassword setText:loginPassword];
//    }
    
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)changeFrameAndBackgroundImg
{
    
    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
   
    for (id loginObject in btnFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
            UIImage *loginImage = [UIImage imageNamed:@"login_white.png"];
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
#pragma mark - Private method implementation

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
    
  
    //if user is already sign in Then validate with server.
    // Check
    if(isFirstLoginDone) {
        // Execute code I want to run just once
        NSLog(@"fetched");
        return;
    }
    isFirstLoginDone=YES;
    // get user id
      NSLog(@"%@", user);
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
                                         [self loginError:error];
                                         [self loginViewShowingLoggedOutUser:loginView];

                                     }];
    
    
    // if user valid then navigate to main screen.
    
    //    self.profilePicture.profileID = user.id;
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
}

-(void)loginSucessFullWithFB:(NSString*)userid {
    // if FB Varification is done then navigate the main screen
   
    [AppGlobal  setValueInDefault:userid value:key_FBUSERID];
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
}

#pragma mark - Login Action

-(IBAction)btnRememberClick:(id)sender{
    
//    if ([btnRemember isSelected]) {
//        [btnRemember setSelected:NO];
//    }else{
//        [btnRemember setSelected:YES];
//    }
}



- (IBAction)btnLoginClick:(id)sender {
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO];
        return;
    }

    NSString *loginID=[[txtUsername text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password=[[txtPassword text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([loginID length] <= 0) {
        [AppGlobal showAlertWithMessage:MISSING_LOGIN_ID title:@""];
    }else if ( [AppGlobal validateEmailWithString:loginID]) {
        [AppGlobal showAlertWithMessage:MISSING_VALID_EMAIL_ID title:@""];
    }
    else if ([password length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_PASSWORD title:@""];
    }
    else{
        [txtUsername resignFirstResponder];
        [txtPassword resignFirstResponder];
        
        //Show Indicator
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
        [[appDelegate _engine] loginWithUserName:loginID password:password  rememberMe:[btnRemember isSelected]
                                         success:^(UserDetails *userDetail) {
                                             [AppSingleton sharedInstance].userDetail=userDetail;
                                             [AppSingleton sharedInstance].isUserLoggedIn=YES;
                                             [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
                                             [self loginSucessFull];
                                             
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
                                         }
                                         failure:^(NSError *error) {
                                             //Hide Indicator
                                             [appDelegate hideSpinner];
                                             NSLog(@"failure JsonData %@",[error description]);
                                             [self loginError:error];
                                             
                                         }];
    }
    
    
    
}

- (IBAction)btnCreatAccount:(id)sender {
    RegisterationViewController *viewController= [[RegisterationViewController alloc]initWithNibName:@"RegisterationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)btnForgetpasswordClick:(id)sender {
    ForgetPasswordViewController *forgetViewController= [[ForgetPasswordViewController alloc]initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetViewController animated:YES];
}





-(void)loginSucessFull{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:txtUsername.text     forKey:@"loginName"];
    [defaults setObject:txtPassword.text  forKey:@"Password"];
    [txtUsername setText:@""];
    [txtPassword setText:@""];
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}

//- (void) loginButton:	(FBSDKLoginButton *)loginButton didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
//error:	(NSError *)error
//{
//    if ([FBSDKAccessToken currentAccessToken]) {
//        // User is logged in, do work such as go to next view controller.
//    }
//}
//- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
//    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies]) {
//        [storage deleteCookie:cookie];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//}
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
}
#pragma --
#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //[self setPositionOfLoginBaseViewWhenStartEditing];
    
    activeTextField = textField;
    
    UIToolbar* toolbar;
    if (textField.tag == 10) {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE];
        
    }
    else if (textField.tag == 11)
    {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :FALSE];
        
    }
    [textField setInputAccessoryView:toolbar];
    
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
    if(textField.tag==11)
    {
        [textField resignFirstResponder];
        [self btnLoginClick:self];
    }else{
        [textField resignFirstResponder];
        [self nextClicked:textField.tag];
    }
    
  
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
}
#pragma mark Custom Keyboard Delegate

- (void)nextClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag + 1;
    
    UITextField *nextResponder = (UITextField*)[self.view viewWithTag:nextTag];
    
    if (!nextResponder.enabled) {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag+1];
    }
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        //Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
    }
}
- (void)previousClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag -1;
    
    UITextField *nextResponder = (UITextField*) [self.view  viewWithTag:nextTag];
    
    while(!nextResponder.enabled)
    {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag-1];
    }
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
        
    }
    
}
- (void)doneClicked:(NSUInteger)selectedId
{
    
    
    [activeTextField resignFirstResponder];
    
}

- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}


@end
