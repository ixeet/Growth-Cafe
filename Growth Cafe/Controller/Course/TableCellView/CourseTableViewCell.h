//
//  CourseTableViewCell.h
//  sLMS
//
//  Created by Mayank on 16/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblCourseName;
@property (strong, nonatomic) IBOutlet UILabel *lblPercent;
@property (strong, nonatomic) IBOutlet UIProgressView *probarCourse;
@property (strong, nonatomic) IBOutlet UIImageView *imgAssessaryview;
@property (strong, nonatomic) IBOutlet UIButton *btnImg;

@end
