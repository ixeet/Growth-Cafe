//
//  HomeViewController.m
//  sLMS
//
//  Created by Mayank on 08/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "HomeViewController.h"
#import "RegisterationViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize _homeViewController,_navigationController_Login;
- (void)viewDidLoad {
    [super viewDidLoad];

    if(  [AppSingleton sharedInstance].isUserLoggedIn==YES)
    {
        [self.tabBarController.tabBar setHidden:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
        
    
    
    [self toggleHiddenState:YES];
   // self.lblLoginStatus.text = @"";
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
-(void)changeFrameAndBackgroundImg
{
    
//  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
  //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    for (id loginObject in _btnFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
        UIImage *loginImage = [UIImage imageNamed:@"login_red1.png"];
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
                                             [self loginSucessFull];
                                             
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
   
}

-(void)loginSucessFull{
    // if FB Varification is done then navigate the main screen
    
   
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
   // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ButtonClicks


- (IBAction)btnLoginClick:(id)sender {
    LoginViewController *loginViewController= [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)btnRegisterClick:(id)sender {
    RegisterationViewController *viewController= [[RegisterationViewController alloc]initWithNibName:@"RegisterationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];

}
@end
