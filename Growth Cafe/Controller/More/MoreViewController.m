//
//  MoreViewController.m
//  sLMS
//
//  Created by Mayank on 27/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

//- (IBAction)btnFBClick:(id)sender {
//    
//    // get user id
//    NSString *username=  [AppGlobal getValueInDefault:key_UserId];
//    
//    //Show Indicator
//    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
//    [[appDelegate _engine] SetFBloginWithUserID:username FBID:[AppGlobal getValueInDefault:key_FBUSERID]  success:^(bool status){
//        
//        
//    }failure:^(NSError *error){
//      
//        
//    }];
//    
//    
//}
//
//- (IBAction)btnLogoutClick:(id)sender {
//}
//
//-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
//    
//    NSLog(@"%@", user);
//    //if user is already sign in Then validate with server.
//    
//    // get user id
//    NSString *userid=[NSString  stringWithFormat:@"%@",[user objectForKey:@"id"]];
//    
//    //Show Indicator
//    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
//    
//    [[appDelegate _engine] FBloginWithUserID:userid success:^(UserDetails *userDetail) {
//        [AppGlobal setValueInDefault:key_UserId value:userDetail.userId];
//        [AppGlobal setValueInDefault:key_UserName value:userDetail.userFirstName];
//        [AppGlobal setValueInDefault:key_UserEmail value:userDetail.userEmail];
//        [self loginSucessFullWithFB:userid];
//        _fbview.hidden=YES;
//        _btnFB.hidden=NO;
//        //Hide Indicator
//        [appDelegate hideSpinner];
//    }
//                                     failure:^(NSError *error) {
//                                         //Hide Indicator
//                                         [appDelegate hideSpinner];
//                                         NSLog(@"failure JsonData %@",[error description]);
//                                         [self loginError:error];
//                                         [self loginViewShowingLoggedOutUser:loginView];
//                                         _fbview.hidden=NO;
//                                         _btnFB.hidden=YES;
//                                     }];
//    
//    
//    // if user valid then navigate to main screen.
//    
//    //    self.profilePicture.profileID = user.id;
//    //    self.lblUsername.text = user.name;
//    //    self.lblEmail.text = [user objectForKey:@"email"];
//}
//
//-(void)loginSucessFullWithFB:(NSString*)userid {
//    // if FB Varification is done then navigate the main screen
//    
//    [AppGlobal  setValueInDefault:userid value:key_FBUSERID];
//
//}
//-(void)loginError:(NSError*)error{
//    
//    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
//}
//#pragma mark - Private method implementation
//
//-(void)toggleHiddenState:(BOOL)shouldHide{
//    //    self.lblUsername.hidden = shouldHide;
//    //    self.lblEmail.hidden = shouldHide;
//    //    self.profilePicture.hidden = shouldHide;
//}
//
//
//#pragma mark - FBLoginView Delegate method implementation
//
//-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
//    // self.lblLoginStatus.text = @"You are logged in.";
//    
//    [self toggleHiddenState:NO];
//    [self changeFrameAndBackgroundImg];
//}
//-(void)changeFrameAndBackgroundImg
//{
//    
//    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
//    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
//    for (id loginObject in _fbview.subviews)
//    {
//        if ([loginObject isKindOfClass:[UIButton class]])
//        {
//            UIButton * loginButton =  loginObject;
//            UIImage *loginImage = [UIImage imageNamed:@"login_white.png"];
//            // loginButton.alpha = 0.7;
//            [loginButton setBackgroundColor:[UIColor colorWithRed:186.0 green:0.0 blue:50.0 alpha:0.0]];
//            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
//            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
//            //CGSize constraint = CGSizeMake(400, 220);
//            // [loginButton sizeThatFits:constraint];
//            //[loginButton sizeToFit];
//        }
//        if ([loginObject isKindOfClass:[UILabel class]])
//        {
//            UILabel * loginLabel =  loginObject;
//            loginLabel.text = @"";
//            loginLabel.frame = CGRectMake(0, 0, 0, 0);
//        }
//    }
//}
//-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
//    // self.lblLoginStatus.text = @"You are logged out";
//    [FBSession.activeSession closeAndClearTokenInformation];
//    [FBSession.activeSession close];
//    [FBSession setActiveSession:nil];
//    [self toggleHiddenState:YES];
//}
@end
