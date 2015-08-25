//
//  CustomContentView.h
//  sLMS
//
//  Created by Mayank on 22/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomContentView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *imgContent;
@property (strong, nonatomic) IBOutlet UILabel *lblAutherName;
@property (strong, nonatomic) IBOutlet UILabel *lblStartedon;
@property (strong, nonatomic) IBOutlet UILabel *lblCompletedon;

@property (strong, nonatomic) IBOutlet UILabel *lblCmtBy;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UIButton *btnCmtBy;

@property (strong, nonatomic) IBOutlet UILabel *txtCmtView;

@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnShare;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@property (strong, nonatomic) IBOutlet UIButton *btnLikeCMT;
//@property (strong, nonatomic) IBOutlet UIButton *btnShareCMT;
@property (strong, nonatomic) IBOutlet UIButton *btnCommentCMT;
@end
