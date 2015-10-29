//
//  ProfileViewController.m
//  sLMS
//
//  Created by Mayank on 30/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "ProfileViewController.h"
#import "CustomKeyboard.h"
#import "AFHTTPRequestOperationManager.h"

@interface ProfileViewController () <CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextField *activeTextField;
    UserDetails *user;
    
    
    
    int             mIntRow;
    NSMutableArray *arrayAllData;
    NSMutableArray *arraySchools;
    NSMutableArray *arrayClass;
    NSMutableArray *arrayHome;
    AppDropdownType selectedPicker;
    NSString *selectedSchoolId,*selectedClassId,*selectedRoomId;
    NSString *selectedSchoolName,*selectedClassName,*selectedRoomName;
    NSString *selectedTitle;
    BOOL isFirstLoginDone;
    BOOL isUpdate;
    AFNetworkReachabilityStatus previousStatus;
    
    
    
    
    
}

@end

@implementation ProfileViewController
@synthesize imgProfile,lblFirstName,lblLastName,btnDeprtment,btnGroup,btnTitle,btnOrg,mViewAccountTypePicker,mDataPickerView,txtFirstName,txtLastName,user;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    CALayer *imageLayer = imgProfile.layer;
    //    [imageLayer setCornerRadius:75];
    previousStatus=[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    [self setUserProfile];
    isUpdate=NO;
    //  [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
    
    isFirstLoginDone=NO;
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
-(void)viewWillAppear:(BOOL)animated
{
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
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    //    self.lblUsername.hidden = shouldHide;
    //    self.lblEmail.hidden = shouldHide;
    //    self.profilePicture.hidden = shouldHide;
}

-(void)setUserProfile {
    
    // UserDetails *user=[AppGlobal readUserDetail];
    
    
    lblFirstName.text=user.userFirstName;
    
    txtFirstName.text=user.userFirstName;
    
    lblLastName.text=user.userEmail;
    
    txtLastName.text=user.userLastName;
    
    [btnOrg setTitle:user.schoolName forState:UIControlStateNormal];
    
    [btnDeprtment setTitle:user.className forState:UIControlStateNormal];
    
    [btnGroup setTitle:user.homeRoomName forState:UIControlStateNormal];
    
    [btnTitle setTitle:user.title forState:UIControlStateNormal];
    
    arrayAllData=[AppGlobal getDropdownList:TITLE_DATA];
    
    for (NSDictionary *dicTitle in arrayAllData) {
        
        if([[dicTitle  objectForKey:@"Title"] isEqualToString:user.title])
            
            
            
            selectedTitle= [dicTitle objectForKey:@"Title"];
        
        
        
    }
    
    if(user.userImage!=nil){
        
        
        
        //check image available at local
        
        //get image name from URL
        
        if([AppGlobal checkImageAvailableAtLocal:user.userImage])
            
        {
            
            user.userImageData=[AppGlobal getImageAvailableAtLocal:user.userImage];
            
            UIImage *img=[UIImage imageWithData:user.userImageData];
            
            [imgProfile setImage:img];
            
            imgProfile.layer.cornerRadius = imgProfile.frame.size.width/2;
            
            imgProfile.clipsToBounds = YES;
            
            NSLog(@"%@",@"yes");
            
        }else{
            
            NSURL *imageURL = [NSURL URLWithString:user.userImage];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                user.userImageData  = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Update the UI
                    
                    UIImage *img=[UIImage imageWithData:user.userImageData];
                    
                    [AppGlobal setImageAvailableAtLocal:user.userImage AndImageData:user.userImageData];
                    
                    if(img!=nil)
                        
                    {
                        
                        [imgProfile setImage:img];
                        
                        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2;
                        
                        imgProfile.clipsToBounds = YES;
                        
                        
                        
                        
                        
                    }
                    
                });
                
            });
            
        }
        
        //        }else{
        
        //            UIImage *img=[UIImage imageWithData:user.userImageData];
        
        //            [imgProfile setImage:img];
        
        //            imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2;
        
        //            imgProfile.clipsToBounds = YES;
        
        //
        
        //
        
        //        }
        
    }
    
    arraySchools=[AppGlobal getDropdownList:SCHOOL_DATA]    ;
    
    if(user.userRole!=2)
        
    {
        
        return;
        
    }
    
    if(user.userRole==2)
        
    {
        
        arraySchools=[AppGlobal getDropdownList:TEACHER_DATA];
        
    }
    for (NSDictionary *dicSch in arraySchools) {
        
        //        if([[dicSch  objectForKey:@"schoolName"] isEqualToString:user.schoolName])
        
        //        {
        
        selectedSchoolId=  [dicSch objectForKey:@"schoolId"];
        
        selectedSchoolName=  [dicSch objectForKey:@"schoolName"];
        
        [btnOrg setTitle:selectedSchoolName forState:UIControlStateNormal];
        
        
        
        arrayClass=  [dicSch objectForKey:@"classList"];
        
        // }
        
        
        
    }
    
    
    
    for (NSDictionary *dicClass in arrayClass) {
        
        //        if([[dicClass  objectForKey:@"className"] isEqualToString:user.className])
        
        //        {
        
        
        
        
        
        selectedClassId=  [dicClass objectForKey:@"classId"];
        
        selectedClassName=  [dicClass objectForKey:@"className"];
        
        [btnDeprtment setTitle:selectedClassName forState:UIControlStateNormal];
        
        
        
        
        
        arrayHome=  [dicClass objectForKey:@"homeRoomList"];
        
        //}
        
        
        
    }
    
    if([arrayHome count]>0)
        
    {
        
        NSDictionary *dicHome = [arrayHome objectAtIndex:0];
        
        [btnGroup setTitle:  [dicHome objectForKey:@"homeRoomName"]  forState:UIControlStateNormal];
        
        
        
    }
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
        
    
    
}
-(void)registerationError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        if (buttonIndex == 0) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:nil];
            
        } else {
            
            if (buttonIndex == 0) {
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                
                [self presentViewController:picker animated:NO completion:NULL];
                
                
            }
            else if (buttonIndex == 1) {
                
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
                [self presentViewController:picker animated:YES completion:NULL];
                
                
            }
            
            
        }
    }
}


- (IBAction)btnGroupClick:(id)sender {
    if(user.userRole!=2)
        return;
    selectedPicker=ROOM_DATA;
    mIntRow=0;
    //  arrayAllData=[AppGlobal getDropdownList:ROOM_DATA];
    if (arrayHome!=nil &&[arrayHome count]>0){
        if(selectedRoomId!=nil)
        {
            for (NSDictionary *dic in arrayHome) {
                if([[dic objectForKey:@"homeRoomName"] isEqualToString:selectedRoomName] )
                {
                    mIntRow =[arrayHome indexOfObject:dic] ;
                }
            }
            
        }
        [mDataPickerView reloadAllComponents];
        [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
        [self allTxtFieldsResignFirstResponder];
    }else{
        [AppGlobal showAlertWithMessage:DEPART_NOT_FILLED title:@"Department"];
    }
    
    
}
- (IBAction)btnOrgClick:(id)sender {
    if(user.userRole!=2)
        return;
    selectedPicker=SCHOOL_DATA;
    mIntRow=0;
    if(selectedSchoolId!=nil)
    {
        for (NSDictionary *dic in arraySchools) {
            if([[dic objectForKey:@"schoolName"] isEqualToString:selectedSchoolName] )
            {
                mIntRow =[arraySchools indexOfObject:dic] ;
            }
        }
        
    }
    [mDataPickerView selectRow:mIntRow inComponent:0 animated:YES];
    [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
    [self allTxtFieldsResignFirstResponder];
    
    
    
}
- (IBAction)btnDeprtmentClick:(id)sender {
    if(user.userRole!=2)
        return;
    selectedPicker=CLASS_DATA;
    //   arrayAllData=[AppGlobal getDropdownList:CLASS_DATA];
    mIntRow=0;
    
    if (arrayClass!=nil &&[arrayClass count]>0)
        
    {
        if(selectedClassId!=nil)
        {
            for (NSDictionary *dic in arrayClass) {
                if([[dic objectForKey:@"className"] isEqualToString:selectedClassName] )
                {
                    mIntRow =[arrayClass indexOfObject:dic] ;
                }
            }
            
        }
        [mDataPickerView reloadAllComponents];
        [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
        [self allTxtFieldsResignFirstResponder];
        
        //
        //        if (btnHome!=@"Group") {
        //            // [btnHome   setTitle:@"Group" forState:UIControlStateNormal];
        //
        //            selectedRoomId=nil;
        //            selectedRoomName=nil;
        //        } else {
        //            [btnHome   setTitle:@"Group" forState:UIControlStateNormal];
        
        //            selectedRoomId=nil;
        //            selectedRoomName=nil;
        //  }
    }else{
        [AppGlobal showAlertWithMessage:ORG_NOT_FILLED title:@"Organization"];
    }
}

- (IBAction)btnTitleClick:(id)sender {
    
    mIntRow=0;
    selectedPicker=TITLE_DATA;
    
    arrayAllData=[AppGlobal getDropdownList:TITLE_DATA];
    if(selectedTitle!=nil)
    {
        for (NSDictionary *dic in arrayAllData) {
            if([[dic objectForKey:@"Title"] isEqualToString:selectedTitle] )
            {
                mIntRow =[arrayAllData indexOfObject:dic] ;
                break;
            }
        }
        
    }
    [mDataPickerView selectRow:mIntRow inComponent:0 animated:YES];
    [mDataPickerView reloadAllComponents];
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
    [self allTxtFieldsResignFirstResponder];
    
}

-(void)allTxtFieldsResignFirstResponder{
    
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    
}


#pragma --
#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    activeTextField = textField;
    
    UIToolbar* toolbar;
    if (textField.tag == 10) {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:FALSE :TRUE];
        
    }
    else     {
        toolbar = [customKeyboard getToolbarWithPrevNextDone:TRUE :FALSE];
        
    }    [textField setInputAccessoryView:toolbar];
    
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (textField.tag == 10) {
        user.userFirstName=textField.text;
    }else{
        user.userLastName=textField.text;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    return YES;
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
    
    
    [activeTextField resignFirstResponder];
    
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen
{    switch(selectedPicker) {
    case SCHOOL_DATA:
    {
        return  [arraySchools count];
    }break;
    case CLASS_DATA:
    {
        return [arrayClass count];
        
    }break;
    case ROOM_DATA:
    {
        return [arrayHome count];
        
    }break;
    case TITLE_DATA:
    {
        return [arrayAllData count];
        
    }break;
    case COURSE_DATA:
    {
        return [arrayAllData count];
        
    }break;
    case TEACHER_DATA:
    {
        return [arrayAllData count];
        
    }break;
    case MODULE_DATA:
    {
        return [arrayAllData count];
        
    }break;
    case REVIEW_STATUS_DATA:
    {
        return 0;
        
    }break;
        
    default:
        [NSException raise:NSGenericException format:@"Unexpected FormatType."];
        
}
    
    
    
}
#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    mIntRow=row;
    [pickerView selectRow:row inComponent:component animated:NO];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch(selectedPicker) {
        case SCHOOL_DATA:
        {
            NSDictionary *responseDic = [ arraySchools objectAtIndex:row];
            
            return [responseDic objectForKey:@"schoolName"];
            
            
            break;
        }
        case CLASS_DATA:
        {
            NSDictionary *responseDic = [ arrayClass objectAtIndex:row];
            return [responseDic objectForKey:@"className"];
            
            break;
        }
        case ROOM_DATA:
        {
            NSDictionary *responseDic = [ arrayHome objectAtIndex:row];
            return [responseDic objectForKey:@"homeRoomName"];
            
            break;
        }
        case TITLE_DATA:
        {
            NSDictionary *responseDic = [ arrayAllData objectAtIndex:row];
            return [responseDic objectForKey:@"Title"];
            break;
        }
        case COURSE_DATA:
        {
            NSDictionary *responseDic = [ arrayAllData objectAtIndex:row];
            return [responseDic objectForKey:@"Title"];
            break;
        }
        case TEACHER_DATA:
        {
            NSDictionary *responseDic = [ arrayAllData objectAtIndex:row];
            return [responseDic objectForKey:@"Title"];
            break;
        }
            
        case MODULE_DATA:
        {
            NSDictionary *responseDic = [ arrayAllData objectAtIndex:row];
            return [responseDic objectForKey:@"Title"];
            break;
        }
        case REVIEW_STATUS_DATA:
        {
            return 0;
            
        }break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
}
- (IBAction)mBtnCancelPicker:(id)sender {
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
    
}



- (IBAction)mBtnDonePicker:(id)sender {
    
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
    switch(selectedPicker) {
        case SCHOOL_DATA:
        {
            NSDictionary *responseDic = [ arraySchools objectAtIndex:mIntRow];
            arrayClass=  [responseDic objectForKey:@"classList"];
            if(![[responseDic objectForKey:@"schoolId"]isEqualToString:selectedSchoolId])
            {
                selectedClassId=nil;
                selectedClassName=nil;
                selectedRoomId=nil;
                selectedRoomName=nil;
                [btnDeprtment setTitle:@"Department" forState:UIControlStateNormal];
                [btnGroup   setTitle:@"Group" forState:UIControlStateNormal];
            }
            selectedSchoolId=  [responseDic objectForKey:@"schoolId"];
            selectedSchoolName=  [responseDic objectForKey:@"schoolName"];
            [btnOrg setTitle:selectedSchoolName forState:UIControlStateNormal];
            [btnOrg setTitleColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0] forState: UIControlStateNormal ];
            //[responseDic objectForKey:@"SchoolName"];
            
            break;
        }
        case CLASS_DATA:
        {
            NSDictionary *responseDic = [ arrayClass objectAtIndex:mIntRow];
            arrayHome=  [responseDic objectForKey:@"homeRoomList"];
            if(![[responseDic objectForKey:@"classId"]isEqualToString:selectedClassId])
            {
                
                selectedRoomId=nil;
                selectedRoomName=nil;
                [btnGroup   setTitle:@"Group" forState:UIControlStateNormal];
            }
            selectedClassId=  [responseDic objectForKey:@"classId"];
            selectedClassName=  [responseDic objectForKey:@"className"];
            //[responseDic objectForKey:@"ClassName"];
            [btnDeprtment setTitle:selectedClassName forState:UIControlStateNormal];
            [btnDeprtment setTitleColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0] forState: UIControlStateNormal ];
            break;
        }
        case ROOM_DATA:
        {
            NSDictionary *responseDic = [ arrayHome objectAtIndex:mIntRow];
            selectedRoomId=  [responseDic objectForKey:@"homeRoomId"];
            selectedRoomName=  [responseDic objectForKey:@"homeRoomName"];
            // [responseDic objectForKey:@"HoomRoom"];
            [btnGroup setTitle:selectedRoomName forState:UIControlStateNormal];
            [btnGroup setTitleColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0] forState: UIControlStateNormal ];
            
            break;
        }
        case TITLE_DATA:
        {
            NSDictionary *responseDic = [ arrayAllData objectAtIndex:mIntRow];
            selectedTitle= [responseDic objectForKey:@"Title"];
            [btnTitle setTitle:selectedTitle forState:UIControlStateNormal];
            [btnTitle setTitleColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.0] forState: UIControlStateNormal ];
            break;
        }
            
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
}





-(void)loginError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        return;
    }
    
    //Show Indicator
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] updateUserImage:image success:^(BOOL successValue) {
        
        
        
        //Hide Indicator
        [appDelegate hideSpinner];
        
        user=[AppSingleton sharedInstance].userDetail;
        if(user.userImage!=nil){
            
            
            NSURL *imageURL = [NSURL URLWithString:user.userImage];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                user.userImageData  = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *img=[UIImage imageWithData:user.userImageData];
                    if(img!=nil)
                    {
                        [imgProfile setImage:img];
                        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2;
                        imgProfile.clipsToBounds = YES;
                        
                        
                    }
                });
            });
        }
        
    }
                                   failure:^(NSError *error) {
                                       //Hide Indicator
                                       [appDelegate hideSpinner];
                                       NSLog(@"failure Json Data %@",[error description]);
                                       [self registerationError:error];
                                       
                                   }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//
//    imgProfile.image = image;
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    _lblStatus.text=status;
    [_viewNetwork setHidden:newVisibility];
}


- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}
@end
