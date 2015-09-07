//
//  FeedHandler.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Update.h"
@interface FeedHandler : NSObject
//get Updates Data
-(void)getUpdates:(NSString*)userid  AndTextSearch:(NSString*)txtSearch Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)(NSMutableDictionary *updates))success   failure:(void (^)(NSError *error))failure;
//get Updates detail
-(void)getUpdatesDetail:(NSString*)updateId success:(void (^)(Update *updates))success   failure:(void (^)(NSError *error))failure;

#pragma Comment and Like on Update
//Comment and Like on Update
-(void)setCommentOnUpdate:(NSString*)updateId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;
-(void)setLikeOnUpdate:(NSString*)updateId  success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;


//get more comments
-(void)getMoreComment:(NSString*)updateId  Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)( NSMutableDictionary *comments))success   failure:(void (^)(NSError *error))failure;

@end
