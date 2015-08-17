//
//  Resourse.h
//  sLMS
//
//  Created by Mayank on 21/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Resourse : NSObject

@property (nonatomic,strong) NSString  *islike;
@property (nonatomic,strong) NSString * likeCounts;
@property (nonatomic,strong) NSString * commentCounts;
@property (nonatomic,strong) NSString* shareCounts;
@property (nonatomic,strong) NSString* resourceId;
@property (nonatomic,strong) NSString* resourceTitle;
@property (nonatomic,strong) NSString* resourceUrl;
@property (nonatomic,strong) NSString* resourceImageUrl;
@property (nonatomic,strong) NSData* resourceImageData;
@property (nonatomic,strong) NSString* resourceDesc;
@property (nonatomic,strong) NSString* startedOn;
@property (nonatomic,strong) NSString* completedOn;
@property (nonatomic,strong) NSString* uploadedDate;
@property (nonatomic,strong) NSString* authorName;
@property (nonatomic,strong) NSString* authorImage;
@property (nonatomic,strong) NSMutableArray* relatedResources;
@property (nonatomic,strong) NSMutableArray* comments;
@end
