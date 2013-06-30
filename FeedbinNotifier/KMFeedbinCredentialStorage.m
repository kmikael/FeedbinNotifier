//
//  KMFeedbinCredentialStorage.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMFeedbinCredentialStorage.h"

@implementation KMFeedbinCredentialStorage

+ (KMFeedbinCredentialStorage *)sharedCredentialStorage
{
    static KMFeedbinCredentialStorage *sharedCredentialStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCredentialStorage = [[KMFeedbinCredentialStorage alloc] init];
    });
    return sharedCredentialStorage;
}

- (NSURLCredential *)credential
{
    NSString *user = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinUser"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinPassword"];
    return [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceNone];
}

- (void)setCredential:(NSURLCredential *)credential
{
    [[NSUserDefaults standardUserDefaults] setObject:credential.user forKey:@"KMFeedbinUser"];
    [[NSUserDefaults standardUserDefaults] setObject:credential.password forKey:@"KMFeedbinPassword"];
}

- (void)removeCredential
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KMFeedbinUser"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"KMFeedbinPassword"];
}

@end
