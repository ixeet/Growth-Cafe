//
//  VedioViewController.h
//  Growth Cafe
//
//  Created by Mayank on 03/11/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VedioViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *videoView;
@property  (strong, nonatomic) NSString *streamURL;
- (IBAction)btnClose:(id)sender;

@end
