//
//  CourseTableViewCell.m
//  sLMS
//
//  Created by Mayank on 16/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "CourseTableViewCell.h"

@implementation CourseTableViewCell
@synthesize imgAssessaryview,btnImg;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
 //   [imgAssessaryview setImage:[UIImage imageNamed:@"icn_arrow-expand.png"]];
    // Configure the view for the selected state    1   ``
    [btnImg setSelected:selected];
//    if(selected){
//       [btnImg setImage:[UIImage imageNamed:@"icn_arrow-expand.png"] forState:UIControlStateNormal]; //
//    }else {
//         [btnImg setImage:[UIImage imageNamed:@"icn_arrow.png"] forState:UIControlStateNormal];
//    }
}
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated{
    [super setSelected:NO animated:animated];
    [btnImg setSelected:NO];
}

@end
