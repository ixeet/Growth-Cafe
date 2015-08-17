//
//  FeedHandler.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedHandler : NSObject
//get Updates Data
-(void)getUpdates:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *updates))success   failure:(void (^)(NSError *error))failure;


#pragma Comment and Like on Update
//Comment and Like on Update
-(void)setCommentOnUpdate:(NSString*)updateId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;
-(void)setLikeOnUpdate:(NSString*)updateId  success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure;


@end
