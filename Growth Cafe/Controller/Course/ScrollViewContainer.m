//
//  ScrollViewContainer.h
//  sLMS
//
//  Created by Mayank on 22/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//
#import "ScrollViewContainer.h"

@implementation ScrollViewContainer

@synthesize scrollView = _scrollView;

#pragma mark -

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollView;
    }
    return view;
}

@end
