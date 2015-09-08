//
//  UpdateProfileViewController.m
//  Growth Cafe
//
//  Created by Mayank on 24/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "CustomKeyboard.h"
#import "LoginViewController.h"
#import "AFHTTPRequestOperationManager.h"

@interface UpdateProfileViewController () <CustomKeyboardDelegate>
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

@implementation UpdateProfileViewController
@synthesize imgProfile,btnFacebook,lblFirstName,lblLastName,btnDeprtment,btnGroup,btnTitle,btnOrg,mViewAccountTypePicker,mDataPickerView,txtFirstName,txtLastName;
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
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
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
#pragma mark - Private method implementation
-(void)changeFrameAndBackgroundImg
{
    
    //  _btnFacebook.frame = CGRectMake(0, _btnFacebook.frame.origin.y+14, _btnFacebook.frame.size.width, 120);
    //  _btnFacebook.frame = CGRectMake(320/2 - 93/2, self.view.frame.size.height -200, 93, 40);
    btnFacebook.delegate   =self;
    for (id loginObject in btnFacebook.subviews)
    {
        if ([loginObject isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  loginObject;
            UIImage *loginImage = [UIImage imageNamed:@"validatefb.png"];
            // loginButton.alpha = 0.7;
            [loginButton setBackgroundColor:[UIColor colorWithRed:186.0 green:0.0 blue:50.0 alpha:0.0]];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            //CGSize constraint = CGSizeMake(400, 220);
            // [loginButton sizeThatFits:constraint];
            //[loginButton sizeToFit];
        }
        if ([loginObject isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  loginObject;
            loginLabel.text = @"";
            loginLabel.frame = CGRectMake(0, 0, 0, 0);
        }
    }
}
-(void)toggleHiddenState:(BOOL)shouldHide{
    //    self.lblUsername.hidden = shouldHide;
    //    self.lblEmail.hidden = shouldHide;
    //    self.profilePicture.hidden = shouldHide;
}

-(void)setUserProfile {
    // UserDetails *user=[AppGlobal readUserDetail];
    user=[AppSingleton sharedInstance].userDetail;
    
    
    lblFirstName.text=user.userFirstName;
    txtFirstName.text=user.userFirstName;
    lblLastName.text=user.userEmail;
    txtLastName.text=user.userLastName;
    [btnOrg setTitle:user.schoolName forState:UIControlStateNormal];
    [btnDeprtment setTitle:user.className forState:UIControlStateNormal];
    [btnGroup setTitle:user.homeRoomName forState:UIControlStateNormal];
    [btnTitle setTitle:user.title forState:UIControlStateNormal];
    if(user.userFBID==nil)
    {
    //need to validate
    btnFacebook.hidden=NO;
    }else{
        //FB allready validated
        btnFacebook.hidden=YES;
    }
    if(user.userImage!=nil){
   
       //check image available at local
        //get image name from URL
        if([AppGlobal checkImageAvailableAtLocal:user.userImage])
        {
            user.userImageData=[AppGlobal getImageAvailableAtLocal:user.userImage];
            UIImage *img=[UIImage imageWithData:user.userImageData];
            [imgProfile setImage:img];
            imgProfile.layer.cornerRadius = imgProfile.frame.size.width/6;
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
    arraySchools=[AppGlobal getDropdownList:SCHOOL_DATA];
    
    for (NSDictionary *dicSch in arraySchools) {
        if([[dicSch  objectForKey:@"schoolName"] isEqualToString:user.schoolName])
        {
            selectedSchoolId=  [dicSch objectForKey:@"schoolId"];
            selectedSchoolName=  [dicSch objectForKey:@"schoolName"];
            arrayClass=  [dicSch objectForKey:@"classList"];
        }
        
    }
    
    for (NSDictionary *dicClass in arrayClass) {
        if([[dicClass  objectForKey:@"className"] isEqualToString:user.className])
        {
            
            
            selectedClassId=  [dicClass objectForKey:@"classId"];
            selectedClassName=  [dicClass objectForKey:@"className"];
            arrayHome=  [dicClass objectForKey:@"homeRoomList"];
        }
        
    }
    arrayAllData=[AppGlobal getDropdownList:TITLE_DATA];
    for (NSDictionary *dicTitle in arrayAllData) {
        if([[dicTitle  objectForKey:@"Title"] isEqualToString:user.title])
        
            selectedTitle= [dicTitle objectForKey:@"Title"];
        
    }


}
- (IBAction)btnBackClick:(id)sender {
    //Show Indicator
    if(previousStatus==AFNetworkReachabilityStatusNotReachable)
    {
        [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        
       // return;
    }
    UserDetails *usrDetail= [[UserDetails alloc]init];
    
if(![txtFirstName.text isEqualToString:  user.userFirstName])
{
    isUpdate=YES;
    
}else if(![txtLastName.text isEqualToString:  user.userLastName])
    {
        isUpdate=YES;
        
    }else if(![selectedTitle isEqualToString:  user.title])
    {
        isUpdate=YES;
        
    }
    if(isUpdate){
    usrDetail.userFirstName=txtFirstName.text;
    usrDetail.userLastName=txtLastName.text;
    usrDetail.title=selectedTitle;
    usrDetail.userId =user.userId;
    usrDetail.userEmail=user.userEmail;
//    usrDetail.schoolName=selectedSchoolName;
//    usrDetail.schoolId=selectedSchoolId;
//    usrDetail.classId   =selectedClassId;
//    usrDetail.className=selectedClassName;
//    usrDetail.homeRoomName=selectedRoomName;
//    usrDetail.homeRoomId=selectedRoomId;
  
    
    if ([usrDetail.title length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_TITLE title:@""];
    }
    else if ([usrDetail.userFirstName length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_FIRST_NAME title:@""];
    }
    else if ([usrDetail.userLastName length] <= 0){
        [AppGlobal showAlertWithMessage:MISSING_LAST_NAME title:@""];
    }
    
    
    else{
        [activeTextField resignFirstResponder];
        //Show Indicator
        [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
        
        [[appDelegate _engine] updateUserDetail:usrDetail  success:^(UserDetails *userDetail) {
            
            
            user.userFirstName=txtFirstName.text;
            user.userLastName=txtLastName.text;
            user.title=selectedTitle;
            //Hide Indicator
            [appDelegate hideSpinner];
            //navigate to feed view Controller
            [self.navigationController popToRootViewControllerAnimated:YES];
            //            FeedViewController *viewController= [[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
            //            CourseViewController *viewController= [[CourseViewController alloc]initWithNibName:@"CourseViewController" bundle:nil];
            //
            //            [self.navigationController pushViewController:viewController animated:YES];
        }
                                              failure:^(NSError *error) {
                                                  //Hide Indicator
                                                  [appDelegate hideSpinner];
                                                  NSLog(@"failure Json Data %@",[error description]);
                                                  [self registerationError:error];
                                                  
                                              }];
    }
    
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
   
}
-(void)registerationError:(NSError*)error{
    
    [AppGlobal showAlertWithMessage:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] title:@""];
}


- (IBAction)btnPhotoClick:(id)sender {
    
    
    UIActionSheet *popUpSheet = [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:nil
                                 destructiveButtonTitle:nil
                                 otherButtonTitles: nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [popUpSheet addButtonWithTitle:@"Camera"];
        [popUpSheet addButtonWithTitle:@"Photo Library"];
        //  [popUpSheet addButtonWithTitle:@"Camera Roll"];
        
        [popUpSheet addButtonWithTitle:@"Cancel"];
        
        popUpSheet.cancelButtonIndex = popUpSheet.numberOfButtons-1;
        
    }   else {
        
        [popUpSheet addButtonWithTitle:@"Photo Library"];
        //   [popUpSheet addButtonWithTitle:@"Camera Roll"];
        
        [popUpSheet addButtonWithTitle:@"Cancel"];
        
        popUpSheet.cancelButtonIndex = popUpSheet.numberOfButtons-1;
        
    }
    
    [popUpSheet showFromBarButtonItem: self.toolbarItems[0] animated:YES];
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
//    selectedPicker=ROOM_DATA;
//    //  arrayAllData=[AppGlobal getDropdownList:ROOM_DATA];
//    if (arrayHome!=nil &&[arrayHome count]>0)
//        
//    {
//        
//        
//        
//        [mDataPickerView reloadAllComponents];
//        [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
//        [self allTxtFieldsResignFirstResponder];
//    }
//    else{
//        [AppGlobal showAlertWithMessage:DEPART_NOT_FILLED title:@"Department"];
//    }
}
- (IBAction)btnOrgClick:(id)sender {
//    selectedPicker=SCHOOL_DATA;
//    
//    
//    [mDataPickerView reloadAllComponents];
//    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
//    [self allTxtFieldsResignFirstResponder];
//    
////    if((btnDeprtment!=@"Department") ||(btnDeprtment!=@"Group"))
////    {
////        //  [btnDeprtment setTitle:@"Department" forState:UIControlStateNormal];
////        // [btnGroup   setTitle:@"Group" forState:UIControlStateNormal];
////        selectedClassId=nil;
////        selectedClassName=nil;
////        selectedRoomId=nil;
////        selectedRoomName=nil;
////        
////    }else{
////        
////        [btnDeprtment setTitle:@"Department" forState:UIControlStateNormal];
////        [btnGroup   setTitle:@"Group" forState:UIControlStateNormal];
////        selectedClassId=nil;
////        selectedClassName=nil;
////        selectedRoomId=nil;
////        selectedRoomName=nil;
////        
////    }
//    
    
}
- (IBAction)btnDeprtmentClick:(id)sender {
//    selectedPicker=CLASS_DATA;
//    // arrayAllData=[AppGlobal getDropdownList:CLASS_DATA];
//    
//    
//    if (arrayClass!=nil &&[arrayClass count]>0)
//        
//    {
//        
//        [mDataPickerView reloadAllComponents];
//        [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:YES];
//        [self allTxtFieldsResignFirstResponder];
//        
//        
////        if (btnGroup!=@"Group") {
////            // [btnGroup   setTitle:@"Group" forState:UIControlStateNormal];
////            
////            selectedRoomId=nil;
////            selectedRoomName=nil;
////        }else {
////            
////            [btnGroup   setTitle:@"Group" forState:UIControlStateNormal];
////            
////            selectedRoomId=nil;
////            selectedRoomName=nil;
////        }
//    }
//    else{
//        [AppGlobal showAlertWithMessage:ORG_NOT_FILLED title:@"Organization"];
//        
//    }
    
}

- (IBAction)btnTitleClick:(id)sender {
    selectedPicker=TITLE_DATA;
   
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
        
        break;
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
            
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
}
- (IBAction)mBtnCancelPicker:(id)sender {
    [AppGlobal ShowHidePickeratWindow:mViewAccountTypePicker fromWindow:self.view withVisibility:NO];
    
}

- (IBAction)btnLogoutClick:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    [AppSingleton sharedInstance].isUserFBLoggedIn=NO;
    [AppSingleton sharedInstance].isUserLoggedIn=NO;
    // [objCustom removeFromSuperview ];
    [self.tabBarController.tabBar setHidden:YES];
    LoginViewController *viewCont= [[LoginViewController alloc]init];
    [self.navigationController pushViewController:viewCont animated:YES];
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

#pragma mark - FBLoginView Delegate method implementation
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged in.";
    
    //    [self toggleHiddenState:NO];
    //    [self changeFrameAndBackgroundImg];
}
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    //if user is already sign in Then validate with server.
    
    // get user id
    NSString *fbuserid=[NSString  stringWithFormat:@"%@",[user objectForKey:@"id"]];
    //set user Profile
    //Show Indicator
    NSString *username=[AppSingleton sharedInstance].userDetail.userEmail;
    
    
    [appDelegate showSpinnerWithMessage:DATA_LOADING_MSG];
    
    [[appDelegate _engine] SetFBloginWithUserID:username FBID:fbuserid success:^(bool status) {
        self.btnFacebook.hidden=YES;
        [self loginSucessFullWithFB:fbuserid];
        //Hide Indicator
        [appDelegate hideSpinner];
        
        
    } failure:^(NSError *error) {
        //Hide Indicator
        [appDelegate hideSpinner];
        NSLog(@"failure JsonData %@",[error description]);
        [self loginViewShowingLoggedOutUser:loginView];
        
        [self loginError:error];
        
    }];
    
}
-(void)loginSucessFullWithFB:(NSString*)userid {
    // if FB Varification is done then navigate the main screen
    
    [AppGlobal  setValueInDefault:userid value:key_FBUSERID];
    
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    // self.lblLoginStatus.text = @"You are logged out";
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    //[self toggleHiddenState:YES];
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
