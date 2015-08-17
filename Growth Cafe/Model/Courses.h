//
//  Courses.h
//  sLMS
//
//  Created by Mayank on 17/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Courses : NSObject

@property (nonatomic,strong) NSString* startedOn;
@property (nonatomic,strong) NSString* completedPercentStatus;
@property (nonatomic,strong) NSString* courseId;
@property (nonatomic,strong) NSString* courseName;
@property (nonatomic,strong) NSMutableArray* moduleList;

@end
