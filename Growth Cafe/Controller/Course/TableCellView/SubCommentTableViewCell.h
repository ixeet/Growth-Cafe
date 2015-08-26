//
//  SubCommentTableViewCell.h
//  Growth Cafe
//
//  Created by Mayank on 15/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnCommentedBy;
@property (strong, nonatomic) IBOutlet UILabel *lblCmtBy;

@property (strong, nonatomic) IBOutlet UILabel *lblCmtText;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;

@property (strong, nonatomic) IBOutlet UIImageView *imgHalfDevider;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider;
@property (strong, nonatomic) IBOutlet UILabel *lblRelatedVideo;
@end
