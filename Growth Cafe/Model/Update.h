//
//  Update.h
//  sLMS
//
//  Created by Mayank on 06/08/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Update : NSObject

@property (nonatomic,strong) NSString*  updateId;
@property (nonatomic,strong) NSString*  updatetime;
@property (nonatomic,strong) NSString*  updateCreatedBy;
@property (nonatomic,strong) NSString*  updateCreatedByImage;
@property (nonatomic,strong) NSData*    updateCreatedByImageData;
@property (nonatomic,strong) NSString*  updateTitle;
@property (nonatomic,strong) NSArray*   updateTitleArray;
@property (nonatomic,strong) NSString*  updateDesc;
@property (nonatomic,strong) Resourse*  resource;
@property (nonatomic,strong) NSString*  likeCount;
@property (nonatomic,strong) NSMutableArray*  comments;
@property (nonatomic,strong) NSString*  commentCount;
@property (nonatomic,strong) NSString*  shareCount;
@property (nonatomic,strong) NSString*  isLike;
@property (nonatomic,assign) BOOL       isExpend;
@property (nonatomic,strong) UserDetails *user;
@end
