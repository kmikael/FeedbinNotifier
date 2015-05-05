//
//  KMFeedbinCredentialStorage.h
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

@import Foundation;

@interface KMFeedbinCredentialStorage : NSObject

+ (void)createCredential:(NSURLCredential *)credential;
+ (NSURLCredential *)readCredential;

+ (void)deleteCredential;

@end
