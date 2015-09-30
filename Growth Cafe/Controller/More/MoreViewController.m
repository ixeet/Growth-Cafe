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
@synthesize lblName,imgUser,btnInstructions,btnSetting;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUserProfile];
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


- (IBAction)btnInstructionsClick:(id)sender {
}

- (IBAction)btnSettingClick:(id)sender {
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
            imgUser.layer.cornerRadius = imgUser.frame.size.width/6;
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
      
    
}
@end
