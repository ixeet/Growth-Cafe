//
//  ContentCellTableViewCell.h
//  sLMS
//
//  Created by Mayank on 24/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgContent;
@property (strong, nonatomic) IBOutlet UILabel *lblAutherName;
@property (strong, nonatomic) IBOutlet UILabel *lblStartedon;
@property (strong, nonatomic) IBOutlet UILabel *lblCompletedon;
@property (strong, nonatomic) IBOutlet UILabel *lblNextTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnPlay;


@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@end
