//
//  SettingHandler.m
//  Growth Cafe
//
//  Created by Mayank on 01/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "SettingHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>
@implementation SettingHandler
//getMySetting
-(void)getMySetting:(NSString*)userid success:(void (^)(NSDictionary *setting))success   failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:GET_FEED_ACCESSTYPE(userid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            
            //call Block function
            NSMutableDictionary *dicSetting= [[NSMutableDictionary alloc]init];
            int selectValue=[[responseDic objectForKey:@"userAccessTypeId"]intValue];
            if(selectValue==0)
            {
                selectValue=4;
            }
            [dicSetting setValue:[NSString stringWithFormat:@"%d",selectValue] forKey:@"selected"];
            
            success(dicSetting);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}


//setMySetting
-(void)setMySetting:(NSString*)userid AndSettingId:(NSString*)settingId success:(void (^)(BOOL successValue))success   failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager GET:SET_FEED_ACCESSTYPE(userid,settingId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            
            
            success(YES);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
}

//getUserFollowList
-(void)getUserFollowList:(NSString*)userid  success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:GET_FEED_USERS(userid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            
            //call Block function
            NSMutableArray *userList= [[NSMutableArray alloc]init];
            for (NSDictionary *dicUser  in [responseDic objectForKey:@"usersList"]) {
                
                UserDetails  *userDetail= [[UserDetails alloc]init];
                userDetail.userId= [dicUser objectForKey:@"userId"];
                userDetail.userImage=[dicUser objectForKey:@"profileImage"];
                userDetail.username=[dicUser objectForKey:@"userName"];
                userDetail.isFollowUpAllowed=[dicUser objectForKey:@"isFollowUpAllowed"];
                [userList addObject:userDetail];
            }
            success(userList);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
}


//setUnFollowUserList
-(void)setUnFollowUserList:(NSString*)userid AndUserList:(NSMutableArray*)userList success:(void (^)(BOOL successValue))success   failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableArray *userFollowList=[[NSMutableArray alloc]init];
    for (UserDetails *user in userList) {
        NSMutableDictionary *tempDicM=[[NSMutableDictionary alloc]init];
        [tempDicM setObject:user.userId forKey:@"userid"];
        [tempDicM setObject:[NSString stringWithFormat:@"%@", user.isFollowUpAllowed] forKey:@"isFollowUpAllowed"];
        [userFollowList addObject:tempDicM];
        
    }
    NSDictionary *parameters = @{@"userid":userid,@"usersList":userFollowList                                 };
    
    //{"userid":"22","usersList":[{"userid":"1","isFollowUpAllowed":"0"},{"userid":"2","isFollowUpAllowed":"1"},{"userid":"3","isFollowUpAllowed":"0"}]}
    
    [manager POST:SET_USER_FOLLOW_STATUS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            
            //call Block function
            
            success(YES );
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
}
@end
