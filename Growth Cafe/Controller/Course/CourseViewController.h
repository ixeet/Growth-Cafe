//
//  CourseViewController.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProfileView.h"
@interface CourseViewController : UIViewController
{
    IBOutlet UITableView *tableViewCourse;
}
@property (strong, nonatomic) IBOutlet UIButton *btnUpdates;
@property (strong, nonatomic) IBOutlet UIButton *btnAssignment;
@property (strong, nonatomic) IBOutlet UIButton *btnCourses;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnNotification;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@property (strong, nonatomic) CustomProfileView *objCustom;
@property (strong, nonatomic) NSMutableArray *coursesList;
@property (assign, nonatomic) BOOL comeFromUpdate;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnMenuClick:(id)sender;

//- (IBAction)btnAssignmentClick:(id)sender;
//- (IBAction)btnCourseClick:(id)sender;
//- (IBAction)btnNotificationClick:(id)sender;
//- (IBAction)btnUpdateClick:(id)sender;
//- (IBAction)btnMoreClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@end
