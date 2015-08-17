//
//  CustomContentView.m
//  sLMS
//
//  Created by Mayank on 22/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "CustomContentView.h"

@implementation CustomContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomContentView" owner:self options:nil];
        self.bounds =self.view.bounds;
        [self addSubview:self.view];
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomContentView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}


@end
