//
//  CourseHandler.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "CourseHandler.h"
#import "AFHTTPRequestOperationManager.h"

@implementation CourseHandler
//get my Course Data
-(void)getMyCourse:(NSString*)userid AndTextSearch:(NSString*)txtSearch  success:(void (^)(NSMutableArray *courses))success   failure:(void (^)(NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":userid,
                                 @"searchText":txtSearch,
                                 };
    [manager POST:USER_COURSE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            

            //call Block function
            NSMutableArray *courseList= [[NSMutableArray alloc]init];
            
            for (NSDictionary *dicCourese in [responseDic objectForKey:@"courseList"]) {
                Courses *course= [[Courses alloc]init];
                course.startedOn=[dicCourese objectForKey:@"startedOn"];
                course.completedPercentStatus=[dicCourese objectForKey:@"completedPercentStatus"];
                course.courseId=[dicCourese objectForKey:@"courseId"];
                course.courseName=[dicCourese objectForKey:@"courseName"];
              
                NSMutableArray * arrayModule= [[NSMutableArray alloc]init];
                for (NSDictionary *dicModule in [dicCourese objectForKey:@"moduleList"]) {
                    Module *module= [[Module alloc]init];
                    module.startedOn=[dicModule objectForKey:@"startedOn"];
                    module.completedPercentStatus=[dicModule objectForKey:@"completedPercentStatus"];
                    module.moduleId=[dicModule objectForKey:@"moduleId"];
                    module.moduleName=[dicModule objectForKey:@"moduleName"];
                    [arrayModule addObject:module];
                }
                course.moduleList=arrayModule;
                [courseList addObject:course];
            }
            success(courseList);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
//get Course Detail
-(void)getCourseDetailByFeed:(NSString* )feedId success:(void (^)(NSMutableArray *courseList))success   failure:(void (^)(NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
   
    [manager GET:COURSE_DETAIL_URL(feedId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            
            //call Block function
            NSMutableArray *courseList= [[NSMutableArray alloc]init];
            
            NSDictionary *dicCourese = [responseDic objectForKey:@"courseDetail"];
                Courses *course= [[Courses alloc]init];
                course.startedOn=[dicCourese objectForKey:@"startedOn"];
                course.completedPercentStatus=[dicCourese objectForKey:@"completedPercentStatus"];
                course.courseId=[dicCourese objectForKey:@"courseId"];
                course.courseName=[dicCourese objectForKey:@"courseName"];
                
                NSMutableArray * arrayModule= [[NSMutableArray alloc]init];
                for (NSDictionary *dicModule in [dicCourese objectForKey:@"moduleList"]) {
                    Module *module= [[Module alloc]init];
                    module.startedOn=[dicModule objectForKey:@"startedOn"];
                    module.completedPercentStatus=[dicModule objectForKey:@"completedPercentStatus"];
                    module.moduleId=[dicModule objectForKey:@"moduleId"];
                    module.moduleName=[dicModule objectForKey:@"moduleName"];
                    [arrayModule addObject:module];
                }
                course.moduleList=arrayModule;
                [courseList addObject:course];
            
            success(courseList);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
//get Module Detail
-(void)getModuleDetailByFeed:(NSString* )feedId success:(void (^)(NSDictionary *moduleDetail)) success   failure:(void (^)(NSError *error))failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [manager GET:MODULE_DETAIL_URL(feedId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
                //Success Full Logout
    if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        
        
        //call Block function
        NSMutableArray *resourceList= [[NSMutableArray alloc]init];
        NSMutableArray *assignmentList= [[NSMutableArray alloc]init];
       
        responseDic=  [responseDic objectForKey:@"moduleDetail"];
        
        for (NSDictionary *dicContent in [responseDic objectForKey:@"resourceList"]) {
            Resourse *resource= [[Resourse alloc]init];
            if([dicContent objectForKey:@"likeCounts"]!=nil){
                resource.likeCounts=[NSString stringWithFormat:@"%@",  [dicContent objectForKey:@"likeCounts"] ];
            }
            if([dicContent objectForKey:@"shareCounts"]!=nil){
                
                resource.shareCounts=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"shareCounts"]];
            }
            if([dicContent objectForKey:@"commentCounts"]!=nil){
                
                resource.commentCounts=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"commentCounts"]];
            }
            resource.resourceId=[dicContent objectForKey:@"resourceId"];
            resource.islike=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"isLiked"]];
            resource.resourceImageUrl=[dicContent objectForKey:@"thumbImg"];
            resource.resourceDesc=[dicContent objectForKey:@"resourceDesc"];
            resource.resourceUrl=[dicContent objectForKey:@"resourceUrl"];
            
            resource.startedOn=[dicContent objectForKey:@"startedOn"];
            resource.completedOn=[dicContent objectForKey:@"completedOn"];
            resource.authorName=[dicContent objectForKey:@"authorName"];
            resource.authorImage=[dicContent objectForKey:@"authorImg"];
            
            NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
            for (NSDictionary *dicComment in [dicContent objectForKey:@"commentList"]) {
                Comments *comment= [[Comments alloc]init];
                 if([dicComment objectForKey:@"likeCounts"]!=nil){
                comment.likeCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"likeCounts"]];
                 }
                if([dicComment objectForKey:@"shareCounts"]!=nil){
                comment.shareCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"shareCounts"]];
                }
                 if([dicComment objectForKey:@"commentCounts"]!=nil){
                comment.commentCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"commentCounts"]];
                 }
                comment.commentId=[dicComment objectForKey:@"commentId"];
                comment.commentById=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"commentById"]];
                comment.parentCommentId=[dicComment objectForKey:@"parentCommentId"];
                comment.commentBy=[dicComment objectForKey:@"commentBy"];
                comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                comment.isLike= [NSString stringWithFormat:@"%@",[dicComment objectForKey:@"isLiked"]];
                comment.commentDate=[dicComment objectForKey:@"commentDate"];
                [arrayComments addObject:comment];
             if([[dicComment objectForKey:@"subComments"]  isKindOfClass:[NSArray class]]){
               
                for (NSDictionary *dicSubComment in [dicComment objectForKey:@"subComments"]) {
                    Comments *comment= [[Comments alloc]init];
                    if([dicSubComment objectForKey:@"likeCounts"]!=nil){
                    comment.likeCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"likeCounts"]];
                    }
                    if([dicSubComment objectForKey:@"shareCounts"]!=nil){
                        comment.shareCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"shareCounts"]];
                    }
                    if([dicSubComment objectForKey:@"commentCounts"]!=nil){

                    comment.commentCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentCounts"]];
                    }
                    comment.commentId=[dicSubComment objectForKey:@"commentId"];
                     comment.commentById=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentById"]];
                    comment.parentCommentId=[dicSubComment objectForKey:@"parentCommentId"];
                    comment.commentBy=[dicSubComment objectForKey:@"commentBy"];
                   comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                    comment.commentTxt=[dicSubComment objectForKey:@"commentTxt"];
                    comment.isLike=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"isLiked"]];
                    comment.commentDate=[dicSubComment objectForKey:@"commentDate"];
                    
                    [arrayComments addObject:comment];
                }
                 }
            }
            
            
            resource.comments=arrayComments;
            
            NSMutableArray * arrayRelatedResource= [[NSMutableArray alloc]init];
            for (NSDictionary *dicRelatedResource in [dicContent objectForKey:@"relatedVideoList"]) {
             
                
                Resourse *resource= [[Resourse alloc]init];
                resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                resource.resourceImageUrl=[dicRelatedResource objectForKey:@"thumbImg"];
                resource.uploadedDate=[dicRelatedResource objectForKey:@"uploadedDate"];
                resource.resourceTitle=[dicRelatedResource objectForKey:@"resourceName"];
                resource.authorName=[dicRelatedResource objectForKey:@"authorName"];
                [arrayRelatedResource addObject:resource];
            }
            
            resource.relatedResources=arrayRelatedResource;
            [resourceList addObject:resource];
        }
        //call Block function
        
        
        
        for (NSDictionary *dicAssign in [responseDic objectForKey:@"assignmentList"]) {
            
            Assignment  *assignment= [[Assignment   alloc]init];
            assignment.assignmentId=[dicAssign objectForKey:@"assignmentId"];
            assignment.assignmentName=[dicAssign objectForKey:@"assignmentName"];
            assignment.assignmentStatus=[dicAssign objectForKey:@"assignmentStatus"];
            assignment.assignmentSubmittedDate=[dicAssign objectForKey:@"assignmentSubmittedDate"];
            
            assignment.assignmentSubmittedBy=[dicAssign objectForKey:@"assignmentSubmittedBy"];
            for (NSDictionary *dicRelatedResource in [dicAssign objectForKey:@"attachedResources"]) {
                
                Resourse *resource= [[Resourse alloc]init];
                resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                resource.resourceUrl=[dicRelatedResource objectForKey:@"resourceUrl"];
                resource.uploadedDate=[dicRelatedResource objectForKey:@"uploadedDate"];
                assignment.resourceId= resource.resourceId;
                assignment.attachedResource=resource;
               
            }
            [assignmentList addObject:assignment];
            
            
        }
        NSMutableDictionary *moduleDetail=[[NSMutableDictionary alloc]init ];
        [moduleDetail setObject:resourceList forKey:@"resourceList"];
        [moduleDetail setObject:assignmentList forKey:@"assignmentList"];
        [moduleDetail setObject:[responseDic objectForKey:@"moduleId"] forKey:@"moduleId"];
        [moduleDetail setObject:[responseDic objectForKey:@"moduleName"]  forKey:@"moduleName"];
        success(moduleDetail);
        
        
                }
                else {
                    //call Block function
                    failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
                }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
}
#pragma Module Detail Functions
//get my module detail Data
-(void)getModuleDetail:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndSelectModule:(Module*)module AndSelectCourse:(Courses*)course success:(void (^)(NSDictionary *moduleDetail))success  failure:(void (^)(NSError *error))failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":userid,@"courseId":course.courseId,@"moduleId":module.moduleId,
                                 @"searchText":txtSearch,
                                 };
//    parameters = @{@"userId":userid,@"courseId":@"1",@"moduleId":@"1",
//                    @"searchText":@"xxx",
//                    };
//  {"userId":"1","courseId":"1","moduleId":"1","searchText":"xxx"}
    [manager POST:USER_MODULE_DETAIL_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
        
            //call Block function
            NSMutableArray *resourceList= [[NSMutableArray alloc]init];
            NSMutableArray *assignmentList= [[NSMutableArray alloc]init];

            for (NSDictionary *dicContent in [responseDic objectForKey:@"resourceList"]) {
                Resourse *resource= [[Resourse alloc]init];
                if([dicContent objectForKey:@"likeCounts"]!=nil){
                    resource.likeCounts=[NSString stringWithFormat:@"%@",  [dicContent objectForKey:@"likeCounts"] ];
                }
                if([dicContent objectForKey:@"shareCounts"]!=nil){

                resource.shareCounts=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"shareCounts"]];
                }
                if([dicContent objectForKey:@"commentCounts"]!=nil){

                resource.commentCounts=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"commentCounts"]];
                }
                resource.resourceId=[dicContent objectForKey:@"resourceId"];
                resource.islike=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"isLiked"]];
                resource.resourceImageUrl=[dicContent objectForKey:@"thumbImg"];
                resource.resourceDesc=[dicContent objectForKey:@"resourceDesc"];
                resource.resourceUrl=[dicContent objectForKey:@"resourceUrl"];
                
                resource.startedOn=[dicContent objectForKey:@"startedOn"];
                resource.completedOn=[dicContent objectForKey:@"completedOn"];
                resource.authorName=[dicContent objectForKey:@"authorName"];
                   resource.authorImage=[dicContent objectForKey:@"authorImg"];
                
                NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
                for (NSDictionary *dicComment in [dicContent objectForKey:@"commentList"]) {
                    Comments *comment= [[Comments alloc]init];
                    if([dicComment objectForKey:@"likeCounts"]!=nil){
                        comment.likeCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"likeCounts"]];
                    }
                    if([dicComment objectForKey:@"shareCounts"]!=nil){
                        comment.shareCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"shareCounts"]];
                    }
                    if([dicComment objectForKey:@"commentCounts"]!=nil){
                        comment.commentCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"commentCounts"]];
                    }
                    comment.commentId=[dicComment objectForKey:@"commentId"];
                    
                    comment.parentCommentId=[dicComment objectForKey:@"parentCommentId"];
                    comment.commentBy=[dicComment objectForKey:@"commentBy"];
                   comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                    comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                    comment.isLike= [NSString stringWithFormat:@"%@",[dicComment objectForKey:@"isLiked"]];
                    comment.commentDate=[dicComment objectForKey:@"commentDate"];
                    [arrayComments addObject:comment];
                    if([[dicComment objectForKey:@"subComments"]  isKindOfClass:[NSArray class]]){
                        
                        
                    
                    for (NSDictionary *dicSubComment in [dicComment objectForKey:@"subComments"]) {
                        Comments *comment= [[Comments alloc]init];
                        if([dicSubComment objectForKey:@"likeCounts"]!=nil){
                            comment.likeCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"likeCounts"]];
                        }
                        if([dicSubComment objectForKey:@"shareCounts"]!=nil){
                            comment.shareCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"shareCounts"]];
                        }
                        if([dicSubComment objectForKey:@"commentCounts"]!=nil){
                            
                            comment.commentCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentCounts"]];
                        }

                        comment.commentId=[dicSubComment objectForKey:@"commentId"];
                        
                        comment.parentCommentId=[dicSubComment objectForKey:@"parentCommentId"];
                        comment.commentBy=[dicSubComment objectForKey:@"commentBy"];
                        comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                        comment.commentTxt=[dicSubComment objectForKey:@"commentTxt"];
                        comment.isLike=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"isLiked"]];
                        comment.commentDate=[dicSubComment objectForKey:@"commentDate"];
                        
                        [arrayComments addObject:comment];
                    }
                    }

                }
               
              
                resource.comments=arrayComments;
               
                NSMutableArray * arrayRelatedResource= [[NSMutableArray alloc]init];
                for (NSDictionary *dicRelatedResource in [dicContent objectForKey:@"relatedVideoList"]) {
                    Resourse *resource= [[Resourse alloc]init];
                    resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                    resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                    resource.resourceImageUrl=[dicRelatedResource objectForKey:@"thumbImg"];
                    resource.uploadedDate=[dicRelatedResource objectForKey:@"uploadedDate"];
                    resource.resourceTitle=[dicRelatedResource objectForKey:@"resourceName"];
                     resource.authorName=[dicRelatedResource objectForKey:@"authorName"];
                    [arrayRelatedResource addObject:resource];
                }
                
                resource.relatedResources=arrayRelatedResource;
                [resourceList addObject:resource];
            }
            //call Block function
      
        
        
            for (NSDictionary *dicAssign in [responseDic objectForKey:@"assignmentList"]) {
                Assignment  *assignment= [[Assignment   alloc]init];
                assignment.assignmentId=[dicAssign objectForKey:@"assignmentId"];
                assignment.assignmentName=[dicAssign objectForKey:@"assignmentName"];
                assignment.assignmentStatus=[dicAssign objectForKey:@"assignmentStatus"];
                assignment.assignmentSubmittedDate=[dicAssign objectForKey:@"assignmentSubmittedDate"];
                
                assignment.assignmentSubmittedBy=[dicAssign objectForKey:@"assignmentSubmittedBy"];
                
                for (NSDictionary *dicRelatedResource in [dicAssign objectForKey:@"attachedResources"]) {
                   
                    
                    Resourse *resource= [[Resourse alloc]init];
                    resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                    resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                    resource.resourceUrl=[dicRelatedResource objectForKey:@"resourceUrl"];
                    resource.uploadedDate=[dicRelatedResource objectForKey:@"uploadedDate"];
                    assignment.resourceId= resource.resourceId;
                    assignment.attachedResource=resource;
                   
                }
                 [assignmentList addObject:assignment];
               
                
            }
            NSMutableDictionary *moduleDetail=[[NSMutableDictionary alloc]init ];
            [moduleDetail setObject:resourceList forKey:@"resourceList"];
            [moduleDetail setObject:assignmentList forKey:@"assignmentList"];
            success(moduleDetail);
            
            
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
#pragma Comment and Like on Resource
//Comment and Like on Resource
-(void)setCommentOnResource:(NSString*)resourceId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userName":[AppSingleton sharedInstance].userDetail.userEmail,@"resourceId":resourceId,@"commentText":txtComment                                 };
   
    [manager POST:CMT_ON_RESOURCE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //call Block function
            success(YES);
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
-(void)setLikeOnResource:(NSString*)resourceId  success:(void (^)(BOOL logoutValue))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *useremail=[AppSingleton sharedInstance].userDetail.userEmail;
     [manager GET:LIKE_ON_RESOURCE_URL(useremail,resourceId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //call Block function
            success(YES);
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}

#pragma Comment and Like on Comment
//Comment and Like on Comment
-(void)setCommentOnComment:(NSString*)commentId AndisFeed:(BOOL)isFeed AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure
{
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
manager.requestSerializer = [AFJSONRequestSerializer serializer];
manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *parameters = @{@"userName":[AppSingleton sharedInstance].userDetail.userEmail,@"commentId":commentId,@"commentText":txtComment                                 };
    NSString *cmturl;
    if(isFeed)
        cmturl=CMT_ON_CMT_FEED_URL;
    else
        cmturl=CMT_ON_CMT_URL;
[manager POST:cmturl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
    
    
    NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
    //Success Full Logout
    if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        
        //call Block function
        success(YES);
    }
    else {
        //call Block function
        failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
    }
    
    
    
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
    
}];

}

-(void)setLikeOnComment:(NSString*)commentId AndisFeed:(BOOL)isFeed success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *cmturl;
    NSString *useremail=[AppSingleton sharedInstance].userDetail.userEmail;
    if(isFeed)
        cmturl=LIKE_ON_CMT_FEED_URL(useremail, commentId);
    else
        cmturl=LIKE_ON_CMT_URL(useremail, commentId);
   
    [manager GET:cmturl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            //call Block function
            success(YES);
        }
        else {
            //call Block function
            failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
@end
