//
//  SubmitContentViewController.m
//  Growth Cafe
//
//  Created by Mayank on 22/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "SubmitContentViewController.h"
#import "CustomKeyboard.h"
#import "AssestViewController.h"

@interface SubmitContentViewController ()<CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextView *activeTextField;
    AssestViewController *modalView2;
    
}
@end

@implementation SubmitContentViewController
@synthesize assignment;
@synthesize txtViewURL,txtViewVideoDesc,txtViewVideoTitle,selectedAssest,imgAssest;
- (void)viewDidLoad {
    [super viewDidLoad];
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
     //[appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    // validate the content
    if ([txtViewVideoTitle.text length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_Video_TITLE title:@""];
        // [appDelegate hideSpinner];
    }
    else if ([txtViewVideoDesc.text length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_Video_DESC title:@""];
         //[appDelegate hideSpinner];
    }
    else if (selectedAssest ==nil && [txtViewURL.text length]<=0){
        [AppGlobal showAlertWithMessage:MISSING_Video_URL title:@""];
        // [appDelegate hideSpinner];
    }else{
        // ALAssetRepresentation *defaultRepresentation = [selectedAssest defaultRepresentation];
        // NSString *uti = [defaultRepresentation UTI];
        //        NSURL  *videoURL = [[selectedAssest valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
        
       [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
        [[appDelegate _engine] uploadAssignment:txtViewVideoTitle.text AndVideoDesc:txtViewVideoDesc.text AndVideoURL:txtViewURL.text AndVideoPath:selectedAssest andFileName:@"" AndAssignment:assignment.assignmentId success:^(BOOL logoutValue) {
            //Hide Indicator
            [appDelegate hideSpinner];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
                                        failure:^(NSError *error) {
                                            //Hide Indicator
                                            [appDelegate hideSpinner];
                                            NSLog(@"failure JsonData %@",[error description]);
                                            [self loginError:error];
                                            
                                            
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
    if([textView isEqual:txtViewURL]){
        [self setPositionOfLoginBaseViewWhenStartEditing:-190];
        
    }
    
    activeTextField = textView;
    
    UIToolbar* toolbar;
    if (textView.tag == 10) {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE];
        
    }
    else if (textView.tag == 12)
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
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
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
    [self setPositionOfLoginBaseViewWhenEndEditing];
    [self allTxtFieldsResignFirstResponder];
    
    [activeTextField resignFirstResponder];
    
}
#pragma --
#pragma mark -- Manage View Position

-(void)setPositionOfLoginBaseViewWhenStartEditing:(CGFloat)yAxis{
    
    if (self.view.frame.origin.y != yAxis) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];       [AppGlobal setViewPositionWithView:self.view axisX:self.view.frame.origin.x axisY:yAxis withAnimation:YES];
    }
}

-(void)setPositionOfLoginBaseViewWhenEndEditing{
    [AppGlobal setViewPositionWithView:self.view  axisX:self.view.frame.origin.x  axisY:0.0 withAnimation:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
}
-(void)DidNoSelectAssesst:(id)sender
{
    [sender dismissViewControllerAnimated:YES completion:nil];
    
}

@end
