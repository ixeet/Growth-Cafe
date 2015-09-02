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
            userDetail.userImage=[responseDic objectForKey:@"profileImage"];
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
            responseDic= [responseDic objectForKey:@"userDetail"];
          //  [AppGlobal  writeUserDataOnFile:responseDic];
            
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
            userDetail.userImage=[responseDic objectForKey:@"profileImage"];
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
//Update user Profile
-(void)updateUserDetail:(UserDetails*)user success:(void (^)(UserDetails *userDetail))success  failure:(void (^)(NSError *error))failure{
    user.address=@"";
    
    NSDictionary *parameters = @{@"userid":user.userId,@"userName":user.userEmail,@"firstName":user.userFirstName,@"lastName":user.userLastName,@"title":user.title,@"emailId":user.userEmail};


    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:USER_UPDATE_PROFILE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Login
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //Create new  User Detail Data Model
            // NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:responseDic];
          //  [AppGlobal  writeUserDataOnFile:responseDic];
        //user.userId= [responseDic objectForKey:@"userId"];
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
//Update user Profile Image
-(void)updateUserImage:(UIImage*)image success:(void (^)(BOOL successValue))success  failure:(void (^)(NSError *error))failure{
  
    NSData* userImageData = UIImageJPEGRepresentation(image, 0.8);
    
    
    
    NSString *BoundaryConstant = @"---------------------------14737809831466499882746641449";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:POST_USER_PROFILE_IMG_URL]];
    UserDetails * objUser=[AppSingleton  sharedInstance].userDetail;
    
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    NSMutableDictionary *_params=[[NSMutableDictionary alloc]init];
    [_params setObject:objUser.userEmail forKey:@"userName"];
    
    
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"logo@2x.png"], 1.0);
    if (userImageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"output.png\"\r\n", @"profilePhoto"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:userImageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    NSError* error;
    //    NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:returnData
    //                                                         options:kNilOptions
    //                                                           error:&error];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil){
             NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:&error];
             // NSLog(@"%@",returnString);
             //Success Full Logout
             if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
                 [AppSingleton sharedInstance].userDetail.userImage=[responseDic objectForKey:@"uploadLocation"];
                 success(YES);
             }else{
                 failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
             }
             
         }
         else if (error != nil)
             failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
     }];
    
    
}

@end
