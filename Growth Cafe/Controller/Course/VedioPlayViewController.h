//
//  VedioPlayViewController.h
//  sLMS
//
//  Created by Mayank on 04/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface VedioPlayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webview;
- (IBAction)videoPlayClick:(id)sender;
@property (strong, nonatomic) IBOutlet NSString *filePath;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (assign, nonatomic) BOOL allowRotation;
@end
