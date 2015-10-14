//
//  NSData-AEC256.h
//  MyMazdaGarage
//
//  Created by Umesh Tiwari on 07/03/11.
//  Copyright 2011 InterraIT Pvt. Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData(AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;

- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
