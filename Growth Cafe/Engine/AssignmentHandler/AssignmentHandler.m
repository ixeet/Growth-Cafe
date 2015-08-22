//
//  AssignmentHandler.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "AssignmentHandler.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation AssignmentHandler
#pragma Assignment Detail Functions
//get my Assignment Data
-(void)getMyAssignments:(NSString*)userid  AndTextSearch:(NSString*)txtSearch success:(void (^)(NSMutableArray *assignments))success   failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSDictionary *parameters = @{@"userId":userid,
                             @"searchText":txtSearch,
                             };
    [manager POST:GET_ASSIGNMENT_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic=[NSDictionary dictionaryWithDictionary:(NSDictionary*)responseObject];
    
    //Success Full Logout
    if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
        
      
        //call Block function
        NSMutableArray *assignmentList= [[NSMutableArray alloc]init];
        
        for (NSDictionary *dicassignment in [responseDic objectForKey:@"assignmentList"]) {
            Assignment *assignment= [[Assignment alloc]init];
            assignment.assignmentId=[dicassignment objectForKey:@"assignmentId"];
            assignment.assignmentName=[dicassignment objectForKey:@"assignmentName"];
            assignment.assignmentStatus=[dicassignment objectForKey:@"assignmentStatus"];
            assignment.assignmentSubmittedDate=[dicassignment objectForKey:@"assignmentSubmittedDate"];
            assignment.assignmentDesc=[dicassignment objectForKey:@"assignmentDesc"];
            
            Courses *course=[[Courses alloc]init];
            course.courseId =[dicassignment objectForKey:@"courseId"];
             course.courseName =[dicassignment objectForKey:@"courseName"];
            Module *module=[[Module alloc]init];
            module.moduleId=[dicassignment objectForKey:@"moduleId"];
            module.moduleName=[dicassignment objectForKey:@"moduleName"];
            assignment.course=course;
            assignment.module=module;
           
  
            Resourse *resource= [[Resourse alloc]init];
            for (NSDictionary *dicRelatedResource in [dicassignment objectForKey:@"attachedResources"]) {
                resource.resourceId=[dicRelatedResource objectForKey:@"resourceId"];
                resource.resourceDesc=[dicRelatedResource objectForKey:@"resourceDesc"];
                resource.resourceImageUrl=[dicRelatedResource objectForKey:@"thumbImg"];
                resource.uploadedDate=[dicRelatedResource objectForKey:@"uploadedDate"];
                resource.resourceTitle=[dicRelatedResource objectForKey:@"resourceName"];
                 resource.resourceUrl=[dicRelatedResource objectForKey:@"resourceUrl"];
                 resource.authorImage=[dicRelatedResource objectForKey:@"authorImg"];
                 resource.authorName=[dicRelatedResource objectForKey:@"authorName"];
               
            }
            assignment.isExpend=NO;
            if(resource.resourceImageUrl==nil)
                resource=nil;
            assignment.attachedResource=resource;
            [assignmentList addObject:assignment];
        }
        success(assignmentList);
        
        
    }
    else {
        //call Block function
        failure([AppGlobal createErrorObjectWithDescription:[responseDic objectForKey:@"statusMessage"] errorCode:[[responseDic objectForKey:[responseDic objectForKey:@"status"] ] integerValue]]);
    }
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
    
}];

}


////upload assignment
//-(void)uploadAssignment:(NSString*)videoTitle  AndVideoDesc:(NSString*)videoDesc AndVideoURL:(NSString*)videoURL AndVideoPath:(ALAsset*)asset andFileName:(NSString*)fileName  AndAssignment:(NSString*)assignmentId  success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
// 
//    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
//    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
//    NSData *data =[NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES] ;
//    self uploadVideoTitle:videoTitle AndVideoDesc:videoDesc AndVideoURL:videoURL AndVideoPath:asset andFileName:fileName AndAssignment:assignmentId videoData:data success:^(BOOL logoutValue) {
//        success(YES);
//    } failure:^(NSError *error) {
//        failure
//    }
//    // If you need to build dictionary dynamically as in your question, that's fine,
//    // but sometimes array literals are more concise way if the structure of
////    // the dictionary is always the same.
////    NSMutableDictionary   *dic = [[NSMutableDictionary alloc] init];
////                             ALAssetRepresentation *defaultRepresentation = [asset defaultRepresentation];
////                             NSString *uti = [defaultRepresentation UTI];
////    NSURL  *videoURL1 = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:uti];
////    
////    UserDetails * objUser=[AppSingleton  sharedInstance].userDetail;
////    NSString *autherName=[NSString stringWithFormat:@"%@ %@",objUser.userFirstName,objUser.userLastName];
////   
////    NSDictionary *offerDTO = @{@"resourceName" : videoTitle,@"resourceAuthor" : autherName,
////                           @"descTxt"              : videoDesc,
////                           @"userName"        :  objUser.userEmail,
////                          // @"fileName"         : fileName,
////                           @"uploadedUrl"        : videoURL,
////                           @"assignmentId"          : assignmentId};
////
////    // `AFHTTPRequestOperationManager` (or `AFHTTPSessionManager`) is AFNetworking 2.x
////    // equivalent to `AFHTTPClient` in AFNetworking 1.x
////
////    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//////    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//////    manager.responseSerializer = [AFJSONResponseSerializer serializer];
////    // The `POST` method both creates and issues the request
////[manager POST:POST_ASSIGNMENT_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
////         NSError *error;
////   // [formData  appendPartWithFileURL:videoURL1 name:@"asset.mov" error: &error];
////    [formData appendPartWithFileData:data name:@"fileName"
////                            fileName:@"asset.mov"
////                            mimeType:@"video/quicktime"];
////     //fileName:@"filename.mov" mimeType:@"video/quicktime"
//////    [formData appendPartWithFileData:imageData name:@"letterhead"
//////                            fileName:@"image.jpg"
//////                            mimeType:@"image/jpeg"];
////    
////   
////    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:offerDTO options:0 error:&error];
////    NSAssert(jsonData, @"Failure building JSON: %@", error);
////    
////    // You could just do:
////    //
////    // [formData appendPartWithFormData:jsonData name:@"offerDTO"];
////    //
////    // but I now notice that in your `curl`, you set the `Content-Type` for the
////    // part, so if you want to do that, you could do it like so:
////    // name=\"offerDTO\"
////    NSDictionary *jsonHeaders = @{@"Content-Disposition" : @"form-data;",
////                                  @"Content-Type"        : @"application/json"};
////    [formData appendPartWithHeaders:jsonHeaders body:jsonData];
////        
////}
////     
////    success:^(AFHTTPRequestOperation *operation, id responseObject) {
////    NSLog(@"responseObject = %@", responseObject);
////     success(YES);
////} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////   
////    failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
////    
////    
////}];
//    
//    
//    
//    
//}
-(void)uploadAssignment:(NSString*)videoTitle  AndVideoDesc:(NSString*)videoDesc AndVideoURL:(NSString*)videoURL AndVideoPath:(ALAsset*)asset andFileName:(NSString*)fileName  AndAssignment:(NSString*)assignmentId  success:(void (^)(BOOL logoutValue))success  failure:(void (^)(NSError *error))failure{
    
//    ALAssetRepresentation *rep = [asset defaultRepresentation];
//    Byte *buffer = (Byte*)malloc((NSUInteger)rep.size);
//    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(NSUInteger)rep.size error:nil];
//    NSData *videoData =[NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES] ;

    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath =  [NSString stringWithFormat:@"%@/%@.mp4",[arr objectAtIndex:0],@"output" ];
    NSURL *outputURL = [NSURL fileURLWithPath:filePath];
    
    NSData *videoData= [NSData dataWithContentsOfURL:outputURL];
    
    
    // NSString *urlString = @"http://192.168.0.10:8080/SLMS/rest/course/uploadResourceDetail"; // your url
   // NSString *urlString = @"http://191.239.57.54:8080/SLMS/rest/course/uploadResourceDetail"; // your url
    
    
    NSString *BoundaryConstant = @"---------------------------14737809831466499882746641449";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:POST_ASSIGNMENT_URL]];
     UserDetails * objUser=[AppSingleton  sharedInstance].userDetail;
    
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    NSMutableDictionary *_params=[[NSMutableDictionary alloc]init];
    [_params setObject:videoTitle forKey:@"resourceName"];
    
    [_params setObject:[NSString stringWithFormat:@"%@ %@", objUser.userFirstName,objUser.userLastName ] forKey:@"resourceAuthor"];
    [_params setObject:videoDesc forKey:@"descTxt"];
    [_params setObject:objUser.userEmail forKey:@"userName"];
    [_params setObject:videoURL forKey:@"uploadedUrl"];
    [_params setObject:assignmentId forKey:@"assignmentId"];
    
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"logo@2x.png"], 1.0);
    if (videoData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"output.mp4\"\r\n", @"fileName"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: video/mp4\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:videoData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSError* error;
//    NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:returnData
//                                                         options:kNilOptions
//                                                           error:&error];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil){
            NSDictionary* responseDic = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:kNilOptions
                                                                          error:&error];
           // NSLog(@"%@",returnString);
            //Success Full Logout
            if ([[responseDic objectForKey:key_severRespond_Status] integerValue] == 1001) { //Success
                
                success(YES);
            }else{
                failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
            }

        }
       else if (error != nil)
           failure([AppGlobal createErrorObjectWithDescription:ERROR_DEFAULT_MSG errorCode:1000]);
    }];
    
    
}

@end
