//
//  KMFeedbinClient.h
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

@import ForceFeedback;

@interface KMFeedbinClient : NSObject

@property (nonatomic, readonly) NSURLCredential *credential;

- (instancetype)initWithCredential:(NSURLCredential *)credential NS_DESIGNATED_INITIALIZER;

// GET /v2/unread_entries.json
- (void)getUnreadEntriesWithCompletionHandler:(void (^)(NSArray *entries, NSError *error))completionHandler;

@end
