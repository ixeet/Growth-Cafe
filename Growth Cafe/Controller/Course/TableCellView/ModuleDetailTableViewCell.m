//
//  ModuleDetailTableViewCell.m
//  sLMS
//
//  Created by Mayank on 21/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ModuleDetailTableViewCell.h"

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        10.0f

@interface ModuleDetailTableViewCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation ModuleDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        // Note: if the constraints you add below require a larger cell size than the current size (which is likely to be the default size {320, 44}), you'll get an exception.
        // As a fix, you can temporarily increase the size of the cell's contentView so that this does not occur using code similar to the line below.
        //      See here for further discussion: https://github.com/Alex311/TableCellWithAutoLayout/commit/bde387b27e33605eeac3465475d2f2ff9775f163#commitcomment-4633188
        // self.contentView.bounds = CGRectMake(0.0f, 0.0f, 99999.0f, 99999.0f);
        
      
//        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
//        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
//        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
//        
        // This is the constraint that connects the title and body labels. It is a "greater than or equal" inequality so that if the row height is
        // slightly larger than what is actually required to fit the cell's subviews, the extra space will go here. (This is the case on iOS 7
        // where the cell separator is only 0.5 points tall, but in the tableView:heightForRowAtIndexPath: method of the view controller, we add
        // a full 1.0 point in extra height to account for it, which results in 0.5 points extra space in the cell.)
//        // See https://github.com/smileyborg/TableViewCellWithAutoLayout/issues/3 for more info.
//        [self.bodyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
//        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
//            [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
//        }];
//        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
//            [self.viewContent autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
//        }];
//        [self.viewContent autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
//        [self.viewContent autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
//        [self.viewContent autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
   
}

@end
