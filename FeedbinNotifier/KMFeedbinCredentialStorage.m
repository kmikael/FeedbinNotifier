//
//  KMFeedbinCredentialStorage.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMFeedbinCredentialStorage.h"

NSString * const KMFeedbinCredentialStorageService = @"Feedbin";

@implementation KMFeedbinCredentialStorage

+ (void)createCredential:(NSURLCredential *)credential
{
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: KMFeedbinCredentialStorageService,
        (id)kSecAttrAccount: credential.user,
        (id)kSecValueData: [credential.password dataUsingEncoding:NSUTF8StringEncoding]
    };
    
    SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}

+ (NSURLCredential *)readCredential
{
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: KMFeedbinCredentialStorageService,
        (id)kSecReturnData: @YES,
        (id)kSecReturnAttributes: @YES
    };
    
    CFTypeRef result;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    NSDictionary *attributes = (__bridge NSDictionary *)result;
    
    NSString *user = attributes[(id)kSecAttrAccount];
    NSString *password = [[NSString alloc] initWithData:attributes[(id)kSecValueData] encoding:NSUTF8StringEncoding];
    
    if (!password.length) {
        password = nil;
    }
    
    return [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceNone];
}

+ (void)deleteCredential
{
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: KMFeedbinCredentialStorageService,
    };
    
    SecItemDelete((__bridge CFDictionaryRef)query);
}

@end
