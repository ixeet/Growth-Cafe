//
//  Encryption.h
//  MyMazdaGarage
//
//  Created by Umesh Tiwari on 02/03/11.
//  Copyright 2011 InterraIT Pvt. Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData-AES.h"
#import "NSData-AES256.h"


@interface Encryption : NSObject {
	
}


+(NSString *) encryptWithAES:(NSString *) plaintext key:(NSString *) key;

+(NSString *) decryptWithAES:(NSString *) cipher key:(NSString *) key;


@end
