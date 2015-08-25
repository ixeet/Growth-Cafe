//
//  UpdateProfileViewController.m
//  Growth Cafe
//
//  Created by Mayank on 24/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "CustomKeyboard.h"

@interface UpdateProfileViewController () <CustomKeyboardDelegate>
{
    //keyboard
    CustomKeyboard *customKeyboard;
    UITextField *activeTextField;
    UserDetails *user;
}

@end

@implementation UpdateProfileViewController
@synthesize imgProfile,btnFacebook,lblFirstName,lblLastName,btnDeprtment,btnGroup,btnMr,btnOrg;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    CALayer *imageLayer = imgProfile.layer;
//    [imageLayer setCornerRadius:75];
    imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2;
    imgProfile.clipsToBounds = NO;
    [self setUserProfile];
    //  [self toggleHiddenState:YES];
    // self.lblLoginStatus.text = @"";
    
    self.btnFacebook.delegate = self;
    self.btnFacebook.readPermissions = @[@"public_profile", @"email"];
    [self changeFrameAndBackgroundImg];
 
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
            UIImage *loginImage = [UIImage imageNamed:@"validate-facebook.png"];
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
    lblLastName.text=user.userLastName;
    [btnOrg setTitle:user.schoolName forState:UIControlStateNormal];
    [btnDeprtment setTitle:user.className forState:UIControlStateNormal];
    [btnGroup setTitle:user.homeRoomName forState:UIControlStateNormal];
    [btnMr setTitle:user.title forState:UIControlStateNormal];
     if(user.userFBID==nil)
    {
        //need to validate
        btnFacebook.hidden=NO;
    }else{
        //FB allready validated
        btnFacebook.hidden=YES;
    }
}
- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)btnPhotoClick:(id)sender {
}

- (IBAction)btnMrClick:(id)sender {
}
- (IBAction)btnOrgClick:(id)sender {
}
- (IBAction)btnDeprtmentClick:(id)sender {
}
- (IBAction)btnGroupClick:(id)sender {
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
@end
