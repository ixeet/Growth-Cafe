//
//  CommentTableViewCell.h
//  sLMS
//
//  Created by Mayank on 24/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnCommentedBy;
@property (strong, nonatomic) IBOutlet UILabel *lblCmtBy;
@property (strong, nonatomic) IBOutlet UILabel *lblCmtText;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnCMT;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider;
@property (strong, nonatomic) IBOutlet UILabel *lblRelatedVideo;
@property (strong, nonatomic) IBOutlet UIImageView *imgHalfDevider;

@end
