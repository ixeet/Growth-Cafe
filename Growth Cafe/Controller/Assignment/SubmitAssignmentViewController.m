//
//  SubmitAssignmentViewController.m
//  Growth Cafe
//
//  Created by Mayank on 13/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "SubmitAssignmentViewController.h"
#import "CustomKeyboard.h"
#import "AssestViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>
@interface SubmitAssignmentViewController ()<CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextView *activeTextField;
    AssestViewController *modalView2;
    CGFloat yAxis;
   // BOOL isUploadDone;

}
@end

@implementation SubmitAssignmentViewController
@synthesize assignment;
@synthesize txtViewURL,txtViewVideoDesc,txtViewVideoTitle,selectedAssest,imgAssest,lblUploadStatus,loadingView;
- (void)viewDidLoad {
    
    [super viewDidLoad];
   // isUploadDone=NO;
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        _scollView.scrollEnabled = YES;
     
       
    }else{
     _scollView.scrollEnabled = NO;
    
    }
    
    // Do any additional setup after loading the view from its nib.
    //iOS7 Customization, swipe to pop gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [txtViewURL.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txtViewURL.layer setBorderWidth:2.0];
    [txtViewVideoDesc.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txtViewVideoDesc.layer setBorderWidth:2.0];
    [txtViewVideoTitle.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txtViewVideoTitle.layer setBorderWidth:2.0];
    txtViewVideoTitle.layer.cornerRadius = 10.0f;
    txtViewURL.layer.cornerRadius = 10.0f;
    txtViewVideoDesc.layer.cornerRadius = 10.0f;
    customKeyboard = [[CustomKeyboard alloc] init];
    customKeyboard.delegate = self;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [AppSingleton sharedInstance].comeFromChild=YES;
}
- (void)viewDidLayoutSubviews {
    
   // self.scollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scollView.frame.size.height+0);
       if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
         self.scollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scollView.frame.size.height+100);
        
    }

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

- (IBAction)btnSubmitClick:(id)sender {
  
    //Show Indicator
    // validate the content
    if ([txtViewVideoTitle.text length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_Video_TITLE title:@""];
    }
    else if ([txtViewVideoDesc.text length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_Video_DESC title:@""];
    }
    else if (selectedAssest ==nil && [txtViewURL.text length]<=0){
        [AppGlobal showAlertWithMessage:MISSING_Video_URL title:@""];
        
    }else if([txtViewURL.text length]>0 && ![AppGlobal validateUrlWithString:txtViewURL.text  ])
    {
        [AppGlobal showAlertWithMessage:MISSING_VALID_URL title:@""];
    }

    else{
       // ALAssetRepresentation *defaultRepresentation = [selectedAssest defaultRepresentation];
       // NSString *uti = [defaultRepresentation UTI];
//        NSURL  *videoURL = [[selectedAssest valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
        
 
        //[appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        [loadingView setHidden:NO];
        [self uploadAssignment:txtViewVideoTitle.text AndVideoDesc:txtViewVideoDesc.text AndVideoURL:txtViewURL.text AndVideoPath:selectedAssest andFileName:@"" AndAssignment:assignment.assignmentId success:^(BOOL logoutValue) {
           // isUploadDone=YES;
            
        //Hide Indicator
     // [appDelegate hideSpinner];
            [loadingView setHidden:YES];

            [AppSingleton sharedInstance].comeFromChild=NO;
            [self.navigationController popViewControllerAnimated:YES];

             //[appDelegate hideSpinner];

    }
                                    failure:^(NSError *error) {
                                        //Hide Indicator
                                        //[appDelegate hideSpinner];
                                         [loadingView setHidden:YES];
                                        NSLog(@"failure JsonData %@",[error description]);
                                        [self loginError:error];
                                        //isUploadDone=YES;
                                        
                                    }];
    }
}

-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}
- (IBAction)btnBrowseClick:(id)sender {
//    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    
//    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
 //   picker.sourceType = ui;
//   NSMutableArray *allVideos = [[NSMutableArray alloc] init];
//    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
//    
//    
//     
//    [assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//        if (group)
//        {
//            [group setAssetsFilter:[ALAssetsFilter allVideos]];
//            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
//             {
//                 if (asset)
//                 {
//                     NSMutableDictionary   *dic = [[NSMutableDictionary alloc] init];
//                     ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
//                     NSString *uti = [defaultRepresentation UTI];
//                     NSURL  *videoURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
//                     NSString *title = [NSString stringWithFormat:@"video %d", arc4random()%100];
////                     UIImage *image = [self imageFromVideoURL:videoURL];
//                   //  [dic setValue:image forKey:@"image"];
//                     [dic setValue:title forKey:@"name"];
//                     [dic setValue:videoURL forKey:@"url"];
//                     [allVideos addObject:dic];
//                 }
//             }];
//           
//        }
//
//    } failureBlock:^(NSError *error) {
//        
//    }];
   // [self.navigationController  presentViewController:picker animated:YES completion:nil];
//    AssestViewController *assestView=[[AssestViewController alloc]init];
//    [self.navigationController  pushViewController:assestView animated:YES];
 modalView2 = [[AssestViewController alloc] init];
    modalView2.mDelegate=self;
    [self presentViewController:modalView2 animated:YES  completion:nil];
}
     

- (IBAction)btnBackClick:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma uitextview deligate and datasource
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //txtview.inputAccessoryView=commentView;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
   // CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  
    
    activeTextField = textView;
    if([textView isEqual:txtViewURL]){
        
        if( screenHeight > 480 && screenHeight < 667 ){
            
            yAxis=200;
            [self setPositionOfLoginBaseViewWhenStartEditing:-200];
        }else{
            yAxis=160;
            [self setPositionOfLoginBaseViewWhenStartEditing:-160];
        }
    }

    UIToolbar* toolbar;
    if (textView.tag == 10) {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE];
        
    }
    else if (textView.tag == 11)
    {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :FALSE];
        
    }else {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :TRUE];
    }
    [textView setInputAccessoryView:toolbar];
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  if(txtViewURL==textView)
  {
      //[self setPositionOfLoginBaseViewWhenEndEditing];
      [textView resignFirstResponder];
      
     
  }
     return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setPositionOfLoginBaseViewWhenEndEditing];
    [textField resignFirstResponder];
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
  
   
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}
#pragma mark Custom Keyboard Delegate

- (void)nextClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag + 1;
    
    UITextField *nextResponder = (UITextField*)[self.view viewWithTag:nextTag];
    
    if (!nextResponder.enabled) {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag+1];
    }
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        //Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
    }
}
- (void)previousClicked:(NSUInteger)selectedId
{
    NSInteger nextTag = activeTextField.tag -1;
    
    UITextField *nextResponder = (UITextField*) [self.view  viewWithTag:nextTag];
   
    
     if([activeTextField isEqual:txtViewURL]){
         yAxis=yAxis-150;
        [self setPositionOfLoginBaseViewWhenEndEditing];
        
    }
    while(!nextResponder.enabled)
    {
        nextResponder = (UITextField*)[self.view  viewWithTag:nextTag-1];
    }
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [nextResponder resignFirstResponder];
        
    }
    
}
- (void)doneClicked:(NSUInteger)selectedId
{
    if([activeTextField isEqual:txtViewURL]){

    [self setPositionOfLoginBaseViewWhenEndEditing];

    }
        [self allTxtFieldsResignFirstResponder];
    
}
#pragma --
#pragma mark -- Manage View Position

-(void)setPositionOfLoginBaseViewWhenStartEditing:(CGFloat)yAxis1{
    
//    if (self.scollView.frame.origin.y != yAxis) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];       [AppGlobal setViewPositionWithView:self.scollView axisX:self.scollView.frame.origin.x axisY:yAxis withAnimation:NO];
//    }
    CGRect rc = [_scollView bounds];
    
    [_scollView setContentOffset:CGPointMake(rc.origin.x, rc.origin.y-yAxis1) animated:YES];
}

-(void)setPositionOfLoginBaseViewWhenEndEditing{
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in _scollView.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
//    self.scollView.contentSize  = contentRect.size;

  CGRect rc = [_scollView bounds];
//    
  [_scollView setContentOffset:CGPointMake(rc.origin.x, rc.origin.y-yAxis) animated:YES];
//    [AppGlobal setViewPositionWithView:self.scollView  axisX:self.scollView.frame.origin.x  axisY:0.0 withAnimation:YES];
   
  // [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)onKeyboardHide:(NSNotification *)notification{
    //Get size keyboard for manage self your views.
    [self setPositionOfLoginBaseViewWhenEndEditing];
    [self allTxtFieldsResignFirstResponder];
}

-(void)allTxtFieldsResignFirstResponder{
    
    [txtViewURL resignFirstResponder];
    [txtViewVideoDesc resignFirstResponder];
    [txtViewVideoTitle   resignFirstResponder];
  
    
}
-(void)DidSelectAssesst: (ALAsset *)selectedAsset andSender:(id)sender
{
    selectedAssest=selectedAsset;
    [imgAssest setImage:[UIImage imageWithCGImage:[selectedAssest thumbnail]]];
    [imgAssest setHidden:NO];
    [sender dismissViewControllerAnimated:YES completion:nil];
    
  //  NSMutableDictionary   *dic = [[NSMutableDictionary alloc] init];
    ALAssetRepresentation *defaultRepresentation = [selectedAssest defaultRepresentation];
    NSString *uti = [defaultRepresentation UTI];
    NSURL  *videoURL = [[selectedAssest valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
   // NSURL *outputURL = [NSURL fileURLWithPath:@"/output.mov"];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath =  [NSString stringWithFormat:@"%@/%@.mp4",[arr objectAtIndex:0],@"output" ];
    NSURL *outputURL = [NSURL fileURLWithPath:filePath];
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    [self convertVideoToLowQuailtyWithInputURL:videoURL outputURL:outputURL handler:^(AVAssetExportSession *exportSession)
     {
        [appDelegate hideSpinner];
         if (exportSession.status == AVAssetExportSessionStatusCompleted)
         {
             printf("completed\n");
//             NSData *data= [NSData dataWithContentsOfURL:outputURL];
            [NSData dataWithContentsOfURL:outputURL];
         }
         else
         {
             printf("error\n");
             
         }
     }];
}
-(void)DidNoSelectAssesst:(id)sender
{
    [sender dismissViewControllerAnimated:YES completion:nil];

}
- (void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
                                     handler:(void (^)(AVAssetExportSession*))handler
{
    [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         handler(exportSession);
         
     }];
}
-(void)uploadAssignment:(NSString*)videoTitle  AndVideoDesc:(NSString*)videoDesc AndVideoURL:(NSString*)videoURL AndVideoPath:(ALAsset*)asset andFileName:(NSString*)fileName  AndAssignment:(NSString*)assignmentId  success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    //    Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
    //    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
    //    NSData *videoData =[NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES] ;
    
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath =  [NSString stringWithFormat:@"%@/%@.mp4",[arr objectAtIndex:0],@"output" ];
    NSURL *outputURL = [NSURL fileURLWithPath:filePath];
    
    NSData *videoData= [NSData dataWithContentsOfURL:outputURL];
    
    
    // NSString *urlString = @"http://192.168.0.10:8080/SLMS/rest/course/uploadResourceDetail"; // your url
    // NSString *urlString = @"http://191.239.57.54:8080/SLMS/rest/course/uploadResourceDetail"; // your url
    
    
    NSString *BoundaryConstant = @"---------------------------14737809831466499882746641449";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:POST_ASSIGNMENT_URL]];
    UserDetails * objUser=[AppSingleton  sharedInstance].userDetail;
    
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    NSMutableDictionary *_params=[[NSMutableDictionary alloc]init];
    [_params setObject:videoTitle forKey:@"resourceName"];
    
    [_params setObject:[NSString stringWithFormat:@"%@ %@", objUser.userFirstName,objUser.userLastName ] forKey:@"resourceAuthor"];
    [_params setObject:videoDesc forKey:@"descTxt"];
    [_params setObject:objUser.userEmail forKey:@"userName"];
    [_params setObject:videoURL forKey:@"uploadedUrl"];
    [_params setObject:assignmentId forKey:@"assignmentId"];
    
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"logo@2x.png"], 1.0);
    if (videoData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"output.mp4\"\r\n", @"fileName"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:videoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    NSError* error;
    //    NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:returnData
    //                                                         options:kNilOptions
    //                                                           error:&error];
    
    
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseDic) {
                                         if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
                                             
                                             success(YES);
                                         }else{
                                             failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
                                         }
                                         
                                         
                                         NSLog(@"Success %@", responseDic);
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
                                         NSLog(@"Failure %@", error.description);
                                     }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
        float percent = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
        percent=percent*100;
        if(percent>99)
        {
             lblUploadStatus.text=[NSString stringWithFormat:@"file Uploaded"];
        }else{
            NSInteger percentInt=(NSInteger)percent;
            lblUploadStatus.text=[NSString stringWithFormat:@"%ld %@ of 100%@ Uploaded",percentInt,@"%",@"%"];}
    }];
    
    // 5. Begin!
    [operation start];
    
}
@end