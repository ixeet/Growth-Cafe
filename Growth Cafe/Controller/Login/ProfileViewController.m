//
//  ProfileViewController.m
//  sLMS
//
//  Created by Mayank on 30/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize lblClass,lblEmail,lblFirstName,lblLastName,lblHomeRoom,lblSchoolAdminEmail,lblSchoolName,user,imgUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    // self.lblLoginStatus.text = @"";
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self setUserProfile];
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
-(void)setUserProfile {
   // UserDetails *user=[AppGlobal readUserDetail];
    
    
    lblFirstName.text=user.userFirstName;
    lblLastName.text=user.userLastName;
    lblEmail.text=user.userEmail;
    lblSchoolName.text=user.schoolName;
    lblSchoolAdminEmail.text=user.adminEmailId;
    lblClass.text=user.className;
    lblHomeRoom.text=user.homeRoomName;
   
          if(user.userImage!=nil){
              if([AppGlobal checkImageAvailableAtLocal:user.userImage])
              {
                 user.userImageData=[AppGlobal getImageAvailableAtLocal:user.userImage];
              }
           if (user.userImageData==nil) {
                NSURL *imageURL = [NSURL URLWithString:user.userImage];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    user.userImageData  = [NSData dataWithContentsOfURL:imageURL];
                    [AppGlobal setImageAvailableAtLocal:user.userImage AndImageData:user.userImageData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        UIImage *img=[UIImage imageWithData:user.userImageData];
                        if(img!=nil)
                        {
                            [imgUser setImage:img];
                            
                            [imgUser setBackgroundColor:[UIColor clearColor]];
                        }
                    });
                });
            }else{
                UIImage *img=[UIImage imageWithData:user.userImageData];
                [imgUser setImage:img];
                
                [imgUser setBackgroundColor:[UIColor clearColor]];
            }
        }
    
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
