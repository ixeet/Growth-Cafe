//
//  SettingTableViewCell.h
//  Growth Cafe
//
//  Created by Mayank on 01/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell
{}
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnSelected;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;

@end
