//
//  KMFeedbinCredentialStorage.h
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMFeedbinCredentialStorage : NSObject

+ (instancetype)sharedCredentialStorage;

- (NSURLCredential *)credential;
- (void)setCredential:(NSURLCredential *)credential;
- (void)removeCredential;

@end
