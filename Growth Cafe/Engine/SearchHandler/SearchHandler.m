//
//  SearchHandler.m
//  Growth Cafe
//
//  Created by Mayank on 08/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "SearchHandler.h"
#import "AFHTTPRequestOperationManager.h"

@implementation SearchHandler
//Find the Search Relative Content
-(void)getSearchResult:(NSString*)userid AndSearchText:(NSString*)txtSearch AndCatId:(NSString*)catid AndCount:(NSString*)count success:(void (^)(NSDictionary *searchResult))success     failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *nofoRecord=[NSString stringWithFormat:@"%d",SEARCH_PER_PAGE];
    NSString *url;
    if([catid isEqualToString:@""])
    {
    url=SEARCH_URL;
       
        
    }
    else{
        url=SEARCH_CAT_URL(catid);
       nofoRecord=[NSString stringWithFormat:@"%d",100];
    }
    NSDictionary *parameters = @{@"userId":userid,
                                 @"searchText":txtSearch,@"offset":@"0",@"noOfRecords":nofoRecord
                                 };

    
   // {"userId":"22","searchText":"sale","offset":0,"noOfRecords":10}
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
      
        

        //Success Full Logout
        if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
            
            NSMutableDictionary *dicSearchResult= [[NSMutableDictionary alloc]init];
            for (NSDictionary *dicSearch in [responseDic objectForKey:@"searchList"]) {
                
            if([dicSearch objectForKey:@"usersList"]!=nil)
            {
            //call Block function
                
                NSMutableArray *userList= [[NSMutableArray alloc]init];
                for (NSDictionary *dicUser  in [dicSearch objectForKey:@"usersList"]) {
                
                    UserDetails  *userDetail= [[UserDetails alloc]init];
                    userDetail.userId= [dicUser objectForKey:@"userId"];
                    userDetail.userImage=[dicUser objectForKey:@"profileImage"];
                    userDetail.username=[dicUser objectForKey:@"userName"];
                    userDetail.isFollowUpAllowed=[dicUser objectForKey:@"isFollowUpAllowed"];
                    [userList addObject:userDetail];
                    
                }
                 [dicSearchResult setObject:userList forKey:@"user"];
            }else if ([dicSearch objectForKey:@"feedList"]!=nil){
            
            
            //call Block function
                NSMutableArray *updateList= [[NSMutableArray alloc]init];
                for (NSDictionary *dicContent  in [dicSearch objectForKey:@"feedList"]) {
                
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
                        update.updatetime=[NSString stringWithFormat:@"%@",[dicContent objectForKey:@"feedOn"]];
                        
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
                            
                        }
                    
                    
                    [updateList addObject:update];
                }
                 [dicSearchResult setObject:updateList forKey:@"update"];
            }
            else if ([dicSearch objectForKey:@"courseList"]!=nil){
                
                
                //call Block function
                NSMutableArray *courseList= [[NSMutableArray alloc]init];
                for (NSDictionary *dicCourse  in [dicSearch objectForKey:@"courseList"]) {
                    
                    Courses  *course= [[Courses alloc]init];
                    course.courseId= [dicCourse objectForKey:@"courseId"];
                    course.courseName=[dicCourse objectForKey:@"courseName"];
                    [courseList addObject:course];
                }
                 [dicSearchResult setObject:courseList forKey:@"course"];
            }
            else if ([dicSearch objectForKey:@"assignmentList"]!=nil){
                
                
                //call Block function
                NSMutableArray *assignmentList= [[NSMutableArray alloc]init];
                for (NSDictionary *dicAssign  in [dicSearch objectForKey:@"assignmentList"]) {
                    
                    Assignment  *assign= [[Assignment alloc]init];
                    assign.assignmentId= [dicAssign objectForKey:@"assignmentId"];
                    assign.assignmentName=[dicAssign objectForKey:@"assignmentName"];
                    assign.assignmentName=[dicAssign objectForKey:@"assignmentName"];
                    
                    [assignmentList addObject:assign];
                }
                 [dicSearchResult setObject:assignmentList forKey:@"assignment"];
            }
                
               
            }
           

            success(dicSearchResult);
            
            
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
