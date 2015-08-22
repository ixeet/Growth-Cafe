//
//  AppConstant.h
//  Growth Cafe
//
//  Created by Ixeet Software Solutions Pvt Limited on 8/12/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#ifndef Growth_Cafe_AppConstant_h
#define Growth_Cafe_AppConstant_h

#define  APP_URL  @"http://191.239.57.54:8080/"

//#define  APP_URL  @"http://192.168.0.13:8080/"

#define MASTER_DATA_URL APP_URL@"SLMS/rest/common/getMasterData"
#define USER_REGISTER_URL APP_URL@"SLMS/rest/user/register"
#define USER_LOGIN_URL APP_URL@"SLMS/rest/user/login"
#define USER_LOGUT_URL APP_URL@"SLMS/rest/user/logout"
#define USER_FORGETPASSWORD_URL(username) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/forgetPwd/userId/%@",username]

#define USER_REGISTER_URL APP_URL@"SLMS/rest/user/register"
#define USER_SET_FB_URL(userName,fbId) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/setFBId/userName/%@/userFbId/%@",userName,fbId]
#define USER_VALIDATE_FB_URL(fbId) [NSString stringWithFormat:APP_URL@"SLMS/rest/user/getByFBId/userFbId/%@",fbId]

#define USER_COURSE_URL APP_URL@"SLMS/rest/course/getCourses"
#define USER_MODULE_DETAIL_URL APP_URL@"SLMS/rest/course/getModuleDetail"
//Key For UserDefault
//Comment and like URL
#define CMT_ON_RESOURCE_URL APP_URL@"SLMS/rest/course/commentOnResourse"
#define LIKE_ON_RESOURCE_URL(username,resourceid) [NSString stringWithFormat:APP_URL@"SLMS/rest/course/likeOnResource/userName/%@/resourceId/%@",username,resourceid]

#define CMT_ON_CMT_URL APP_URL@"SLMS/rest/course/commentOnComment"

#define LIKE_ON_CMT_URL(useremail,commentId) [NSString stringWithFormat:APP_URL@"SLMS/rest/course/likeOnComment/userName/%@/commentId/%@",useremail,commentId]

//get Feed  List
#define GET_UPDATE_URL APP_URL@"SLMS/rest/common/getFeeds"
//comment on feed
//SLMS/rest/common/commentOnFeed
//http://localhost:8080/SLMS/rest/common/commentOnFeed
#define CMT_ON_FEED_URL APP_URL@"SLMS/rest/common/commentOnFeed"
//comment on comment for feed
//SLMS/rest/common/commentOnComment
//	http://localhost:8080/SLMS/rest/common/commentOnComment
#define CMT_ON_CMT_FEED_URL APP_URL@"SLMS/rest/common/commentOnComment"
//Like on feed
///rest/common/likeOnFeed/userName/{userName}/feedId/{feedId}
//http://localhost:8080/SLMS/rest/common/likeOnFeed/userName/mayankd4@ixeet.com/feedId/1
#define LIKE_ON_FEED_URL(useremail,feedId) [NSString stringWithFormat:APP_URL@"SLMS/rest/common/likeOnFeed/userName/%@/feedId/%@",useremail,feedId]
//Like on comment for feed
//rest/common/likeOnComment/userName/{userName}/commentId/{commentId}
#define LIKE_ON_CMT_FEED_URL(useremail,commentId) [NSString stringWithFormat:APP_URL@"SLMS/rest/common/likeOnComment/userName/%@/commentId/%@",useremail,commentId]
// get course detail for feed
//rest/course/getCourse/feedId/{feedId}
#define COURSE_DETAIL_URL(feedId) [NSString stringWithFormat:APP_URL@"SLMS/rest/course/getCourse/feedId/%@",feedId]
// get module detail for feed
//rest/course/getModule/feedId/{feedId}
#define MODULE_DETAIL_URL(feedId) [NSString stringWithFormat:APP_URL@"SLMS/rest/course/getModule/feedId/%@",feedId]


// get getUserDetails for feed
//rest/common/getUser/id/{userId}
#define USER_DETAIL_URL(userId) [NSString stringWithFormat:APP_URL@"SLMS/rest/common/getUser/id/%@",userId]




//Assignment url
//http://192.168.0.14:8080/SLMS/rest/course/getAssignments
#define GET_ASSIGNMENT_URL APP_URL@"SLMS/rest/course/getAssignments"
#define POST_ASSIGNMENT_URL APP_URL@"SLMS/rest/course/uploadResourceDetail"

#define key_Custom_DateFormate @"yyyy-MM-dd HH:mm:ss.S"
#define key_loginId @"LoginId"
#define key_loginPassword @"LoginPassword"
//#define key_rememberMe @"rememberMe"
//#define key_UserId @"UserId"
//#define key_UserName @"UserName"
//#define key_UserEmail @"UserEmail"
//#define key_IsLoginFromFB @"IsLoginFromFB"
#define key_FBUSERID @"FBUSERID"
//App Delegate Reference
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

//server Respond Key
#define key_severRespond_Status @"status"
#define key_severRespond_StatusMessage @"statusMessage"
#define REGISTER_SUCCESS_MSG @"Thank you for registering with SLMS, your registration is pending for approval from school admin. You will be notified in email if you are approved."
#define FORGET_SUCCESS_MSG(useremail)[NSString stringWithFormat:@"Your password is sent to %@, please check SPAM folder if not received in inbox.",useremail]

// Error Msg
#define ERROR_DEFAULT_MSG @"There seems to be a problem connecting with server. Please check your network connection."
#define MISSING_LOGIN_ID_PWD @"Email and Password can't empty, please enter a valid email and password."
#define MISSING_LOGIN_ID @"Email can't be empty, please enter a valid email."
#define MISSING_PASSWORD @"Password can't be empty, please enter a valid password."
#define MISSING_PASSWORD_LENGTH @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_PASSWORD_NUMBER @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_PASSWORD_CHAR @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_FORGET_EMAIL  @"Email can't be empty, please enter a registered email id to get password."
#define MISSING_VALID_EMAIL_ID @"Enter a valid email id including '@' and '.'."
#define MISSING_FIRST_NAME @"First name can't be empty."
#define MISSING_LAST_NAME @"Last name can't be empty."
#define MISSING_EMAIL_ID @"Email can't be empty."
#define MISSING_CNF_PASSWORD @"Confirm Password does n't match with password."
#define MISSING_CNF_PASSWORD_NOT_MATCH @"Your new password and confirm password do not match."
#define MISSING_SCHOOL @"School name is not selected."
#define MISSING_CLASS @" Class is not selected."
#define MISSING_TITLE @" Title is not selected."
#define MISSING_Video_TITLE @"Video Title is not selected."
#define MISSING_Video_DESC @"Video description is not selected."
#define MISSING_Video_URL @"Video URL or video content is not selected."
#define MISSING_HOME @"Home room is not selected."
#define MISSING_ADMIN_EMAIL @" School email can't be empty."
#define MISSING_COMMENT @" Comment can't be empty."
#define MISSING_ADMIN_VLID_EMAIL @" School email seems to be incorrect, Enter a valid email id  including '@' and '.' "


#define MISSING_SUBMIT_FUNC @"Not implemented."
// Success Message Alert Title

#define SUCCESS_MESSAGE_ALERT_TITLE @"Info"
#define DATA_LOADING_MSG @"Please wait..."

//Dropdown Enums
typedef NS_ENUM(NSInteger, AppDropdownType){
    
    SCHOOL_DATA,
    CLASS_DATA,
    ROOM_DATA,
    TITLE_DATA,
    COURSE_DATA
};
typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

typedef enum ActionOn {
    Resource,
    Comment,
    UpdateOn,
    
} ActionOn;
#endif
