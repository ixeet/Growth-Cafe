//
//  UpdateDetailViewController.h
//  Growth Cafe
//
//  Created by Mayank on 02/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomProfileView.h"
#import "Update.h"
@interface UpdateDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *cmtview;


@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@property (strong, nonatomic) IBOutlet UITableView *tblViewContent;
@property (assign , nonatomic)  NSInteger  step;
@property (strong, nonatomic) IBOutlet UITextView *txtViewCMT;
@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic)  CustomProfileView *objCustom;
@property (strong, nonatomic)  Update *objUpdate;
- (IBAction)btnCommentDone:(id)sender;
- (IBAction)btnCommentCancle:(id)sender;
- (IBAction)btnProfileClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end
