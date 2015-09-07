//
//  AppSingleton.h
//  Quote2Cash
//
//  Created by Mayank Dixit on 5/18/15.
//  Copyright (c) 2015 Pyramid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Update.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AppSingleton : NSObject

+ (AppSingleton *)sharedInstance;

@property(nonatomic,strong) UserDetails *userDetail;
@property(nonatomic,assign) BOOL isUserLoggedIn;
@property(nonatomic,assign) BOOL isUserFBLoggedIn;
@property(nonatomic) BOOL isKeepMeloggedIn;
@property(nonatomic,strong) Update *updatedUpdate;

@end
