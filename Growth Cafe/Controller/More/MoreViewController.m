//
//  MoreViewController.m
//  sLMS
//
//  Created by Mayank on 27/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "MoreViewController.h"
#import "SettingViewController.h"
#import "AFHTTPRequestOperationManager.h"


@interface MoreViewController ()
{
    
AFNetworkReachabilityStatus previousStatus;
    
}
@end

@implementation MoreViewController
@synthesize lblName,imgUser,btnInstructions,btnSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view from its nib.
}



- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
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


-(void)viewWillAppear:(BOOL)animated
{
       
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(status==AFNetworkReachabilityStatusNotReachable)
        {   previousStatus=status;
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        }else{
            previousStatus=status;
            [self showNetworkStatus:REESTABLISH_INTERNET_MSG newVisibility:YES];
            [self setUserProfile];
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



- (IBAction)btnInstructionsClick:(id)sender {
}

- (IBAction)btnSettingClick:(id)sender {
    SettingViewController *viewSetting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:viewSetting animated:YES];
}
-(void)setUserProfile {
    // UserDetails *user=[AppGlobal readUserDetail];
    UserDetails *user=[AppSingleton sharedInstance].userDetail;
    
    
    lblName.text=[NSString stringWithFormat:@"%@ %@",user.userFirstName,user.userLastName];
    if(user.userImage!=nil){
        
        //check image available at local
        //get image name from URL
        if([AppGlobal checkImageAvailableAtLocal:user.userImage])
        {
            user.userImageData=[AppGlobal getImageAvailableAtLocal:user.userImage];
            UIImage *img=[UIImage imageWithData:user.userImageData];
            [imgUser setImage:img];
            imgUser.layer.cornerRadius = imgUser.frame.size.width/2;
            imgUser.clipsToBounds = YES;
            NSLog(@"%@",@"yes");
        }else{
            NSURL *imageURL = [NSURL URLWithString:user.userImage];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                user.userImageData  = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *img=[UIImage imageWithData:user.userImageData];
                    [AppGlobal setImageAvailableAtLocal:user.userImage AndImageData:user.userImageData];
                    if(img!=nil)
                    {
                        [imgUser setImage:img];
                        imgUser.layer.cornerRadius = imgUser.frame.size.width / 2;
                        imgUser.clipsToBounds = YES;
                        
                        
                    }
                });
            });
        }
        
    }
    
    [[imgUser layer] setBorderWidth:3.0f];
    [[imgUser layer] setBorderColor:[UIColor colorWithRed:186.0/255.0 green:0.0/255.0 blue:50.0/255.0 alpha:1].CGColor];
}
@end
