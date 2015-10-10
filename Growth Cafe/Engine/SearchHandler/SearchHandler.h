//
//  SearchHandler.h
//  Growth Cafe
//
//  Created by Mayank on 08/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHandler : NSObject
//Find the Search Relative Content
-(void)getSearchResult:(NSString*)userid AndSearchText:(NSString*)txtSearch AndCatId:(NSString*)catid AndCount:(NSString*)count success:(void (^)(NSDictionary *searchResult))success     failure:(void (^)(NSError *error))failure;
@end
