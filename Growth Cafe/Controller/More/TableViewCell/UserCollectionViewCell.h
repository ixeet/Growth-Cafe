//
//  UserCollectionViewCell.h
//  Growth Cafe
//
//  Created by Mayank on 03/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblusername;
@property (strong, nonatomic) IBOutlet UILabel *lblstatus;
@property (strong, nonatomic) IBOutlet UIImageView *imgview;
@property (strong, nonatomic) IBOutlet UIButton *btnUserImage;

@end
