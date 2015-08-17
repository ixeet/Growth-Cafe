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

@property (strong, nonatomic) IBOutlet UIView *cmtview;


@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@property (strong, nonatomic) IBOutlet UITableView *tblViewContent;
@property (assign , nonatomic)  NSInteger  step;
@property (strong, nonatomic) IBOutlet UITextView *txtViewCMT;
@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic)  CustomProfileView *objCustom;
- (IBAction)btnCommentDone:(id)sender;
- (IBAction)btnCommentCancle:(id)sender;
- (IBAction)btnProfileClick:(id)sender;
@end
