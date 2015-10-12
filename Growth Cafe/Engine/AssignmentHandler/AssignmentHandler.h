//
//  AssignmentHandler.h
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>
@interface AssignmentHandler : NSObject
#pragma Assignment Detail Functions
//get my Assignment Data
-(void)getMyAssignments:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure;

-(void)getTeacherAssignment:(NSString*)userid  AndTextSearch:(NSString*)txtSearch AndFilterDic:(NSMutableDictionary*)filterDic success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure;
//get Assignment
-(void)getAssignmentsById:(NSString*)userid AndAssignment:(NSString*)assignmentid   success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure;

//set Assignment rating
-(void)setAssignmentRating:(NSDictionary*)selectedParamValue AndParam:(NSArray*)selectedParam AndAssignmentResourceTxnId:(NSString*)assignmentResourceTxnId success:(void (^)(BOOL responseValue))success   failure:(void (^)(NSError *error))failure;

//upload assignment
-(void)uploadAssignment:(NSString*)videoTitle  AndVideoDesc:(NSString*)videoDesc AndVideoURL:(NSString*)videoURL AndVideoPath:(ALAsset*)videoPath andFileName:(NSString *)fileName AndAssignment:(NSString*)assignmentId
                success:(void (^)(BOOL logoutValue))success   failure:(void (^)(NSError *error))failure;

@end
