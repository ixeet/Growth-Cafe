//
//  UserDetail.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetails : NSObject
@property (nonatomic,strong) NSNumber* userId;
@property (nonatomic,strong) NSString* title;
@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* userFirstName;
@property (nonatomic,strong) NSString* userLastName;
@property (nonatomic,strong) NSString* userRole;
@property (nonatomic,strong) NSString* userEmail;
@property (nonatomic,strong) NSString* userPassword;
@property (nonatomic,strong) NSString* userFBID;
@property (nonatomic,strong) NSString* schoolId;
@property (nonatomic,strong) NSString* schoolName;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSString* classId;
@property (nonatomic,strong) NSString* className;
@property (nonatomic,strong) NSString* adminEmailId;
@property (nonatomic,strong) NSString* homeRoomId;
@property (nonatomic,strong) NSString* homeRoomName;

@property (nonatomic,strong) NSString* userImage;
@property (nonatomic,strong) NSData* userImageData;
@end

