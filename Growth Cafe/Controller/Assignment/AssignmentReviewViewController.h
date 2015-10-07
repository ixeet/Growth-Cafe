//
//  AssignmentReviewViewController.h
//  Growth Cafe
//
//  Created by Mayank on 24/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"

#import <MediaPlayer/MediaPlayer.h>
@interface AssignmentReviewViewController : UIViewController
{
    IBOutlet UITableView *tableViewAssignmentrating;
}
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic)  Assignment *selectedAssignment;
- (IBAction)btnSubmitClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;



@property (strong, nonatomic) IBOutlet UIPickerView *mDataPickerView;
@property (strong, nonatomic) IBOutlet UIView *mViewAccountTypePicker;
- (IBAction)mBtnCancelPicker:(id)sender ;
- (IBAction)mBtnDonePicker:(id)sender ;
@end
