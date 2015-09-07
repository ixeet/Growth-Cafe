//
//  AppConstant.h
//  Growth Cafe
//
//  Created by Ixeet Software Solutions Pvt Limited on 8/12/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#ifndef Growth_Cafe_AppConstant_h
#define Growth_Cafe_AppConstant_h

//#define  APP_URL  @"http://191.239.57.54:8080/SLMS"
//#define  APP_URL  @"http://191.239.57.54:8080/SLMS_test"
//#define  APP_URL  @"http://192.168.0.21:8080/"
#define APP_URL [AppGlobal getServerURL]


#define kProdURL [NSString stringWithFormat:@"191.239.57.54:8080/SLMS"]
#define kGROWTHURL(url) [NSString stringWithFormat:@"http://%@" ,url]

#define MASTER_DATA_URL [NSString stringWithFormat:@"%@/rest/common/getMasterData", APP_URL]

#define USER_REGISTER_URL [NSString stringWithFormat:@"%@/rest/user/register", APP_URL]
#define USER_LOGIN_URL [NSString stringWithFormat:@"%@/rest/user/login",APP_URL]
#define USER_LOGUT_URL [NSString stringWithFormat:@"%@/rest/user/logout",APP_URL]
#define USER_FORGETPASSWORD_URL(username) [NSString stringWithFormat:@"%@/rest/user/forgetPwd/userId/%@",APP_URL,username]

//#define USER_REGISTER_URL [NSString stringWithFormat:@"%@/rest/user/register",APP_URL];
#define USER_UPDATE_PROFILE_URL [NSString stringWithFormat:@"%@/rest/user/updateProfile",APP_URL]
#define POST_USER_PROFILE_IMG_URL [NSString stringWithFormat:@"%@/rest/user/uploadProfileImage",APP_URL]

#define USER_SET_FB_URL(userName,fbId) [NSString stringWithFormat:@"%@/rest/user/setFBId/userName/%@/userFbId/%@",APP_URL,userName,fbId]
#define USER_VALIDATE_FB_URL(fbId) [NSString stringWithFormat:@"%@/rest/user/getByFBId/userFbId/%@",APP_URL,fbId]

#define USER_COURSE_URL [NSString stringWithFormat:@"%@/rest/course/getCourses",APP_URL]
#define USER_MODULE_DETAIL_URL [NSString stringWithFormat:@"%@/rest/course/getModuleDetail",APP_URL]
//Key For UserDefault
//Comment and like URL
#define CMT_ON_RESOURCE_URL [NSString stringWithFormat:@"%@/rest/course/commentOnResourse",APP_URL]
#define LIKE_ON_RESOURCE_URL(username,resourceid) [NSString stringWithFormat:@"/rest/course/likeOnResource/userName/%@/resourceId/%@",APP_URL,username,resourceid]

#define CMT_ON_CMT_URL [NSString stringWithFormat:@"%@/rest/course/commentOnComment",APP_URL]

#define LIKE_ON_CMT_URL(useremail,commentId) [NSString stringWithFormat:@"%@/rest/course/likeOnComment/userName/%@/commentId/%@",APP_URL,useremail,commentId]


//get more comment
#define GET_MORE_COMMENT_URL [NSString stringWithFormat:@"%@/rest/common/getFeedComments",APP_URL]

//get Feed  List
#define GET_UPDATE_DETAIL_URL(userid,feedid) [NSString stringWithFormat:@"%@/rest/common/getFeedDetail/userId/%@/feedId/%@",APP_URL,userid,feedid]

//get Feed  List
#define GET_UPDATE_URL [NSString stringWithFormat:@"%@/rest/common/getFeeds",APP_URL]
//comment on feed
///rest/common/commentOnFeed
//http://localhost:8080//rest/common/commentOnFeed
#define CMT_ON_FEED_URL  [NSString stringWithFormat:@"%@/rest/common/commentOnFeed",APP_URL]
//comment on comment for feed
///rest/common/commentOnComment
//	http://localhost:8080//rest/common/commentOnComment
#define CMT_ON_CMT_FEED_URL [NSString stringWithFormat:@"%@/rest/common/commentOnComment",APP_URL]
//Like on feed
///rest/common/likeOnFeed/userName/{userName}/feedId/{feedId}
//http://localhost:8080//rest/common/likeOnFeed/userName/mayankd4@ixeet.com/feedId/1
#define LIKE_ON_FEED_URL(useremail,feedId) [NSString stringWithFormat:@"%@/rest/common/likeOnFeed/userName/%@/feedId/%@",APP_URL,useremail,feedId]
//Like on comment for feed
//rest/common/likeOnComment/userName/{userName}/commentId/{commentId}
#define LIKE_ON_CMT_FEED_URL(useremail,commentId) [NSString stringWithFormat:@"%@/rest/common/likeOnComment/userName/%@/commentId/%@",APP_URL,useremail,commentId]
// get course detail for feed
//rest/course/getCourse/feedId/{feedId}
#define COURSE_DETAIL_URL(feedId) [NSString stringWithFormat:@"%@/rest/course/getCourse/feedId/%@",APP_URL,feedId]
// get module detail for feed
//rest/course/getModule/feedId/{feedId}
#define MODULE_DETAIL_URL(feedId) [NSString stringWithFormat:@"%@/rest/course/getModule/feedId/%@",APP_URL,feedId]


// get getUserDetails for feed
//rest/common/getUser/id/{userId}
#define USER_DETAIL_URL(userId) [NSString stringWithFormat:@"%@/rest/common/getUser/id/%@",APP_URL,userId]



//Assignment url
//http://192.168.0.14:8080//rest/course/getAssignments
#define GET_ASSIGNMENT_URL [NSString stringWithFormat:@"%@/rest/course/getAssignments", APP_URL]
#define POST_ASSIGNMENT_URL [NSString stringWithFormat:@"%@/rest/course/uploadResourceDetail", APP_URL]

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
#define REGISTER_SUCCESS_MSG @"Thank you for registering with Growth Cafe, your registration is pending for approval from school admin. You will be notified in email if you are approved."
#define FORGET_SUCCESS_MSG(useremail)[NSString stringWithFormat:@"Your password is sent to %@, please check SPAM folder if not received in inbox.",useremail]

// Error Msg

#define NO_INTERNET_MSG @"No Internet Connection."
#define REESTABLISH_INTERNET_MSG @"Reestablishing Lost Connection."
#define ERROR_DEFAULT_MSG @"There seems to be a problem connecting with server. Please check your network connection."
#define MISSING_LOGIN_ID_PWD @"Email and Password can't empty, please enter a valid email and password."
#define MISSING_LOGIN_ID @"Email can't be empty, please enter a valid email."
#define MISSING_PASSWORD @"Password can't be empty, please enter a valid password."
#define MISSING_PASSWORD_LENGTH @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_PASSWORD_NUMBER @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_PASSWORD_CHAR @"Short passwords are easy to guess. Try one with at least 8 characters including a alphabet and a number."
#define MISSING_FORGET_EMAIL  @"Email can't be empty, please enter a registered email id to get password."
#define MISSING_VALID_EMAIL_ID @"Enter a valid email id including '@' and '.'."
#define MISSING_VALID_URL @"Enter a valid URL."
#define MISSING_FIRST_NAME @"First name can't be empty."
#define MISSING_LAST_NAME @"Last name can't be empty."
#define MISSING_EMAIL_ID @"Email can't be empty."
#define MISSING_CNF_PASSWORD @"Confirm Password does n't match with password."
#define MISSING_CNF_PASSWORD_NOT_MATCH @"Your new password and confirm password do not match."
#define MISSING_SCHOOL @"Organization is not selected."
#define MISSING_CLASS @" Department is not selected."
#define MISSING_TITLE @" Title is not selected."
#define MISSING_Video_TITLE @"Video Title is not selected."
#define MISSING_Video_DESC @"Video description is not selected."
#define MISSING_Video_URL @"Video URL or video content is not selected."
#define MISSING_HOME @"Group is not selected."
#define MISSING_ADMIN_EMAIL @" Organization email can't be empty."
#define MISSING_COMMENT @" Comment can't be empty."
#define MISSING_ADMIN_VLID_EMAIL @" Organization email seems to be incorrect, Enter a valid email id  including '@' and '.' "

#define ORG_NOT_FILLED @"First select your Organization."
#define DEPART_NOT_FILLED @"First select your Department. "
#define MISSING_SUBMIT_FUNC @"Not implemented."
// Success Message Alert Title

#define SUCCESS_MESSAGE_ALERT_TITLE @"Info"
#define DATA_LOADING_MSG @"Please wait..."
#define UPDATE_PER_PAGE 3
#define COMMENT_PER_PAGE 5
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
typedef enum EGRIDVIEW_SCROLLDIRECTION {
    eScrollLeft = 0,
    eScrollRight = 1,
    eScrollTop = 2,
    eScrollBottom = 3,
    eScrollNone = 4
} EGRIDVIEW_SCROLLDIRECTION;
#endif
