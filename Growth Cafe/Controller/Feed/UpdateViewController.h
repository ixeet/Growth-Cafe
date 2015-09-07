//
//  FeedViewController.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomProfileView.h"

@interface UpdateViewController : UIViewController
{
    UIView * footerView;
   }
@property (assign, nonatomic)   BOOL isLoading;
@property (strong, nonatomic) IBOutlet UIView *cmtview;


@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@property (strong, nonatomic) IBOutlet UITableView *tblViewContent;
@property (assign , nonatomic)  NSInteger  step;
@property (strong, nonatomic) IBOutlet UITextView *txtViewCMT;
@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic)  CustomProfileView *objCustom;

@property (assign, nonatomic)  NSInteger totalRecord;
@property (assign, nonatomic)  NSInteger pendingRecord;

@property (assign, nonatomic)  NSInteger offsetRecord;
- (IBAction)btnCommentDone:(id)sender;
- (IBAction)btnCommentCancle:(id)sender;
- (IBAction)btnProfileClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
