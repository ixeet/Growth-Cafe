//
//  ModuleDetailViewController.h
//  sLMS
//
//  Created by Mayank on 20/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ViewController.h"
#import "Courses.h"
#import "Assignment.h"
#import "Comments.h"
#import "ScrollViewContainer.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomProfileView.h"
@interface ModuleDetailViewController : ViewController<UIScrollViewDelegate>{
IBOutlet UITableView *tblViewContent;

}
@property (strong, nonatomic) IBOutlet UIView *cmtview;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdates;
@property (strong, nonatomic) IBOutlet UIButton *btnAssignment;
@property (strong, nonatomic) IBOutlet UIButton *btnCourses;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnNotification;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@property (strong, nonatomic)  Courses *selectedCourse;
@property (strong, nonatomic)  Module *selectedModule;
@property (assign , nonatomic)  NSInteger  step;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet ScrollViewContainer *scollViewContainer;
@property (strong, nonatomic) IBOutlet UITextView *txtViewCMT;
@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic)  CustomProfileView *objCustom;
//@property (strong, nonatomic)  NSDictionary *dicModuleDetail;
@property (strong, nonatomic)  NSString *feedId;
- (IBAction)btnBackClicked:(id)sender;

//- (IBAction)btnAssignmentClick:(id)sender;
//- (IBAction)btnCourseClick:(id)sender;
//- (IBAction)btnNotificationClick:(id)sender;
//- (IBAction)btnUpdateClick:(id)sender;
//- (IBAction)btnMoreClick:(id)sender;
- (IBAction)btnCommentDone:(id)sender;
- (IBAction)btnCommentCancle:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
