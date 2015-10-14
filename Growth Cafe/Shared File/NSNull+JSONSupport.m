//
//  NSNull+JSONSupport.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.

#import "NSNull+JSONSupport.h"

@implementation NSNull (JSONSupport)

-(NSString*) stringValue {
    return @"";
}

-(NSNumber*) numberValue {
    return nil;
}

-(float) floatValue {
    return 0;
}

-(double) doubleValue {
    return 0;
}

-(BOOL) boolValue {
    return NO;
}

-(int) intValue {
    return 0;
}
-(int) integerValue {
    return 0;
}
-(long) longValue {
    return 0;
}

-(long long) longLongValue {
    return 0;
}

-(unsigned long long) unsignedLongLongValue {
    return 0;
}

-(int) count {
    return 0;
}

-(id)objectAtIndex:(int)index
{
    return nil;
}
-(id)objectForKey:(NSString*)key
{
    return nil;
}
@end
