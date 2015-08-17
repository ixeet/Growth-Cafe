//
//  LoginHandler.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "LoginHandler.h"
#import "AFNetworking.h"
@implementation LoginHandler


//User Login
-(void)loginWithUserName:(NSString*)userName password:(NSString*)password  success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
    
    NSDictionary *parameters = @{@"userName":userName,
                                 @"userPassword":password,
                                 };
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:USER_LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Login
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //Create Global User Detail Data Model
           // NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:responseDic];
            [AppGlobal  writeUserDataOnFile:responseDic];
            
            UserDetails  *userDetail= [[UserDetails alloc]init];
            userDetail.userId= [responseDic objectForKey:@"userId"];
            userDetail.title=[responseDic objectForKey:@"title"];
            userDetail.username=[responseDic objectForKey:@"userName"];
            userDetail.userFirstName=[responseDic objectForKey:@"firstName"];
            userDetail.userLastName=[responseDic objectForKey:@"lastName"];
            userDetail.userEmail=[responseDic objectForKey:@"emailId"];
            userDetail.classId= [responseDic objectForKey:@"classId"];
            userDetail.className=[responseDic objectForKey:@"className"];
            userDetail.homeRoomId= [responseDic objectForKey:@"homeRoomId"];
            userDetail.homeRoomName=[responseDic objectForKey:@"homeRoomName"];
            userDetail.schoolId=[responseDic objectForKey:@"schoolId"];
            userDetail.schoolName=[responseDic objectForKey:@"schoolName"];
            userDetail.adminEmailId=[responseDic objectForKey:@"adminEmail"];
            userDetail.address=[responseDic objectForKey:@"address"];
            userDetail.userFBID=[responseDic objectForKey:@"userFbId"];
            //call Block function
            success(userDetail);
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //call Block function
       failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        NSLog(@"Error: %@", error);
    }];
    
}
// get user Profile
-(void)getUserDetail:(NSString* )userid success:(void (^)(UserDetails *usrDetail))success   failure:(void (^)(NSError *error))failure{
    
    //    UserDetail *userDetail= [[UserDetail alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //    [manager.requestSerializer setValue:[AppGlobal getValueInDefault:@""]  forHTTPHeaderField:@"MobileUserToken"];
    //    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",[userDetail.userId longValue]] forHTTPHeaderField:@"UserId"];
    
    
    [manager GET:USER_DETAIL_URL(userid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Login
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            // set the drop down master data;
            //            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:responseDic];
            //            [AppGlobal  setDropdownList:USER_DATA andData:userData];
            [AppGlobal  writeUserDataOnFile:responseDic];
            
            //Create Global User Detail Data Model
            
            UserDetails  *userDetail= [[UserDetails alloc]init];
            userDetail.userId= [responseDic objectForKey:@"userId"];
            userDetail.title=[responseDic objectForKey:@"title"];
            userDetail.username=[responseDic objectForKey:@"userName"];
            userDetail.userFirstName=[responseDic objectForKey:@"firstName"];
            userDetail.userLastName=[responseDic objectForKey:@"lastName"];
            userDetail.userEmail=[responseDic objectForKey:@"emailId"];
            userDetail.classId= [responseDic objectForKey:@"classId"];
            userDetail.className=[responseDic objectForKey:@"className"];
            userDetail.homeRoomId= [responseDic objectForKey:@"homeRoomId"];
            userDetail.homeRoomName=[responseDic objectForKey:@"homeRoomName"];
            userDetail.schoolId=[responseDic objectForKey:@"schoolId"];
            userDetail.schoolName=[responseDic objectForKey:@"schoolName"];
            userDetail.address=[responseDic objectForKey:@"address"];
            userDetail.adminEmailId=[responseDic objectForKey:@"adminEmail"];
            userDetail.userFBID=[responseDic objectForKey:@"userFbId"];
            //call Block function
            success(userDetail);
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //call Block function
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        NSLog(@"Error: %@", error);
    }];
    
}
//User Logout
-(void)logout:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    UserDetails *userDetail= [[UserDetails alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[AppGlobal getValueInDefault:@""]  forHTTPHeaderField:@"MobileUserToken"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",[userDetail.userId longValue]] forHTTPHeaderField:@"UserId"];
    
    
    [manager GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //call Block function
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
//User Forgetpassword 
-(void)ForgetPasswordWithUserName:(NSString*)userName success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [manager GET:USER_FORGETPASSWORD_URL(userName) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //call Block function
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


//User Register
 -(void)registerWithUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
         user.address=@"";
         
         NSDictionary *parameters = @{@"userName":user.userEmail,@"firstName":user.userFirstName,@"lastName":user.userLastName,@"emailId":user.userEmail,@"adminEmailId":user.adminEmailId,@"schoolId":user.schoolId,@"schoolName":user.schoolName,@"address":user.address,@"classId":user.classId,@"className":user.className,@"homeRoomId":user.homeRoomId,@"homeRoomName":user.homeRoomName,@"title":user.title,@"userPassword":user.userPassword};
     
         
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
         manager.requestSerializer = [AFJSONRequestSerializer serializer];
         manager.responseSerializer = [AFJSONResponseSerializer serializer];
         [manager POST:USER_REGISTER_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
             
             //Success Full Login
             if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
                 
                 //Create new  User Detail Data Model
                // NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:responseDic];
                 [AppGlobal  writeUserDataOnFile:responseDic];
                 
                 user.userId= [responseDic objectForKey:@"userId"];
                                 //call Block function
                 success(user);
             }
             else {
                 //call Block function
                 failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
             }

             
             
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             //call Block function
             failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
             NSLog(@"Error: %@", error);
         }];
         
     }
//User Validation From FB

-(void)FBloginWithUserID:(NSString*)userid  success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    
//    UserDetail *userDetail= [[UserDetail alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    [manager.requestSerializer setValue:[AppGlobal getValueInDefault:@""]  forHTTPHeaderField:@"MobileUserToken"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",[userDetail.userId longValue]] forHTTPHeaderField:@"UserId"];
    
    
    [manager GET:USER_VALIDATE_FB_URL(userid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Login
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            // set the drop down master data;
//            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:responseDic];
//            [AppGlobal  setDropdownList:USER_DATA andData:userData];
            [AppGlobal  writeUserDataOnFile:responseDic];
            
            //Create Global User Detail Data Model
            
            UserDetails  *userDetail= [[UserDetails alloc]init];
            userDetail.userId= [responseDic objectForKey:@"userId"];
            userDetail.title=[responseDic objectForKey:@"title"];
            userDetail.username=[responseDic objectForKey:@"userName"];
            userDetail.userFirstName=[responseDic objectForKey:@"firstName"];
            userDetail.userLastName=[responseDic objectForKey:@"lastName"];
            userDetail.userEmail=[responseDic objectForKey:@"emailId"];
            userDetail.classId= [responseDic objectForKey:@"classId"];
            userDetail.className=[responseDic objectForKey:@"className"];
            userDetail.homeRoomId= [responseDic objectForKey:@"homeRoomId"];
            userDetail.homeRoomName=[responseDic objectForKey:@"homeRoomName"];
            userDetail.schoolId=[responseDic objectForKey:@"schoolId"];
            userDetail.schoolName=[responseDic objectForKey:@"schoolName"];
            userDetail.address=[responseDic objectForKey:@"address"];
            userDetail.adminEmailId=[responseDic objectForKey:@"adminEmail"];
            userDetail.userFBID=[responseDic objectForKey:@"userFbId"];
            //call Block function
            success(userDetail);
        }
       else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //call Block function
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        NSLog(@"Error: %@", error);
    }];
    
}
//User Set FB  with user id

-(void)SetFBloginWithUserID:(NSString*)username FBID:(NSString*)fbid success:(void (^)(bool status))success  failure:(void (^)(NSError *error))failure{
    
    UserDetails *userDetail= [[UserDetails alloc]init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[AppGlobal getValueInDefault:@""]  forHTTPHeaderField:@"MobileUserToken"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",[userDetail.userId longValue]] forHTTPHeaderField:@"UserId"];
    
    
    [manager GET:USER_SET_FB_URL(username, fbid) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Login
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //Create Global User Detail Data Model
       
            //call Block function
            success(YES);
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //call Block function
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        NSLog(@"Error: %@", error);
    }];
    
}
//get Master Data
-(void)getMasterData:(void (^)(BOOL success))success  failure:(void (^)(NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [manager GET:MASTER_DATA_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            // set the drop down master data;
            [AppGlobal  setDropdownList:SCHOOL_DATA andData:[responseDic objectForKey:@"schoolList"]];
            //call Block function
            success(YES);
        
           
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }

        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];}
@end
