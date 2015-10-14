//
//  Response.h
//  sLMS
//
//  Created by Mayank on 14/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject
@property (nonatomic,strong) NSNumber* status;
@property (nonatomic,strong) NSString* statusMessage;
@end