//
//  AppEngine.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "AppEngine.h"
#import "LoginHandler.h"
#import "UserDetail.h"
#import "NSString+AESCrypt.h"
#import "CourseHandler.h"
#import "FeedHandler.h"
#import "AssignmentHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "SettingHandler.h"
#import "SearchHandler.h"

@implementation AppEngine

#pragma mark - User login


//User Login with credentials (user id and password)
-(void)loginWithUserName:(NSString*)userName password:(NSString*)password rememberMe:(BOOL)rememberMe success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    
    LoginHandler *login=[[LoginHandler alloc] init];
    // convert to AES 256 Exncryption
    NSString  *encpassword=password;//=  [password AES256EncryptWithKey:@"m@zd@10017017Int33r@IT"];
    //  NSString  *decpassword=  [encpassword AES256DecryptWithKey:@"m@zd@10017017Int33r@IT"];
    [login loginWithUserName:userName password:encpassword  success:^(UserDetails *userDetail){
        
//        if (rememberMe) {  //Save Login Detail In user default
//            [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:YES]];
//        }
//        else{//Remove Login Detail In user default
           // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
       // }
        
        [AppGlobal setValueInDefault:key_loginId value:userName];
        [AppGlobal setValueInDefault:key_loginPassword value:password];
        
        success(userDetail);
        
    }failure:^(NSError *error){
       // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
-(void)registerTheDeviceToken:(NSString*)deviceToken deviceType:(NSString *)deviceType success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    [login registerTheDeviceToken:deviceToken deviceType:deviceType success:^(BOOL logoutValue){
        success(logoutValue);
    }failure:^(NSError *error){
        failure(error);
    }];

}
#pragma mark - logout

//User Logout
-(void)logout:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    [login logout:^(BOOL logoutValue){
        success(logoutValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
#pragma mark - Forget Password


//User Forget password 
-(void)ForgetPasswordWithUserName:(NSString*)userName success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    
    LoginHandler *login=[[LoginHandler alloc] init];
    
    [login ForgetPasswordWithUserName:userName  success:^(BOOL logoutValue){
        
        success(logoutValue);
        
    }failure:^(NSError *error){
        
        failure(error);
    }];
}
#pragma mark - User register


//User Register
-(void)registerWithUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
 //   user.userPassword=  [user.userPassword AES256EncryptWithKey:@"m@zd@10017017Int33r@IT"];
    [login registerWithUserDetail:user  success:^(UserDetails *userDetail){
        
       
        
        success(userDetail);
        
    }failure:^(NSError *error){
       // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
//Update user Profile
-(void)updateUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    //   user.userPassword=  [user.userPassword AES256EncryptWithKey:@"m@zd@10017017Int33r@IT"];
    [login updateUserDetail:user  success:^(UserDetails *userDetail){
        
        
        
        success(userDetail);
        
    }failure:^(NSError *error){
        // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
//Update user Profile Image
-(void)updateUserImage:(UIImage*)image success:(void (^)(BOOL successValue))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    //   user.userPassword=  [user.userPassword AES256EncryptWithKey:@"m@zd@10017017Int33r@IT"];
    [login updateUserImage:image  success:^(BOOL successValue){
        
        
        
        success(successValue);
        
    }failure:^(NSError *error){
        // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}

//FB Varification by Server
-(void)FBloginWithUserID:(NSString*)userid success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    LoginHandler *login=[[LoginHandler alloc] init];
    [login FBloginWithUserID:userid  success:^(UserDetails *userDetail){
        
        
        
        success(userDetail);
        
    }failure:^(NSError *error){
        //[AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];
}
//User Set FB  with user id
-(void)SetFBloginWithUserID:(NSString*)username FBID:(NSString*)fbid success:(void (^)(bool status))success  failure:(void (^)(NSError *error))failure{
    LoginHandler *login=[[LoginHandler alloc] init];
    [login SetFBloginWithUserID:username FBID:fbid  success:^(bool status){
        
        
        
        success(status);
        
    }failure:^(NSError *error){
       // [AppGlobal setValueInDefault:key_rememberMe value:[NSNumber numberWithBool:NO]];
        failure(error);
    }];

}
//get Master Data
-(void)getMasterData:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure{
    LoginHandler *login=[[LoginHandler alloc] init];
    [login getMasterData:^(BOOL successValue){
        success(successValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
//get Master Data for teacher
-(void)getMasterDataForTeacher:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure{
    LoginHandler *login=[[LoginHandler alloc] init];
    [login getMasterDataForTeacher:^(BOOL successValue){
        success(successValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)saveTeacherMasterData
{
    // user type is  teacher call its master data
    if([AppSingleton sharedInstance].userDetail.userRole ==2)
    {
        [[appDelegate _engine] getMasterDataForTeacher:^(BOOL success) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma Courses Functions
//get my Course Data
-(void)getMyCourse:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *courses))success  failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course getMyCourse:userid  AndTextSearch:txtSearch success:^(NSMutableArray *courseList){
        success(courseList);
    }failure:^(NSError *error){
        failure(error);
    }];
}
//get my Course Data
-(void)getCourse:(NSString*)userid AndFilter:(NSMutableDictionary*)dicfilter success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course getCourse:userid  AndFilter:dicfilter success:^(NSMutableArray *courseList){
        success(courseList);
    }failure:^(NSError *error){
        failure(error);
    }];
}
#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)selectedcourse success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course getModuleDetail:userid  AndTextSearch:txtSearch AndSelectModule:module AndSelectCourse:selectedcourse success:^(NSDictionary *moduleDetail){
        success(moduleDetail);
    }failure:^(NSError *error){
        failure(error);
    }];
}
#pragma Comment and Like on Resource
//Comment and Like on Resource
-(void)setCommentOnResource:(NSString*)resourceId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course setCommentOnResource:resourceId AndCommentText:txtComment success:^(BOOL logoutValue){
        
        success(logoutValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)setLikeOnResource:(NSString*)resourceId success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course setLikeOnResource:resourceId success:^(BOOL logoutValue){
        
        success(logoutValue);

    }failure:^(NSError *error){
        failure(error);
    }];

}

#pragma Comment and Like on Comment
//Comment and Like on Comment
-(void)setCommentOnComment:(NSString*)commentId  AndisFeed:(BOOL)isFeed AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course setCommentOnComment:commentId AndisFeed:isFeed AndCommentText:txtComment success:^(BOOL logoutValue){
        
        success(logoutValue);
    } failure:^(NSError *error){
        failure(error);
    }];
}
-(void)setLikeOnComment:(NSString*)commentId AndisFeed:(BOOL)isFeed success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure
{
    CourseHandler *course=[[ CourseHandler alloc] init];
    [course setLikeOnComment:commentId AndisFeed:isFeed success:^(BOOL logoutValue){
        
        success(logoutValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
#pragma Comment and Like on Update
//Comment and Like on Update
-(void)setCommentOnUpdate:(NSString*)updateId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure
{
    FeedHandler *feed=[[FeedHandler alloc] init];
    [feed setCommentOnUpdate:updateId AndCommentText:txtComment success:^(BOOL logoutValue){
        
        success(logoutValue);
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)setLikeOnUpdate:(NSString*)resourceId success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure
{
    FeedHandler *feed=[[FeedHandler alloc] init];
    [feed setLikeOnUpdate:resourceId success:^(BOOL logoutValue){
        
        success(logoutValue);
        
    }failure:^(NSError *error){
        failure(error);
    }];
    
}
-(void)getUpdates:(NSString*)userid  AndTextSearch:(NSString*)txtSearch Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)(NSMutableDictionary *updates))success   failure:(void (^)(NSError *error))failure{

    FeedHandler *feed=[[FeedHandler alloc] init];
    [feed getUpdates:userid  AndTextSearch:txtSearch Offset:offset NoOfRecords:noOfRecords success:^(NSMutableDictionary *updates){
        success(updates);
        
    }failure:^(NSError *error){
        failure(error);
    }];
    
}
//get Updates detail
-(void)getUpdatesDetail:(NSString*)updateId success:(void (^)(Update *updates))success   failure:(void (^)(NSError *error))failure{
    
    FeedHandler *feed=[[FeedHandler alloc] init];
    [feed getUpdatesDetail:updateId  success:^(Update *updates){
        success(updates);
        
    }failure:^(NSError *error){
        failure(error);
    }];

}
-(void)setUpdatesStatus:(NSString*)updateId success:(void (^)(BOOL logoutValue))success failure:(void (^)(NSError *error))failure{
    FeedHandler *feed=[[FeedHandler alloc] init];
    [feed setUpdatesStatus:updateId  success:^(BOOL logoutValue){
        success(logoutValue);
        
    }failure:^(NSError *error){
        failure(error);
    }];
    

}
//get Notification Data
-(void)getNotification:(NSString*)userid  AndTextSearch:(NSString*)txtSearch Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)(NSMutableDictionary *updates))success   failure:(void (^)(NSError *error))failure{

    FeedHandler *feed=[[FeedHandler alloc] init];
   
    [feed getNotification: userid AndTextSearch:txtSearch Offset:offset NoOfRecords:noOfRecords success:^(NSMutableDictionary *updates){
        success(updates);
        
    }failure:^(NSError *error){
        failure(error);
    }];

}
//get more comments
-(void)getMoreComment:(NSString*)updateId  Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)( NSMutableDictionary *comments))success   failure:(void (^)(NSError *error))failure
{
    FeedHandler *feed=[[FeedHandler alloc] init];
    [feed getMoreComment:updateId  Offset:offset NoOfRecords:noOfRecords success:^(NSMutableDictionary *comments){
        success(comments);
        
    }failure:^(NSError *error){
        failure(error);
    }];
}
-(void)getUserDetail:(NSString* )userid success:(void (^)(UserDetails *usrDetail))success   failure:(void (^)(NSError *error))failure{
    LoginHandler *login=[[LoginHandler alloc] init];
    [login getUserDetail:userid success:^(UserDetails *usrDetail) {
        
   
        success(usrDetail);
        
    }failure:^(NSError *error){
        failure(error);
    }];

}
//get Course Detail
-(void)getCourseDetail:(NSString* )feedId success:(void (^)(NSMutableArray *courseList))success   failure:(void (^)(NSError *error))failure
{
    
    CourseHandler *course=[[CourseHandler alloc] init];
    [course getCourseDetailByFeed:feedId success:^(NSMutableArray *courseList) {
        
        
        success(courseList);
        
    }failure:^(NSError *error){
        failure(error);
    }];
}
//get Module Detail
-(void)getModuleDetail:(NSString* )feedId success:(void (^)(NSDictionary *moduleDetail))success   failure:(void (^)(NSError *error))failure{
    CourseHandler *course=[[CourseHandler alloc] init];
    [course getModuleDetailByFeed:feedId success:^(NSDictionary *moduleDetail) {
        
        
        success(moduleDetail);
        
    }failure:^(NSError *error){
        failure(error);
    }];

}

#pragma Assignment Detail Functions
//get my Assignment Data
-(void)getMyAssignments:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure
{
    AssignmentHandler *assign=[[AssignmentHandler alloc] init];
    [assign getMyAssignments:userid AndTextSearch:txtSearch success:^(NSMutableArray *moduleDetail) {
        
        
        success(moduleDetail);
        
    }failure:^(NSError *error){
        failure(error);
    }];
    
}

-(void)getTeacherAssignment:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndFilterDic:(NSMutableDictionary*)filterDic success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure
{
    AssignmentHandler *assign=[[AssignmentHandler alloc] init];
    [assign getTeacherAssignment:userid AndTextSearch:txtSearch AndFilterDic:filterDic  success:^(NSMutableArray *moduleDetail) {
        
        
        success(moduleDetail);
        
    }failure:^(NSError *error){
        failure(error);
    }];
    
}
//set Assignment rating
-(void)setAssignmentRating:(NSDictionary*)selectedParamValue AndParam:(NSArray*)selectedParam AndAssignmentResourceTxnId:(NSString*)assignmentResourceTxnId success:(void (^)(BOOL responseValue))success   failure:(void (^)(NSError *error))failure{
    AssignmentHandler *assign=[[AssignmentHandler alloc] init];
    [assign setAssignmentRating:selectedParamValue AndParam:selectedParam AndAssignmentResourceTxnId:assignmentResourceTxnId success:^(BOOL responseValue) {
        success(responseValue);
    } failure:^(NSError *error) {
        failure(error);
        
    }];

}


//upload assignment
-(void)uploadAssignment:(NSString*)videoTitle  AndVideoDesc:(NSString*)videoDesc AndVideoURL:(NSString*)videoURL AndVideoPath:(ALAsset*)videoPath andFileName:(NSString*)fileName AndAssignment:(NSString*)assignmentId  success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure

{
    AssignmentHandler *assign=[[AssignmentHandler alloc] init];
   
    [assign uploadAssignment:videoTitle AndVideoDesc:videoDesc AndVideoURL:videoURL AndVideoPath:videoPath andFileName:fileName AndAssignment:assignmentId success:^(BOOL logoutValue) {
        success(logoutValue);
    } failure:^(NSError *error) {
        failure(error);

    }];
    
}


//getMySetting
-(void)getMySetting:(NSString*)userid success:(void (^)(NSDictionary *setting))success   failure:(void (^)(NSError *error))failure
{
    SettingHandler *setting=[[SettingHandler alloc] init];
    
    [setting getMySetting:userid success:^(NSDictionary *setting) {
        success(setting);
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}


//setMySetting
-(void)setMySetting:(NSString*)userid AndSettingId:(NSString*)settingId success:(void (^)(BOOL successValue))success   failure:(void (^)(NSError *error))failure{
    
    SettingHandler *setting=[[SettingHandler alloc] init];
    
    [setting setMySetting:userid AndSettingId:settingId success:^(BOOL successValue) {
        success(successValue);
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}

//getUserFollowList
-(void)getUserFollowList:(NSString*)userid  success:(void (^)(NSMutableArray *userlist))success   failure:(void (^)(NSError *error))failure
{
    SettingHandler *setting=[[SettingHandler alloc] init];
    
    [setting getUserFollowList:userid success:^(NSMutableArray *setting) {
        success(setting);
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}


//setUnFollowUserList
-(void)setUnFollowUserList:(NSString*)userid AndUserList:(NSMutableArray*)userList success:(void (^)(BOOL successValue))success   failure:(void (^)(NSError *error))failure{
    
    SettingHandler *setting=[[SettingHandler alloc] init];
    
    [setting setUnFollowUserList:userid AndUserList:userList  success:^(BOOL successValue) {
        success(successValue);
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}
//Find the Search Relative Content
-(void)getSearchResult:(NSString*)userid AndSearchText:(NSString*)txtSearch AndCatId:(NSString*)catid AndCount:(NSString*)count success:(void (^)(NSDictionary *searchResult))success     failure:(void (^)(NSError *error))failure
{
    
    SearchHandler *setting=[[SearchHandler alloc] init];
    
    [setting getSearchResult:userid AndSearchText:txtSearch AndCatId:catid AndCount:count  success:^(NSDictionary *searchResult) {
        success(searchResult);
    } failure:^(NSError *error) {
        failure(error);
        
    }];
}
@end
