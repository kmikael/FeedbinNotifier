//
//  KMFeedbinClient.h
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMFeedbinClient : NSObject

@property (nonatomic, readonly) NSURLCredential *credential;

- (id)initWithCredential:(NSURLCredential *)credential;

// GET /v2/unread_entries.json
- (void)getUnreadEntriesWithCompletionHandler:(void (^)(NSArray *entries, NSError *error))completionHandler;

@end
