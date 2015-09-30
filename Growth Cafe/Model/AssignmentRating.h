//
//  AssignmentRating.h
//  Growth Cafe
//
//  Created by Mayank on 24/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssignmentRating : NSObject
@property (nonatomic,strong) NSDictionary   *ratingParam;
@property (nonatomic,strong) NSMutableArray   *ratingParamValues;
@property (nonatomic,strong) NSMutableArray   *ratingColorValues;
@end
