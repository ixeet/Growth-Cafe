//
//  AptysKeyChainWrapper.h
//  aMobile
//
//  Created by Mayank Dixit on 8/25/14.
//  Copyright (c) 2014 Mayank Dixit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AptysKeyChainWrapper : NSObject
- (void)deleteKeychainValue:(NSString *)identifier ;
- (BOOL)updateKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier ;
- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier;
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier ;
- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier;

@end
