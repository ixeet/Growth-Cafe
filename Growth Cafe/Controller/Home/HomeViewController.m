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
#import <CrashReporter/CrashReporter.h>
#import "AFHTTPRequestOperationManager.h"
//#import "SubmitAssignmentViewController.h"
@interface HomeViewController ()
{
    BOOL isFirstLoginDone;
    
    AFNetworkReachabilityStatus previousStatus;
}
@end

@implementation HomeViewController
@synthesize _homeViewController,_navigationController_Login,btnFacebook;
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoginDone=NO;
    if(  [AppSingleton sharedInstance].isUserLoggedIn==YES)
    {
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
        [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
        [AppSingleton sharedInstance].isUserLoggedIn=NO;
        [self.tabBarController.tabBar setHidden:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
        
    previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;

    
    [self toggleHiddenState:YES];
   // self.lblLoginStatus.text = @"";
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
    [self fetchedMasterData];
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
-(void)changeFrameAndBackgroundImg
{
    
//  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
  //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    for (id loginObject in btnFacebook.subviews)
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
    
    // Check
    if(isFirstLoginDone) {
        // Execute code I want to run just once
        NSLog(@"fetched");
        return;
    }
    isFirstLoginDone=YES;
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

-(void)fetchedMasterData{
    
    
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] getMasterData:^(BOOL success) {
        //Hide Indicator
        [appDelegate hideSpinner];
      
    } failure:^(NSError *error) {
        //Hide Indicator
        [appDelegate hideSpinner];
        NSLog(@"failure JsonData %@",[error description]);
    }];
    // if user valid then navigate to main screen.
    
    //    self.profilePicture.profileID = user.id;
    //    self.lblUsername.text = user.name;
    //    self.lblEmail.text = [user objectForKey:@"email"];
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
    
    
//    SubmitAssignmentViewController *loginViewController= [[SubmitAssignmentViewController alloc]initWithNibName:@"SubmitAssignmentViewController" bundle:nil];
//    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)btnRegisterClick:(id)sender {
    RegisterationViewController *viewController= [[RegisterationViewController alloc]initWithNibName:@"RegisterationViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];

}
-(void)ShowCrashLogAlert{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mazda Crash Log Agreement" message:@"Crash Log" delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Agree", nil];
    //    alertView.tag = 6;
    //    [alertView show];
    //    [alertView release];
    //    alertView = nil;
    //    return;
    
    
//    [Utilities showWaitingSpinner:self isShow:YES];
//   	[[INTNetworkManager getInstance] makeJsonRequestWithMethod:kCrashLogMessageURL delegate:self requestType:kRequestTypeCrashWarningMessage requestMethod:kRequestMethodGet];
}
-(void)HandleCrash{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error = NULL;
    
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport]){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if ([userDefault boolForKey:@"sendcrashlog"])
            [self SendCrashLogToServer];
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"There was a problem with the application. The log was sent to Mazda for further investigation." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"View", @"Send", nil];
        //        alertView.tag = 4;
        //        [alertView show];
        //        [alertView release];
        //        alertView = nil;
        
    }
    
    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError: &error])
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
}

#pragma mark - PLCrashReporter

//
// Called to handle a pending crash report.
//
- (NSString *) handleCrashReport {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    NSString *humanReadable = nil;
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError: &error];
    
    /*NSString* newStr = [[NSString alloc] initWithBytes:[crashData bytes] length:[crashData length] encoding:NSStringEncodingConversionAllowLossy];
     NSLog(@"%@", newStr);*/
    
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
        [self CleanCrashReport];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_crashesDir = [NSString stringWithFormat:@"%@", [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/crashes/"]];
    NSFileManager *_fileManager = [[NSFileManager alloc] init];
    if (![_fileManager fileExistsAtPath:_crashesDir]) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject: [NSNumber numberWithUnsignedLong: 0755] forKey: NSFilePosixPermissions];
        NSError *theError = NULL;
        
        [_fileManager createDirectoryAtPath:_crashesDir withIntermediateDirectories: YES attributes: attributes error: &theError];
    }
    
    
    // We could send the report from here, but we'll just print out
    // some debugging info instead
    PLCrashReport *report = [[PLCrashReport alloc] initWithData: crashData error: &error];
    
    humanReadable = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
    NSLog(@"Report: %@", humanReadable);
    
    
    
    // Try loading the crash report
    //crashData = [[NSData alloc] initWithData:[crashReporter loadPendingCrashReportDataAndReturnError: &error]];
    
    NSString *cacheFilename = [NSString stringWithFormat: @"%.0f.crash", [NSDate timeIntervalSinceReferenceDate]];
    
    if (crashData == nil) {
        NSLog(@"Could not load crash report: %@", error);
    } else {
        //[self RequestWSWithUrl:@"" requestType:kRequestTypeCrashedData withDelegate:self withCrashData:humanReadable];
        //        [INTNetworkManager getInstance].postString = [NSString stringWithFormat:@"crashdata=%@", humanReadable];
        //        [Utilities showWaitingSpinner:self isShow:YES];
        //        [[INTNetworkManager getInstance] makeJsonRequestWithMethod:kCrashRepoterUrl delegate:self requestType:kRequestTypeCrashedData requestMethod:kRequestMethodPost];
        NSString *myString = [[NSString alloc] initWithData:crashData encoding:NSUTF32LittleEndianStringEncoding];
        
        NSLog(@"Sending Data: %@", crashData);
        NSLog(@"Sending Data: \n %@", myString);
        
        [crashData writeToFile:[_crashesDir stringByAppendingPathComponent: cacheFilename] atomically:YES];
    }
    if (report == nil) {
        NSLog(@"Could not parse crash report");
        [self CleanCrashReport];
    }
    
    NSLog(@"Crashed on %@\n %@", report.systemInfo.timestamp, [_crashesDir stringByAppendingPathComponent: cacheFilename]);
    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name,
          report.signalInfo.code, report.signalInfo.address);
    
    
    if ([_fileManager fileExistsAtPath:[_crashesDir stringByAppendingPathComponent: cacheFilename]]) {
        NSLog(@"YES");
    }
    
    return humanReadable;
}

-(void)CleanCrashReport{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    [crashReporter purgePendingCrashReport];
}

-(void)SendCrashLogToServer{
    NSString *strHumanReadableCrashLog = [self handleCrashReport];
//    NSString *deviceName = [[UIDevice currentDevice] machine];
//    NSLog(@"%@", deviceName);
//    [INTNetworkManager getInstance].postString = [NSString stringWithFormat:@"crashdata=%@&devicetype=IPHONE&userid=%@&guid=%@&devicemodel=%@", strHumanReadableCrashLog, @"", [NPUserData sharedNPUserData].guid, deviceName];
//    NSLog(@"Sending >>>>>>>>> %@", [INTNetworkManager getInstance].postString);
//    [Utilities showWaitingSpinner:self isShow:YES];
//    [[INTNetworkManager getInstance] makeJsonRequestWithMethod:kCrashRepoterUrl delegate:self requestType:kRequestTypeCrashedData requestMethod:kRequestMethodPost];
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
