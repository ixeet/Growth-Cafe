//
//  Cipher.h
//  MyMazdaGarage
//
//  Created by Rajesh K Mudaliyar on 18/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>  
#import <CommonCrypto/CommonCryptor.h>  

@interface Cipher : NSObject {  
    NSString* cipherKey;  
}  

@property (retain) NSString* cipherKey;  

- (Cipher *) initWithKey:(NSString *) key;  

- (NSData *) encrypt:(NSData *) plainText;  
- (NSData *) decrypt:(NSData *) cipherText;  

- (NSData *) transform:(CCOperation) encryptOrDecrypt data:(NSData *) inputData;  

+ (NSData *) md5:(NSString *) stringToHash;  

@end 