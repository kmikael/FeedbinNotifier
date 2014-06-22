//
//  KMFeedbinCredentialStorage.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMFeedbinCredentialStorage.h"

@implementation KMFeedbinCredentialStorage

+ (instancetype)sharedCredentialStorage
{
    static id sharedCredentialStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCredentialStorage = [[self alloc] init];
    });
    return sharedCredentialStorage;
}

- (NSURLCredential *)credential
{
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinUser"];
    
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: @"Feedbin",
        (id)kSecAttrAccount: user ? user : @"",
        (id)kSecReturnData: @YES,
    };
    
    CFTypeRef result;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    NSString *password = [[NSString alloc] initWithData:(__bridge_transfer NSData *)result encoding:NSUTF8StringEncoding];
    
    if (![password length]) {
        password = nil;
    }
    
    return [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceNone];
}

- (void)setCredential:(NSURLCredential *)credential
{
    [[NSUserDefaults standardUserDefaults] setObject:credential.user forKey:@"KMFeedbinUser"];
    
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: @"Feedbin",
        (id)kSecAttrAccount: credential.user,
        (id)kSecValueData: [credential.password dataUsingEncoding:NSUTF8StringEncoding]
    };
    
    SecItemAdd((__bridge CFDictionaryRef)query, NULL);
}

- (void)removeCredential
{
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinUser"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KMFeedbinUser"];
    
    NSDictionary *query = @{
        (id)kSecClass: (id)kSecClassGenericPassword,
        (id)kSecAttrService: @"Feedbin",
        (id)kSecAttrAccount: user ? user : @""
    };
    
    SecItemDelete((__bridge CFDictionaryRef)query);
}

@end
