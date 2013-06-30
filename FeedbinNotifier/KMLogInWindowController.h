//
//  KMPreferencesWindowController.h
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KMLogInWindowController : NSWindowController

- (void)showWindowWithCompletionHandler:(void (^)(NSURLCredential *credential))completionHandler;

@end
