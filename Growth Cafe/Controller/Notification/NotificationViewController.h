//
//  NotificationViewController.h
//  sLMS
//
//  Created by Mayank on 06/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import "CustomProfileView.h"

@interface NotificationViewController : UIViewController
{
UIView * footerView;
}
@property (assign, nonatomic)   BOOL isLoading;


@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;

@property (strong, nonatomic) IBOutlet UITableView *tblViewContent;
@property (assign , nonatomic)  NSInteger  step;

@property (strong, nonatomic)  CustomProfileView *objCustom;

@property (assign, nonatomic)  NSInteger totalRecord;
@property (assign, nonatomic)  NSInteger pendingRecord;

@property (assign, nonatomic)  NSInteger offsetRecord;

- (IBAction)btnProfileClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
