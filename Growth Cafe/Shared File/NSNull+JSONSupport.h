//
//  NSNull+JSONSupport.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSNull (JSONSupport)
-(NSString*) stringValue;
-(NSNumber*) numberValue;
-(float) floatValue;
-(double) doubleValue;
-(BOOL) boolValue;
-(int) intValue;
-(int) integerValue;
-(long) longValue;
-(long long) longLongValue;
-(unsigned long long) unsignedLongLongValue;
@end
