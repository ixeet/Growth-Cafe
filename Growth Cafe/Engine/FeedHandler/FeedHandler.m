//
//  FeedHandler.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "FeedHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Update.h"
#import "Comments.h"

@implementation FeedHandler
//get Updates Data
-(void)getUpdates:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *updates))success   failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":userid,
                                 @"searchText":txtSearch,
                                 };
    
    [manager POST:GET_UPDATE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //        //Success Full Logout
        //        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        //
        
        //call Block function
        NSMutableArray *updateList= [[NSMutableArray alloc]init];
        for (NSDictionary *dicContent in [responseDic objectForKey:@"feedList"]) {
            Update *update= [[Update alloc]init];
            update.likeCount=[NSString stringWithFormat:@"%@",  [dicContent objectForKey:@"likeCounts"] ];
            update.shareCount=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"shareCounts"]];
            update.commentCount=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"commentCounts"]];
            
            update.isLike=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"isLiked"]];
         
            update.updateId=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedId"]];
            update.updateTitle=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedText"]];
            update.updateTitleArray=[dicContent objectForKey:@"feedTextArray"];
            if([dicContent objectForKey:@"user"]!=nil)
            {
                NSDictionary *userdic=[dicContent objectForKey:@"user"];
                UserDetails *user= [[UserDetails alloc]init];
                user.userId=[userdic objectForKey:@"feedTextArray"];
                user.userFBID=[userdic objectForKey:@"userFbId"];
                user.username  =[userdic objectForKey:@"userName"];
                user.userFirstName=[userdic objectForKey:@"firstName"];
                user.userLastName=[userdic objectForKey:@"lastName"];
                user.userEmail=[userdic objectForKey:@"emailId"];
                user.title=[userdic objectForKey:@"title"];
                user.userImage=[userdic objectForKey:@"profileImage"];
                update.updateCreatedBy=user.userFirstName;
                update.updateCreatedByImage=user.userImage;
            }
           if([dicContent objectForKey:@"resource"]!=nil)
           {
               NSDictionary *resourseDic= [dicContent objectForKey:@"resource"];
               Resourse *resource= [[Resourse alloc]init];
               resource.resourceId=[resourseDic objectForKey:@"resourceId"];
               
               resource.resourceImageUrl=[resourseDic objectForKey:@"thumbImg"];
               resource.resourceDesc=[resourseDic objectForKey:@"resourceName"];
               resource.resourceUrl=[resourseDic objectForKey:@"resourceUrl"];
               resource.startedOn=[resourseDic objectForKey:@"startedOn"];
               resource.completedOn=[resourseDic objectForKey:@"completedOn"];
               resource.authorName=[resourseDic objectForKey:@"authorName"];
               resource.authorImage=[resourseDic objectForKey:@"authorImg"];
               update.resource=resource;
           }
            NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
            for (NSDictionary *dicComment in [dicContent objectForKey:@"feedCommentsList"]) {
                Comments *comment= [[Comments alloc]init];
                comment.likeCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"likeCounts"]];
                comment.shareCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"shareCounts"]];
                comment.commentCounts=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"commentCounts"]];
                comment.commentId=[dicComment objectForKey:@"commentId"];
                
                comment.parentCommentId=[dicComment objectForKey:@"parentCommentId"];
                comment.commentBy=[dicComment objectForKey:@"commentBy"];
                //comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                comment.isLike=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"isLiked"]];
                comment.commentDate=[dicComment objectForKey:@"commentDate"];
                //find sub comment and add in main
               // comment.commentDate=[dicComment objectForKey:@"subComments"];
                [arrayComments addObject:comment];
                NSArray *subcomment=[dicComment objectForKey:@"subComments"];
                 if ( [dicComment objectForKey:@"subComments"]!=nil) {
                for (NSDictionary *dicSubComment in [dicComment objectForKey:@"subComments"]) {
                    Comments *comment= [[Comments alloc]init];
                    comment.likeCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"likeCounts"]];
                    comment.shareCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"shareCounts"]];
                    comment.commentCounts=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentCounts"]];
                    comment.commentId=[dicSubComment objectForKey:@"commentId"];
                    
                    comment.parentCommentId=[dicSubComment objectForKey:@"parentCommentId"];
                    comment.commentBy=[dicSubComment objectForKey:@"commentBy"];
                    //comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
                    comment.commentTxt=[dicSubComment objectForKey:@"commentTxt"];
                    comment.isLike=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"isLiked"]];
                    comment.commentDate=[dicSubComment objectForKey:@"commentDate"];
                    
                    [arrayComments addObject:comment];
                }
                 }
            }
            
            update.comments=arrayComments;
            [updateList addObject:update];
        }
        //call Block function
      success(updateList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
#pragma Comment and Like on Update
//Comment and Like on Update
-(void)setCommentOnUpdate:(NSString*)updateId  AndCommentText:(NSString*)txtComment success:(void (^)(BOOL logoutValue))success failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userName":[AppSingleton sharedInstance].userDetail.userEmail,@"feedId":updateId,@"commentText":txtComment                                 };
  
    [manager POST:CMT_ON_FEED_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
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
-(void)setLikeOnUpdate:(NSString*)updateId  success:(void (^)(BOOL logoutValue))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *useremail=[AppSingleton sharedInstance].userDetail.userEmail;
    [manager GET:LIKE_ON_FEED_URL(useremail,updateId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        
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
