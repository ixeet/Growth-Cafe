//
//  SettingHandler.h
//  Growth Cafe
//
//  Created by Mayank on 01/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingHandler : NSObject
//getMySetting
-(void)getMySetting:(NSString*)userid AndSettingId:(NSString*)settingId success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure;


//setMySetting
-(void)setMySetting:(NSString*)userid AndSettingId:(NSString*)settingId success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure;

//getUserFollowList
-(void)getUserFollowList:(NSString*)userid  success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure;


//setUnFollowUserList
-(void)setUnFollowUserList:(NSString*)userid AndUserList:(NSMutableArray*)userList success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure;
@end
