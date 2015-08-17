//
//  Module.h
//  sLMS
//
//  Created by Mayank on 17/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Module : NSObject
@property (nonatomic,strong) NSString * startedOn;
@property (nonatomic,strong) NSString* completedPercentStatus;
@property (nonatomic,strong) NSString* moduleId;
@property (nonatomic,strong) NSString* moduleName;
@end
