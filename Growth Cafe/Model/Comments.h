//
//  Comments.h
//  sLMS
//
//  Created by Mayank on 21/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject

@property (nonatomic,strong) NSString * likeCounts;
@property (nonatomic,strong) NSString * commentCounts;
@property (nonatomic,strong) NSString* shareCounts;
@property (nonatomic,strong) NSString* commentId;
@property (nonatomic,strong) NSString* parentCommentId;
@property (nonatomic,strong) NSString* commentBy;
@property (nonatomic,strong) NSString* commentById;
@property (nonatomic,strong) NSString* commentByImage;
@property (nonatomic,strong) NSData* commentByImageData;
@property (nonatomic,strong) NSString* commentTxt;
@property (nonatomic,strong) NSString* commentDate;
@property (nonatomic,strong) NSString *isLike;
@end
