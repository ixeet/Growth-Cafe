//
//  UpdateTableViewCell.h
//  sLMS
//
//  Created by Mayank on 06/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnUpdatedBy;
@property (strong, nonatomic) IBOutlet UITextView *txtView;
@property (strong, nonatomic) IBOutlet UIImageView *imgResorces;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UILabel *txtviewDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UILabel *lblLikeAndCmtConut;

@property (strong, nonatomic) IBOutlet UIImageView *imgBelowLine1;
@property (strong, nonatomic) IBOutlet UIImageView *imgBelowLine8;

@end
