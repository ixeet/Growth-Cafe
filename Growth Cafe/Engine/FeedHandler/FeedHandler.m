//
//  FeedHandler.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "FeedHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import "Comments.h"

@implementation FeedHandler
//get Updates Data
-(void)getUpdates:(NSString*)userid  AndTextSearch:(NSString*)txtSearch Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)(NSMutableDictionary *updates))success   failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":userid,
                                 @"searchText":txtSearch,@"offset":[NSString stringWithFormat:@"%d",offset],@"noOfRecords":[NSString stringWithFormat:@"%d",noOfRecords]
                                 };
  
    [manager POST:GET_UPDATE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //        //Success Full Logout
        //        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        //
        
        //call Block function
        NSMutableArray *updateList= [[NSMutableArray alloc]init];
        NSMutableDictionary *dicUpdate= [[NSMutableDictionary alloc]init];
        NSString *totalRecords=[responseDic objectForKey:@"totalRecords"];
        for (NSDictionary *dicContent in [responseDic objectForKey:@"feedList"]) {
            Update *update= [[Update alloc]init];
            if([dicContent objectForKey:@"likeCounts"]!=nil){
            update.likeCount=[NSString stringWithFormat:@"%@",  [dicContent objectForKey:@"likeCounts"] ];
            }
            if([dicContent objectForKey:@"shareCounts"]!=nil){
            update.shareCount=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"shareCounts"]];
              
            }
            if([dicContent objectForKey:@"commentCounts"]!=nil){
                
            update.commentCount=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"commentCounts"]];
            }
            update.isLike=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"isLiked"]];
         
            update.updateId=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedId"]];
            update.updateTitle=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedText"]];
            update.updateTitleArray=[dicContent objectForKey:@"feedTextArray"];
            if([dicContent objectForKey:@"user"]!=nil)
            {
                NSDictionary *userdic=[dicContent objectForKey:@"user"];
                UserDetails *user= [[UserDetails alloc]init];
                user.userId=[userdic objectForKey:@"userId"];
                user.userFBID=[userdic objectForKey:@"userFbId"];
                user.username  =[userdic objectForKey:@"userName"];
                user.userFirstName=[userdic objectForKey:@"firstName"];
                user.userLastName=[userdic objectForKey:@"lastName"];
                user.userEmail=[userdic objectForKey:@"emailId"];
                user.title=[userdic objectForKey:@"title"];
                user.userImage=[userdic objectForKey:@"profileImage"];
                update.updateCreatedBy=[NSString stringWithFormat:@"%@ %@" ,user.userFirstName,user.userLastName];
                update.user =user;
                update.updateCreatedByImage=user.userImage;
//                if(update.updateCreatedByImage!=nil){
//                    
//                    
//                    if (update.updateCreatedByImageData==nil) {
//                        NSURL *imageURL = [NSURL URLWithString:update.updateCreatedByImage];
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                            update.updateCreatedByImageData  = [NSData dataWithContentsOfURL:imageURL];
//                           
//                        });
//                    }
//                }
                
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
//               if (update.resource!=nil) {
//                   
//                   if(update.resource.resourceImageUrl!=nil){
//                       if (update.resource.resourceImageData==nil) {
//                           NSURL *imageURL = [NSURL URLWithString:update.resource.resourceImageUrl];
//                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                               update.resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
//                               
//                           });
//                       }
//                   }
//               }
               
           }
            NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
             NSMutableArray * arrayTempComments= [dicContent objectForKey:@"feedCommentsList"];
            
            for (NSDictionary *dicComment in arrayTempComments) {
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
//                if(comment.commentByImage!=nil){
//                    if(comment.commentByImageData==nil)
//                    {
//                        
//                        NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
//                        
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                            comment.commentByImageData=imageData;
//                            
//                        });
//                    }
//                }

                
                comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                comment.isLike=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"isLiked"]];
                comment.commentDate=[dicComment objectForKey:@"commentDate"];
                //find sub comment and add in main
               // comment.commentDate=[dicComment objectForKey:@"subComments"];
                [arrayComments addObject:comment];
                NSArray *subcomment=[dicComment objectForKey:@"subComments"];
                if (subcomment  !=nil) {
                for (NSDictionary *dicSubComment in subcomment) {
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
                    comment.commentById=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentById"]];
                    comment.commentId=[dicSubComment objectForKey:@"commentId"];
                    
                    comment.parentCommentId=[dicSubComment objectForKey:@"parentCommentId"];
                    comment.commentBy=[dicSubComment objectForKey:@"commentBy"];
                    comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
//                    if(comment.commentByImage!=nil){
//                        if(comment.commentByImageData==nil)
//                        {
//                            
//                            NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
//                            
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                                comment.commentByImageData=imageData;
//                                
//                            });
//                        }
//                    }

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
        [dicUpdate setObject:updateList forKey:@"updates"];
        [dicUpdate setObject:totalRecords forKey:@"updatesCount"];
      success(dicUpdate);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}
//get Updates detail
-(void)getUpdatesDetail:(NSString*)updateId success:(void (^)(Update *updates))success   failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    NSDictionary *parameters = @{@"userId":userid,
//                                 @"searchText":txtSearch,@"offset":[NSString stringWithFormat:@"%d",offset],@"noOfRecords":[NSString stringWithFormat:@"%d",noOfRecords]
//                                 };
    
    [manager GET:GET_UPDATE_DETAIL_URL([AppSingleton sharedInstance].userDetail.userId,updateId) parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //        //Success Full Logout
        //        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        //
        
        //call Block function
//        NSMutableArray *updateList= [[NSMutableArray alloc]init];
//        NSMutableDictionary *dicUpdate= [[NSMutableDictionary alloc]init];
//        NSString *totalRecords=[responseDic objectForKey:@"totalRecords"];
        Update *update= [[Update alloc]init];
        NSDictionary *dicContent = [responseDic objectForKey:@"feedDetail"];
            if([dicContent objectForKey:@"likeCounts"]!=nil){
                update.likeCount=[NSString stringWithFormat:@"%@",  [dicContent objectForKey:@"likeCounts"] ];
            }
            if([dicContent objectForKey:@"shareCounts"]!=nil){
                update.shareCount=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"shareCounts"]];
                
            }
            if([dicContent objectForKey:@"commentCounts"]!=nil){
                
                update.commentCount=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"commentCounts"]];
            }
            update.isLike=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"isLiked"]];
            
            update.updateId=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedId"]];
            update.updateTitle=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedText"]];
            update.updateTitleArray=[dicContent objectForKey:@"feedTextArray"];
            if([dicContent objectForKey:@"user"]!=nil)
            {
                NSDictionary *userdic=[dicContent objectForKey:@"user"];
                UserDetails *user= [[UserDetails alloc]init];
                user.userId=[userdic objectForKey:@"userId"];
                user.userFBID=[userdic objectForKey:@"userFbId"];
                user.username  =[userdic objectForKey:@"userName"];
                user.userFirstName=[userdic objectForKey:@"firstName"];
                user.userLastName=[userdic objectForKey:@"lastName"];
                user.userEmail=[userdic objectForKey:@"emailId"];
                user.title=[userdic objectForKey:@"title"];
                user.userImage=[userdic objectForKey:@"profileImage"];
                update.updateCreatedBy=[NSString stringWithFormat:@"%@ %@" ,user.userFirstName,user.userLastName];
                update.user =user;
                update.updateCreatedByImage=user.userImage;
//                if(update.updateCreatedByImage!=nil){
//                    
//                    
//                    if (update.updateCreatedByImageData==nil) {
//                        NSURL *imageURL = [NSURL URLWithString:update.updateCreatedByImage];
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                            update.updateCreatedByImageData  = [NSData dataWithContentsOfURL:imageURL];
//                            
//                        });
//                    }
//                }
                
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
//                if (update.resource!=nil) {
//                    
//                    if(update.resource.resourceImageUrl!=nil){
//                        if (update.resource.resourceImageData==nil) {
//                            NSURL *imageURL = [NSURL URLWithString:update.resource.resourceImageUrl];
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                update.resource.resourceImageData  = [NSData dataWithContentsOfURL:imageURL];
//                                
//                            });
//                        }
//                    }
//                }
                
            }
            NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
            NSMutableArray * arrayTempComments= [dicContent objectForKey:@"feedCommentsList"];
            
            for (NSDictionary *dicComment in arrayTempComments) {
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
//                if(comment.commentByImage!=nil){
//                    if(comment.commentByImageData==nil)
//                    {
//                        
//                        NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
//                        
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                            comment.commentByImageData=imageData;
//                            
//                        });
//                    }
//                }
                
                
                comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                comment.isLike=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"isLiked"]];
                comment.commentDate=[dicComment objectForKey:@"commentDate"];
                //find sub comment and add in main
                // comment.commentDate=[dicComment objectForKey:@"subComments"];
                [arrayComments addObject:comment];
                NSArray *subcomment=[dicComment objectForKey:@"subComments"];
                if (subcomment  !=nil) {
                    for (NSDictionary *dicSubComment in subcomment) {
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
                        comment.commentById=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentById"]];
                        comment.commentId=[dicSubComment objectForKey:@"commentId"];
                        
                        comment.parentCommentId=[dicSubComment objectForKey:@"parentCommentId"];
                        comment.commentBy=[dicSubComment objectForKey:@"commentBy"];
                        comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
//                        if(comment.commentByImage!=nil){
//                            if(comment.commentByImageData==nil)
//                            {
//                                
//                                NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
//                                
//                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                                    comment.commentByImageData=imageData;
//                                    
//                                });
//                            }
//                        }
                        
                        comment.commentTxt=[dicSubComment objectForKey:@"commentTxt"];
                        comment.isLike=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"isLiked"]];
                        comment.commentDate=[dicSubComment objectForKey:@"commentDate"];
                        
                        [arrayComments addObject:comment];
                    }
                }
            }
            
        update.comments=arrayComments;
        //call Block function
     
        success(update);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
        
    }];
    
}

//get more comments
-(void)getMoreComment:(NSString*)updateId  Offset:(int)offset NoOfRecords:(int)noOfRecords success:(void (^)( NSMutableDictionary *comments))success   failure:(void (^)(NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameters = @{@"userId":[AppSingleton sharedInstance].userDetail.userId,@"feedId":updateId,
                                     @"searchText":@"",@"offset":[NSString stringWithFormat:@"%d",offset],@"noOfRecords":[NSString stringWithFormat:@"%d",noOfRecords]
                                     };

    [manager POST:GET_MORE_COMMENT_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
        
        //        //Success Full Logout
                if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        
        
       // call Block function
        NSMutableDictionary *dicComments= [[NSMutableDictionary alloc]init];
                    
        NSString *totalRecords=[responseDic objectForKey:@"totalRecords"];
        
        NSMutableArray * arrayComments= [[NSMutableArray alloc]init];
        NSMutableArray * arrayTempComments= [responseDic objectForKey:@"commentsList"];
            
        for (NSDictionary *dicComment in arrayTempComments) {
            
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
//                if(comment.commentByImage!=nil){
//                    if(comment.commentByImageData==nil)
//                    {
//                        
//                        NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
//                        
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                            comment.commentByImageData=imageData;
//                            
//                        });
//                    }
//                }
            
                
                comment.commentTxt=[dicComment objectForKey:@"commentTxt"];
                comment.isLike=[NSString stringWithFormat:@"%@",[dicComment objectForKey:@"isLiked"]];
                comment.commentDate=[dicComment objectForKey:@"commentDate"];
                //find sub comment and add in main
                // comment.commentDate=[dicComment objectForKey:@"subComments"];
                [arrayComments addObject:comment];
                NSArray *subcomment=[dicComment objectForKey:@"subComments"];
                if (subcomment  !=nil) {
                    for (NSDictionary *dicSubComment in subcomment) {
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
                        comment.commentById=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"commentById"]];
                        comment.commentId=[dicSubComment objectForKey:@"commentId"];
                        
                        comment.parentCommentId=[dicSubComment objectForKey:@"parentCommentId"];
                        comment.commentBy=[dicSubComment objectForKey:@"commentBy"];
                        comment.commentByImage=[dicComment objectForKey:@"commentByImage"];
//                        if(comment.commentByImage!=nil){
//                            if(comment.commentByImageData==nil)
//                            {
//                                
//                                NSURL *imageURL = [NSURL URLWithString:comment.commentByImage];
//                                
//                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//                                    comment.commentByImageData=imageData;
//                                    
//                                });
//                            }
//                        }
                        
                        comment.commentTxt=[dicSubComment objectForKey:@"commentTxt"];
                        comment.isLike=[NSString stringWithFormat:@"%@",[dicSubComment objectForKey:@"isLiked"]];
                        comment.commentDate=[dicSubComment objectForKey:@"commentDate"];
                        
                        [arrayComments addObject:comment];
                    }
                }
            }
                
        
        //call Block function
        
        //call Block function
        [dicComments setObject:arrayComments forKey:@"comments"];
        [dicComments setObject:totalRecords forKey:@"updatesCount"];
        success(dicComments);
                    
                } }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
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
