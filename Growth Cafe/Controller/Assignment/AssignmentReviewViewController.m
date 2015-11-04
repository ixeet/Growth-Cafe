//
//  AssignmentReviewViewController.m
//  Growth Cafe
//
//  Created by Mayank on 24/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "AssignmentReviewViewController.h"
#import "AssignmentDetailTableViewCell.h"
#import "AssignmentRatingTableViewCell.h"
#import "VedioViewController.h"
#import "AFHTTPRequestOperationManager.h"
@interface AssignmentReviewViewController ()
{
 
    ActionOn  actionOn;
    UIWebView *videoView;
    AFNetworkReachabilityStatus previousStatus;
    CGFloat screenHeight;
    CGFloat screenWidth;
    int mIntRow;
    int selectParam;

    NSMutableDictionary *dicSelectedParam;
}
@end

@implementation AssignmentReviewViewController
@synthesize btnSubmit,selectedAssignment,mViewAccountTypePicker,mDataPickerView,moviePlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillEnterFullscreenNotification:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerWillExitFullscreenNotification:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [AppSingleton sharedInstance].comeFromChild=YES;
    [super viewWillAppear:animated];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(status==AFNetworkReachabilityStatusNotReachable)
        {   previousStatus=status;
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        }else{
            previousStatus=status;
            [self showNetworkStatus:REESTABLISH_INTERNET_MSG newVisibility:YES];
            
        }
        //       else  if(status!=AFNetworkReachabilityStatusNotReachable)
        //       {
        //           previousStatus=status;
        //           [self showNetworkStatus:@""];
        //
        //       }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // [super viewWillAppear:animated];
    /* Listen for keyboard */
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    dicSelectedParam=[[NSMutableDictionary alloc]init];
    
    if([selectedAssignment.assignmentStatus isEqualToString:@"3"])
    {
        btnSubmit.hidden=YES;
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

- (IBAction)btnSubmitClick:(id)sender {
    // check validate for all value for each param
    
    for (AssignmentRating *rating in selectedAssignment.ratingParam) {
        if([dicSelectedParam objectForKey:rating.ratingParam]==nil)
         {
             // show alert for select the rating for each param
             NSDictionary *temp= rating.ratingParam;
            
             [AppGlobal showAlertWithMessage:key_Select_Massage( [temp objectForKey:@"value"]) title:@""];
             return;
         }
    }
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] setAssignmentRating:dicSelectedParam AndParam:selectedAssignment.ratingParam AndAssignmentResourceTxnId:selectedAssignment.assignmentResourceTxnId success:^(BOOL logoutValue) {
     [appDelegate hideSpinner];
        [AppSingleton sharedInstance].comeFromChild=NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
                                    failure:^(NSError *error) {
                                        //Hide Indicator
                                        [appDelegate hideSpinner];
                                        NSLog(@"failure JsonData %@",[error description]);
                                        [self loginError:error];
                                        //                                         [self loginViewShowingLoggedOutUser:loginView];
                                        
                                    }];
    

}
-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated];
//    [self.tableView reloadData];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"You are in: %s", __FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"You are in: %s", __FUNCTION__);

    NSLog(@"no of row: %ld",[selectedAssignment.ratingParam count]);
    return [selectedAssignment.ratingParam count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You are in: %s", __FUNCTION__);

    if(indexPath.row==0)
    {
    static NSString *identifier = @"AssignmentDetailTableViewCell";
    AssignmentDetailTableViewCell *cell = (AssignmentDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
        
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    Assignment *assignment=selectedAssignment;
    
    // create custom view for title
    cell.lblAssignmentTitle.text =assignment.assignmentName;
    
    //  cell.viewDetail.frame=CGRectMake(0, 0, x, 60);
    cell.btnExpend.hidden=YES;
   
  
    // [cell.btnSubmit setHidden:YES];
    
    // Set label text to attributed string
    NSString *str = [NSString stringWithFormat:@"%@ > %@" ,assignment.course.courseName,assignment.module.moduleName];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    // Set font, notice the range is for the whole string
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [assignment.course.courseName length])];
      [cell.lblCourse setAttributedText:attributedString];
    //    cell.lblCourse.text=assignment.course.courseName;
    //    cell.lblModule.text=assignment.module.moduleName;
    cell.btnSubmit.tag =indexPath.row;
    CGRect imgFrame=cell.imgResource.frame;
    imgFrame=CGRectMake(imgFrame.origin.x, imgFrame.origin.y, imgFrame.size.width, 0);
    cell.imgResource.frame=imgFrame;
    NSDate * dueDate=[AppGlobal convertStringDateToNSDate:assignment.assignmentDueDate];
    if(dueDate!=nil){
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  dueDate]; // Get necessary date components
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
        cell.lblDateAssignment.text=[NSString stringWithFormat:@"%@ %ld",[monthName substringToIndex:3],(long)components.day];
    }
    //  cell.lblDateAssignment.text=assignment.assignmentSubmittedDate;
   
    if([assignment.assignmentStatus isEqualToString:@"1"])
    {
        NSDate *today10am =[NSDate date];
        
        if ([dueDate compare:today10am] == NSOrderedDescending)
        {
            // cell.btnAssignmentStatus.selected=YES;
            [cell.btnAssignmentStatus setImage:[UIImage imageNamed:@"icn_new-assignment.png"] forState:UIControlStateNormal];
            
            
            
            [cell.btnAssignmentStatus setBackgroundColor:[UIColor clearColor]];
//            [cell.btnAssignmentStatus  addTarget:self action:@selector(btnSubmitAssignmentClick:) forControlEvents:UIControlEventTouchUpInside];
            // lblDateAssignment.text
            
            
            // cell.lblDateAssignment.textColor =[UIColor blackColor];
        }else{
            
            //  cell.btnAssignmentStatus.selected=NO;
            [cell.btnAssignmentStatus setImage:[UIImage imageNamed:@"icn_pending-assignment.png"] forState:UIControlStateNormal];
//            [cell.btnAssignmentStatus  addTarget:self action:@selector(btnSubmitAssignmentClick:) forControlEvents:UIControlEventTouchUpInside];
            // cell.lblDateAssignment.text=assignment.assignmentSubmittedDate;
            // cell.lblDateAssignment.textColor =[UIColor b];
            
        }
        //        if(assignment.isExpend)
        //         // [cell.btnSubmit setHidden:NO];
        
    }
    
    else if([assignment.assignmentStatus isEqualToString:@"2"])
    {
        [cell.btnAssignmentStatus setImage:[UIImage imageNamed:@"icn_assignment-submitted.png"] forState:UIControlStateNormal];
        //  cell.lblDateAssignment.textColor =[UIColor blackColor];
        
        [cell.btnAssignmentStatus setBackgroundColor:[UIColor clearColor]];
        
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.attachedResource.uploadedDate];
        if(submittedDate!=nil){
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
            cell.lblUploadedDate.text=[NSString stringWithFormat:@"Submitted on %@ %ld by %@",[monthName substringToIndex:3],(long)components.day, assignment.assignmentSubmittedBy];
        }
    }
    else if([assignment.assignmentStatus isEqualToString:@"3"])
    {
        
        [cell.btnAssignmentStatus setImage:[UIImage imageNamed:@"icn_assignment-submitted.png"] forState:UIControlStateNormal];
        //  cell.lblDateAssignment.textColor =[UIColor blackColor];
        
        [cell.btnAssignmentStatus setBackgroundColor:[UIColor clearColor]];
       // cell.btnAssignmentStatus.highlighted =YES;
        //   cell.lblDateAssignment.textColor =[UIColor whiteColor];
        
        //   [cell.btnAssignmentStatus setBackgroundColor:[UIColor greenColor]];
//        if(assignment.isExpend)
//            [cell.lblUploadedDate setHidden:NO];
        
        NSDate * submittedDate=[AppGlobal convertStringDateToNSDate:assignment.attachedResource.uploadedDate];
        if(submittedDate!=nil){
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:  submittedDate]; // Get necessary date components
            
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            NSString *monthName = [[df monthSymbols] objectAtIndex:(components.month-1)];
            cell.lblUploadedDate.text=[NSString stringWithFormat:@"Submitted on %@ %ld by %@, Status Reviewed",[monthName substringToIndex:3],(long)components.day,assignment.assignmentSubmittedBy ];
        }
    }
    
        NSLayoutConstraint *backdropViewHeight = [NSLayoutConstraint constraintWithItem:cell.imgResource attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:cell.imgResource attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        //        NSLayoutConstraint *backdropViewCenterX = [NSLayoutConstraint constraintWithItem:cell.imgResource attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.imgResource.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        //        NSLayoutConstraint *backdropViewCenterY = [NSLayoutConstraint constraintWithItem:cell.imgResource   attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.imgResource.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        [cell.imgResource.superview addConstraints:@[ backdropViewHeight]];
        
        
        [cell.btnExpend setImage:[UIImage imageNamed:@"icn_arrow-expand.png"] forState:UIControlStateNormal];
        if(assignment.assignmentDesc!=nil)
        {
            
            cell.lblAssignementDetail.text=assignment.assignmentDesc;
            
            
            //            if(labelSize.height>39)
            
            [cell.lblAssignementDetail  setHidden:NO];
        }
         imgFrame=cell.imgResource.frame;
        
        if (assignment.attachedResource!=nil) {
            
            if(assignment.attachedResource.resourceImageUrl!=nil){
                cell.btnPlay.tag=indexPath.row;
                [cell.btnPlay setHidden:NO];
                [cell.imgResource setHidden:NO];
                [cell.btnPlay  addTarget:self action:@selector(btnPlayResourceClick:) forControlEvents:UIControlEventTouchUpInside];
                if([AppGlobal checkImageAvailableAtLocal:assignment.attachedResource.resourceImageUrl])
                {
                    assignment.attachedResource.resourceImageData=[AppGlobal getImageAvailableAtLocal:assignment.attachedResource.resourceImageUrl];
                }
                if (assignment.attachedResource.resourceImageData==nil) {
                    NSURL *imageURL = [NSURL URLWithString:assignment.attachedResource.resourceImageUrl];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        assignment.attachedResource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
                        [AppGlobal setImageAvailableAtLocal:assignment.attachedResource.resourceImageUrl AndImageData: assignment.attachedResource.resourceImageData];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update the UI
                            UIImage *img=[UIImage imageWithData:assignment.attachedResource.resourceImageData];
                            if(img!=nil)
                            {
                                [cell.imgResource setImage:img];
                                
                                [cell.imgResource setBackgroundColor:[UIColor clearColor]];
                                cell.imgResource.frame = imgFrame;
                            }
                        });
                    });
                }else{
                    UIImage *img=[UIImage imageWithData:assignment.attachedResource.resourceImageData];
                    
                    [cell.imgResource setImage:img];
                    
                    [cell.imgResource setBackgroundColor:[UIColor clearColor]];
                    cell.imgResource.frame = imgFrame;
                }
            }
        
        
        }         //set action for comment and like on resource
    
    return cell;
    }else {
        static NSString *identifier = @"AssignmentRatingTableViewCell";
        AssignmentRatingTableViewCell *cell = (AssignmentRatingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
            
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
            [cell setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        }
        AssignmentRating *rating=selectedAssignment.ratingParam[indexPath.row-1];
        if([AppSingleton sharedInstance].userDetail.userRole!=2)
        {
            
            cell.lblAssignParam.text=[[rating.ratingParam objectForKey:@"value" ] uppercaseString];
            [cell.btnParamValue setTitle:[rating.ratingParamValues[0] objectForKey:@"value" ]  forState:UIControlStateNormal];
            cell.lblDots.hidden=YES;
            
        }else{
            cell.lblAssignParam.text=[[rating.ratingParam objectForKey:@"value" ]  uppercaseString];
            cell.btnParamValue.tag  =indexPath.row-1;
            if([rating.ratingParamValues  count]==1)
            {
                NSLog(@"%@",[rating.ratingParamValues[0] objectForKey:@"value" ] );
                [cell.btnParamValue setTitle:[rating.ratingParamValues[0] objectForKey:@"value" ]  forState:UIControlStateNormal];

            }else{
           [cell.btnParamValue addTarget:self action:@selector(btnParamValueClick:) forControlEvents:UIControlEventTouchUpInside];
            if ([dicSelectedParam objectForKey:rating.ratingParam]!=nil) {
                
            
            [cell.btnParamValue setTitle:[[dicSelectedParam objectForKey:rating.ratingParam] valueForKey: @"value"] forState:UIControlStateNormal];
               
               // [cell.btnParamValue setTitle:rating.ratingParamValues[0] forState:UIControlStateNormal];
            }else{
             [cell.btnParamValue setTitle:key_Select_Rating forState:UIControlStateNormal];
            }
            }
        // set color code
            
        }
        return cell;
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    //    Assignment *assignment=[arrayAssignment objectAtIndex:indexPath.row];
    //    if( assignment.isExpend==YES)
    //        assignment.isExpend=NO;
    //    else
    //        assignment.isExpend=YES;
    //    [tblViewContent reloadData];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You are in: %s", __FUNCTION__);

    Assignment *assignment=selectedAssignment;
    if(indexPath.row==0)
    {
        float height=90.0f;
        if(assignment.attachedResource!=nil)
        {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                height=height+163.0f;          }
            
            
            else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                height=height+220.0f;
            }

        }
        float width=200;
        if( screenHeight <740 && screenHeight >667 )
        {
            width=298;
            
        }else if  (screenHeight > 568 && screenHeight <= 667 )
        {
            width=270;
        }
        if(assignment.assignmentDesc!=nil){
            
            CGSize labelSize=[AppGlobal   getTheExpectedSizeOfLabel:assignment.assignmentDesc andFontSize:13 labelWidth:width];
            
            
            NSLog(@"%ld",(long)indexPath.row);
            
            if(labelSize.height>16)
                height=height+labelSize.height-16;
        }
        if(assignment.course.courseName!=nil){
            
            CGSize labelSize=[AppGlobal   getTheExpectedSizeOfLabel:assignment.course.courseName andFontSize:13 labelWidth:width];
            
            
            NSLog(@"%ld",(long)indexPath.row);
            
            if(labelSize.height>16)
                height=height+labelSize.height-20;
        }
        
        
        if(![assignment.assignmentStatus isEqualToString:@"3"])
        {
            height=height+30.0f;
        }// if assignment not submitted
        return height;
    }else{
        return 78.0;
    }
    
    
    
    
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}

- (IBAction)btnParamValueClick:(id)sender {
    UIButton *btn=(UIButton*)sender  ;
    selectParam=(int)btn.tag;
    [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
  }
- (IBAction)btnPlayResourceClick:(id)sender {
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
        
        return;
    }
    
    UIButton *btn=(UIButton *)sender;
   
    Resourse *resourse =selectedAssignment.attachedResource;
    if([resourse.resourceUrl containsString:@"vimeo"])
    {
        //   resourse.resourceUrl=@"https://player.vimeo.com/video/140230038?title=0&byline=0&portrait=0";
        //        [self embedYouTube:@"https://player.vimeo.com/video/140230038?title=0&byline=0&portrait=0"  frame:self.view.frame];
        VedioViewController *vedio= [[VedioViewController alloc]initWithNibName:@"VedioViewController" bundle:nil];
        vedio.streamURL=resourse.resourceUrl;//@"https://player.vimeo.com/video/140230038?title=0&byline=0&portrait=0";
        [self.navigationController pushViewController:vedio animated:YES];
        // [appDelegate self].allowRotation = YES;
    }else {
        [self PlayTheVideo:resourse.resourceUrl];
        
    }
}

-(void)PlayTheVideo:(NSString *)stringUrl
{
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    self.moviePlayer =  [[MPMoviePlayerController alloc]initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object: self.moviePlayer];
    
    self.moviePlayer.controlStyle = MPMovieControlStyleDefault;
    self.moviePlayer.shouldAutoplay = YES;
    [ self.moviePlayer prepareToPlay];
    [self.view addSubview: self.moviePlayer.view];
    [ self.moviePlayer setFullscreen:YES animated:YES];
    [ self.moviePlayer stop];
    [ self.moviePlayer play];
    //    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    //    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //
    
    
}
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
    
}
- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    [appDelegate self].allowRotation = YES;
}
- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [appDelegate self].allowRotation = NO;
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:moviePlayerController];
    [self.moviePlayer stop];
    //[self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer=nil;
    
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
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:videoView];
    }
    [videoView loadHTMLString:html baseURL:nil];
    
    videoView.delegate=self;
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
#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen
{
 if([selectedAssignment.assignmentStatus isEqualToString:@"3"])
 {
     return 0;
 }
    AssignmentRating *rating=selectedAssignment.ratingParam[selectParam];
    return [rating.ratingParamValues count];
}
#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    mIntRow=row;
    [pickerView selectRow:mIntRow inComponent:component animated:NO];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    AssignmentRating *rating=selectedAssignment.ratingParam[selectParam];
  
    NSDictionary *responseDic = [ rating.ratingParamValues objectAtIndex:row];
    
    return [ responseDic objectForKey:@"value"];
    
}
- (IBAction)mBtnCancelPicker:(id)sender {
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
    
}

- (IBAction)mBtnDonePicker:(id)sender {
    
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
    AssignmentRating *rating=selectedAssignment.ratingParam[selectParam];
    NSDictionary *responseDic = [ rating.ratingParamValues objectAtIndex:mIntRow];
    
    [dicSelectedParam setObject:responseDic forKey:rating.ratingParam];
    [tableViewAssignmentrating reloadData];
}

@end
