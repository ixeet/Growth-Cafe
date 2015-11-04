//
//  VedioViewController.m
//  Growth Cafe
//
//  Created by Mayank on 03/11/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "VedioViewController.h"

@interface VedioViewController ()

@end

@implementation VedioViewController
@synthesize streamURL;
- (void)viewDidLoad {
    [super viewDidLoad];
    [appDelegate self].allowRotation=YES;
    [self embedYouTube:streamURL frame:self.view.frame];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [appDelegate self].allowRotation=NO;
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
 //   NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
//    if(self.videoView == nil) {
//        self.videoView = [[UIWebView alloc] initWithFrame:frame];
//        [self.view addSubview:videoView];
//    }
    // [videoView  baseURL:nil];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: url] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 1000.0];
    [self.videoView loadRequest: request];
   // videoView.delegate=self;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
- (IBAction)btnClose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
