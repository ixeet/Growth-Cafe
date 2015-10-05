//
//  FollowListViewController.m
//  Growth Cafe
//
//  Created by Mayank on 03/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "FollowListViewController.h"
#import "UserCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CVCell.h"
@interface FollowListViewController ()
{
    NSMutableArray *users;
      NSMutableArray *actionOnUsers;
}
@end

@implementation FollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    users=[[NSMutableArray alloc]init];
    actionOnUsers=[[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
      CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [flowLayout setItemSize:CGSizeMake(screenWidth/3-10, 140)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.colUserView setCollectionViewLayout:flowLayout];
    
    [self.colUserView registerClass:[CVCell class] forCellWithReuseIdentifier:@"CVCell"];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [self getUserFollowList];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getUserFollowList{
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    NSString *userId=[NSString stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId ];
    [[appDelegate _engine] getUserFollowList:userId success:^(NSMutableArray *userList) {
        users=userList;
        [self.colUserView reloadData];

        //Hide Indicator
        [appDelegate hideSpinner];
      
        
    }
                                failure:^(NSError *error) {
                                    //Hide Indicator
                                    [appDelegate hideSpinner];
                                    NSLog(@"failure Json Data %@",[error description]);
                                    [self settingError:error];
                                    
                                }];
    
}

-(void)setFollow{
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    NSString *userId=[NSString stringWithFormat:@"%@",[AppSingleton sharedInstance].userDetail.userId ];
   
    [[appDelegate _engine] setUnFollowUserList:userId AndUserList:actionOnUsers success:^(BOOL successValue) {
        
        
        
        //{"userid":"22","usersList":[{"userid":"1","isFollowUpAllowed":"0"},{"userid":"2","isFollowUpAllowed":"1"},{"userid":"3","isFollowUpAllowed":"0"}]}
        
        //Hide Indicator
        [appDelegate hideSpinner];
        
    }
                                failure:^(NSError *error) {
                                    //Hide Indicator
                                    [appDelegate hideSpinner];
                                    NSLog(@"failure Json Data %@",[error description]);
                                    [self settingError:error];
                                    
                                }];
    
}

-(void)settingError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDoneClick:(id)sender {
    [self setFollow];
}
#pragma mark -  uicoleection view data source


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return users.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CVCell";
   
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    UserDetails *userDetail=[users objectAtIndex:indexPath.row] ;
    
    userDetail.userImage=[AppSingleton   sharedInstance].userDetail.userImage;
    userDetail.userImageData=[AppSingleton   sharedInstance].userDetail.userImageData;
    if(userDetail.userImage!=nil){
        
        //check image available at local
        //get image name from URL
        if([AppGlobal checkImageAvailableAtLocal:userDetail.userImage])
        {
            userDetail.userImageData=[AppGlobal getImageAvailableAtLocal:userDetail.userImage];
        }
        
        if (userDetail.userImageData==nil) {
            NSURL *imageURL = [NSURL URLWithString:userDetail.userImage];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                userDetail.userImageData  = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *img=[UIImage imageWithData:userDetail.userImageData];
                    [AppGlobal setImageAvailableAtLocal:userDetail.userImage AndImageData:userDetail.userImageData];
                    if(img!=nil)
                    {
                        [cell.imgview setImage:img];
                        
                        [cell.imgview setBackgroundColor:[UIColor clearColor]];
                        cell.imgview.layer.cornerRadius = cell.imgview.frame.size.width/2;
                        cell.imgview.clipsToBounds = YES;
                    }
                });
            });
        }else{
            
            UIImage *img=[UIImage imageWithData:userDetail.userImageData];
            [cell.imgview setImage:img];
            
            [cell.imgview setBackgroundColor:[UIColor clearColor]];
            cell.imgview.layer.cornerRadius = cell.imgview.frame.size.width/2;
            cell.imgview.clipsToBounds = YES;
        }
    
    }
    if([userDetail.isFollowUpAllowed intValue]== 1)
    {
        [cell.lblStatus setHidden:YES];
        
        cell.imgview.backgroundColor = nil;
        
        [[cell.imgview layer] setBorderWidth:3.0f];
        [[cell.imgview layer] setBorderColor:[UIColor whiteColor].CGColor];
    }
    else{
        [cell.lblStatus setHidden:NO];
        cell.imgview.backgroundColor = nil;
        [[cell.imgview layer] setBorderWidth:5.0f];
        [[cell.imgview layer] setBorderColor:[UIColor colorWithRed:186.0/255.0 green:0.0/255.0 blue:50.0/255.0 alpha:1].CGColor];
    }
   // cell.backgroundColor=[UIColor redColor];
    
    cell.titleLabel.text=userDetail.username;
       return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserDetails *userDetail=[users objectAtIndex:indexPath.row] ;
    if([userDetail.isFollowUpAllowed intValue]== 1){
        
        userDetail.isFollowUpAllowed=[NSNumber numberWithInt:0];
        
    }
    else{
        userDetail.isFollowUpAllowed=[NSNumber numberWithInt:1];
    }
  if( [actionOnUsers containsObject:userDetail])
  {
      [actionOnUsers removeObject:userDetail];
  }
    [actionOnUsers addObject:userDetail];
    
 
    [self.colUserView reloadData];

}
@end
