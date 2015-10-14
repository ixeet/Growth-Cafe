//
//  Encryption.m
//  MyMazdaGarage
//
//  Created by Umesh Tiwari on 02/03/11.
//  Copyright 2011 InterraIT Pvt. Ltd.. All rights reserved.
//

#import "Encryption.h"
#import <CommonCrypto/CommonCryptor.h>


@implementation Encryption


// encrypt the plaintext
+(NSString *) encryptWithAES:(NSString *) plaintext key:(NSString *) key{
		
	NSData *plain = [plaintext dataUsingEncoding:NSUTF8StringEncoding];
	//NSData *cipher = [plain AES256EncryptWithKey:key];
	NSData *cipher = [plain AESEncryptWithPassphrase: key];
	printf("%s\n", [[cipher description] UTF8String]);
	return (NSString*)cipher;
    
}

// decrypt the cipher
+(NSString *) decryptWithAES:(NSString *) cipher key:(NSString *) key
{
    NSData *data = [cipher dataUsingEncoding:NSASCIIStringEncoding];
    
	NSData *plain = (NSData*)[data AES256DecryptWithKey:key];

	return (NSString*)plain;
	
}

@end
