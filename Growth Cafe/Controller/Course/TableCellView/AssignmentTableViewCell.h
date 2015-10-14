//
//  AssignmentTableViewCell.h
//  sLMS
//
//  Created by Mayank on 24/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgContentURL;
@property (strong, nonatomic) IBOutlet UILabel *lblContentName;
@property (strong, nonatomic) IBOutlet UILabel *lblContentby;
@property (strong, nonatomic) IBOutlet UILabel *lblSubmittedDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgDevider;
@property (strong, nonatomic) IBOutlet UILabel *lblAssignment;
@property (strong, nonatomic) IBOutlet UIButton *btnMore;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UIImageView *imgHalfDevide;

@end
