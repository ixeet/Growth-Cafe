//
//  AppSingleton.m
//  Quote2Cash
//
//  Created by Mayank Dixit on 5/18/15.
//  Copyright (c) 2015 Pyramid. All rights reserved.
//

#import "AppSingleton.h"

@implementation AppSingleton

@synthesize userDetail,isUserFBLoggedIn,isUserLoggedIn,isKeepMeloggedIn,updatedUpdate;

+ (AppSingleton *)sharedInstance {
    static dispatch_once_t once;
    static AppSingleton *instance;
    
    dispatch_once(&once, ^{
        instance = [[AppSingleton alloc] init];
       
          });
    return instance;
}


- (id)init
{
    self = [super init];
    if ( self )
    {
        userDetail=[[UserDetails alloc] init];
        
    }
    return self;
}


@end
