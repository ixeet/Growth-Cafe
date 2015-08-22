//
//  VedioPlayViewController.m
//  sLMS
//
//  Created by Mayank on 04/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "VedioPlayViewController.h"

@interface VedioPlayViewController ()

@end

@implementation VedioPlayViewController
@synthesize webview,filePath;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSURL*  url = [NSURL fileURLWithPath:filePath];
//    NSURLRequest*   request = [NSURLRequest requestWithURL:url];
//    [webview loadRequest:request];
//    MPMoviePlayerController *videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
//    [videoPlayer setControlStyle:MPMovieControlStyleNone];
//    
//    videoPlayer.view.frame = CGRectMake(0, 0, 150, 150);
//    
//    [self.view addSubview:videoPlayer.view];
    
//    NSString *strVedio =[NSString stringWithFormat:@"<video controls> <source src=\"%@\"> </video>",filePath];
//    NSString *path = [[NSBundle mainBundle] pathForResource:filePath ofType:@"mp4"];
//    [webview loadHTMLString:strVedio baseURL:[NSURL fileURLWithPath:path]];
    
//    NSString *embedHTML = @"\
//    <html><head>\
//    <style type=\"text/css\">\
//    body {\
//    background-color: transparent; color: white; }\
//</style>\
//</head><body style=\"margin:0\">\
//<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
//width=\"%0.0f\" height=\"%0.0f\"></embed>\
//</body></html>";
//
//NSString *strHtml = [NSString stringWithFormat:embedHTML, filePath, 400,600];//set width and height which you want
//
//[webview loadHTMLString:strHtml baseURL:nil];
//    [self.view addSubview:webview];
//    MPMoviePlayerController *videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
//    [videoPlayer setControlStyle:MPMovieControlStyleNone];
//    
//    videoPlayer.view.frame = CGRectMake(0, 0, 150, 150);
//    videoPlayer.fullscreen=YES;
//    [self.view addSubview:videoPlayer.view];
//    NSURL *url=[[NSURL alloc] initWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];
//    
//    MPMoviePlayerController *moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:url];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
//    
//    moviePlayer.controlStyle=MPMovieControlStyleDefault;
//    moviePlayer.shouldAutoplay=YES;
//    [self.view addSubview:moviePlayer.view];
//    [moviePlayer setFullscreen:YES animated:YES];
   // [self embedYouTube:filePath frame:CGRectMake(0, 50, 500, 650)];
//    MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlaybackComplete:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:nil];
//    
//    mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//    
//    [self presentMoviePlayerViewControllerAnimated:mpvc];
    
    
//    
//    NSURL *url = [NSURL URLWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];
//    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    [moviePlayer setControlStyle:MPMovieControlStyleDefault];
//    moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
//    CGRect frame;
//    if(self.interfaceOrientation ==UIInterfaceOrientationPortrait)
//        frame = CGRectMake(20, 69, 280, 170);
//    else if(self.interfaceOrientation ==UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation ==UIInterfaceOrientationLandscapeRight)
//        frame = CGRectMake(20, 61, 210, 170);
//    [moviePlayer.view setFrame:frame];  // player's frame must match parent's
//    [self.view addSubview: moviePlayer.view];
//    [self.view bringSubviewToFront:moviePlayer.view];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlaybackComplete:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:moviePlayer];
//    moviePlayer.fullscreen=YES;
//    [moviePlayer prepareToPlay];
//    [moviePlayer play];
   // [mpvc release];
//    NSURL *url = [NSURL URLWithString:@"http://191.239.57.54:8080/resources/video/aa.mp4"];
//    _moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:url];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlaybackComplete:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:_moviePlayer];
//    //    [[NSNotificationCenter defaultCenter] addObserver:self
//    //                                             selector:@selector(moviePlayerLoadStateChanged:)
//    //                                                 name:MPMoviePlayerLoadStateDidChangeNotification
//    //                                               object:_moviePlayer];
//    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
//    _moviePlayer.shouldAutoplay = YES;
//    [_moviePlayer prepareToPlay];
//    [self.view addSubview:_moviePlayer.view];
//    [_moviePlayer setFullscreen:YES animated:YES];
//    [_moviePlayer stop];
//    [_moviePlayer play];
   
}
- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    [appDelegate self].allowRotation = YES;
}
- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [appDelegate self].allowRotation = NO;
    MPMoviePlayerController *moviePlayerController = [notification object];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
//                                                  object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:moviePlayerController];
    [self.moviePlayer stop];
    //[self.moviePlayer stop];
     [moviePlayerController.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerWillExitFullscreenNotification
//                                                  object:moviePlayerController];
    [moviePlayerController.view removeFromSuperview];
   // [self.navigationController popViewControllerAnimated:YES];
}
//- (void)moviePlayerWillExitFullscreenNotification:(NSNotification *)notification
//{
//    MPMoviePlayerController *moviePlayerController = [notification object];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
//                                                  object:moviePlayerController];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerWillExitFullscreenNotification
//                                                  object:moviePlayerController];
//    [moviePlayerController.view removeFromSuperview];
//     [self.navigationController popViewControllerAnimated:YES];
//}
- (void)moviePlaybackSate:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
    
}
//- (void)moviePlayerLoadStateChanged:(NSNotification *)notification{
//    NSLog(@"State changed to: %d\n", self.moviePlayer.loadState);
//    if(self.moviePlayer.loadState == MPMovieLoadStatePlayable){
//        //if load state is ready to play
//        [self.view addSubview:[self.moviePlayer view]];
//        [self.moviePlayer setFullscreen:YES];
//        [self.moviePlayer play];//play the video
//    }
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
        background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    UIWebView *videoView;
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
           [videoView loadHTMLString:html baseURL:nil];
        [self.view addSubview:videoView];
        [self.view bringSubviewToFront:videoView];

    }
 
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)videoPlayClick:(id)sender {
//    NSLog(@"You are in: %s", __FUNCTION__);
//    NSURL *url = [NSURL URLWithString:@"http://191.239.57.54:8080/resources/video/aa.mp4"];
//    MPMoviePlayerViewController *playerViewController =
//    [[MPMoviePlayerViewController alloc] initWithContentURL:url];
//   playerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//     //playerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
//    playerViewController.moviePlayer.fullscreen=YES;

    
   // [self presentMoviePlayerViewControllerAnimated:playerViewController];
    
    
     NSURL *url = [NSURL URLWithString:@"http://191.239.57.54:8080/resources/video/aa.mp4"];
    _moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackExitFromFullScreen:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:_moviePlayer];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayerLoadStateChanged:)
//                                                 name:MPMoviePlayerLoadStateDidChangeNotification
//                                               object:_moviePlayer];
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [_moviePlayer prepareToPlay];
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
    [_moviePlayer stop];
    [_moviePlayer play];
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

}
//- (void)moviePlayerWillEnterFullscreenNotification:(NSNotification *)notification
//{
//    dispatch_async(dispatch_get_main_queue(), ^
//                   {
//                       self.allowRotation = YES;
//                   });
//}



//- (void)moviePlayerWillExitFullscreenNotification:(NSNotification *)notification
//{
//    self.allowRotation = NO;
//    [self.moviePlayerController setControlStyle:MPMovieControlStyleNone];
//    
//    dispatch_async(dispatch_get_main_queue(), ^
//                   {
//                       
//                       //Managing GUI in pause condition
//                       if (self.currentContent.contentType == TypeVideo && self.moviePlayerController.playbackState == MPMoviePlaybackStatePaused)
//                       {
//                           [self.moviePlayerController pause];
//                           if (self.playButton.selected)
//                               self.playButton.selected = NO;
//                       }
//                       self.view.transform = CGAffineTransformMakeRotation(0);
//                       [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//                       self.view.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//                   });
//}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
