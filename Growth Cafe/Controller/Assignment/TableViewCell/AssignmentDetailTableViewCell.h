//
//  AssignmentDetailTableViewCell.h
//  Growth Cafe
//
//  Created by Mayank on 12/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnAssignmentStatus;
@property (strong, nonatomic) IBOutlet UIImageView *imgResource;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignmentTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignementDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnExpend;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UILabel *lblCourse;

@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UILabel *lblUploadedDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDateAssignment;

@end
