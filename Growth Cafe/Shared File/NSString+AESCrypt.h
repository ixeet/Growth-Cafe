//
//  NSString+AESCrypt.h
//
//  Created by Michael Sedlaczek, Gone Coding on 2011-02-22
//

#import <Foundation/Foundation.h>
#import "NSData+AESCrypt.h"
#import <Security/Security.h>
@interface NSString (AESCrypt)

- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;

- (NSString *)AES256EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSString *)AES256DecryptWithKey:(NSString *)key iv:(NSString *)iv;
@end
