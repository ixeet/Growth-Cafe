//
//  AppEngine.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHandler.h"
#import "UserDetail.h"
#import "Courses.h"
#import "Module.h"
#import "Resourse.h"
#import "Comments.h"
#import "Assignment.h"
#import "Update.h"
#import <AssetsLibrary/AssetsLibrary.h>
@protocol ApppEngineDelegate <NSObject>

@optional

@end
@interface AppEngine : NSObject
//User Login with credentials (user id and password)
-(void)loginWithUserName:(NSString*)userName password:(NSString*)password rememberMe:(BOOL)rememberMe success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
#pragma mark - logout

//User Logout
-(void)logout:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;
//User Register
-(void)registerWithUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
//Update user Profile
-(void)updateUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
//Update user Profile Image
-(void)updateUserImage:(UIImage*)image success:(void (^)(BOOL successValue))success  failure:(void (^)(NSError *error))failure;

-(void)ForgetPasswordWithUserName:(NSString*)userName success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;

//FB Varification by Server
-(void)FBloginWithUserID:(NSString*)userid success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure;
//User Set FB  with user id
-(void)SetFBloginWithUserID:(NSString*)username FBID:(NSString*)fbid success:(void (^)(bool status))success  failure:(void (^)(NSError *error))failure;
//get Master Data
-(void)getMasterData:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure;

#pragma Courses Functions
//get my Course Data
-(void)getMyCourse:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *courses))success  failure:(void (^)(NSError *error))failure;

#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)course success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure;


#pragma Comment and Like on Update
-(void)getUpdates:(NSString*)userid  AndTextSearch:(NSString*)txtSearch Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)(NSMutableDictionary *updates))success   failure:(void (^)(NSError *error))failure;
//get Updates detail
-(void)getUpdatesDetail:(NSString*)updateId success:(void (^)(Update *updates))success   failure:(void (^)(NSError *error))failure;
//get more comments
-(void)getMoreComment:(NSString*)updateId  Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)( NSMutableDictionary *comments))success   failure:(void (^)(NSError *error))failure;
    
//Comment and Like on Resource
-(void)setCommentOnUpdate:(NSString*)updateId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;
-(void)setLikeOnUpdate:(NSString*)updateId  success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;
//get user Profile
-(void)getUserDetail:(NSString* )userid success:(void (^)(UserDetails *usrDetail))success   failure:(void (^)(NSError *error))failure;
//get Course Detail
-(void)getCourseDetail:(NSString* )feedId success:(void (^)(NSMutableArray *courseList))success   failure:(void (^)(NSError *error))failure;
//get Module Detail
-(void)getModuleDetail:(NSString* )feedId success:(void (^)(NSDictionary *moduleDetail))success   failure:(void (^)(NSError *error))failure;

#pragma Comment and Like on Resource
//Comment and Like on Resource
-(void)setCommentOnResource:(NSString*)resourceId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;
-(void)setLikeOnResource:(NSString*)resourceId  success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;

#pragma Comment and Like on Comment
//Comment and Like on Comment
-(void)setCommentOnComment:(NSString*)commentId AndisFeed:(BOOL)isFeed  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;
-(void)setLikeOnComment:(NSString*)commentId AndisFeed:(BOOL)isFeed success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;


#pragma Assignment Detail Functions
//get my Assignment Data
-(void)getMyAssignments:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure;


////upload assignment
-(void)uploadAssignment:(NSString*)videoTitle  AndVideoDesc:(NSString*)videoDesc AndVideoURL:(NSString*)videoURL AndVideoPath:(ALAsset*)videoPath andFileName:(NSString*)fileName AndAssignment:(NSString*)assignmentId success:(void (^)(BOOL logoutValue)) success  failure:(void (^)(NSError *error))failure;



@end
