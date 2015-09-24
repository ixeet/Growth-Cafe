//
//  AssignmentRatingTableViewCell.h
//  Growth Cafe
//
//  Created by Mayank on 24/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentRatingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblAssignParam;
@property (strong, nonatomic) IBOutlet UIButton *btnParamValue;
@property (strong, nonatomic) IBOutlet UILabel *lblDots;

@end
