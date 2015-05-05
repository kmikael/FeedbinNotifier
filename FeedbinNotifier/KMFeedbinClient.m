//
//  KMFeedbinClient.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMFeedbinClient.h"

@implementation KMFeedbinClient

- (instancetype)initWithCredential:(NSURLCredential *)credential;
{
    self = [super init];
    if (self) {
        _credential = credential;
    }
    return self;
}

- (NSURL *)unreadEntriesURLWithUser:(NSString *)user password:(NSString *)password
{
    NSURLComponents *URLComponents = [NSURLComponents componentsWithString:@"https://api.feedbin.com"];
    URLComponents.path = @"/v2/unread_entries.json";
    
    URLComponents.user = user;
    URLComponents.password = password;
    
    return URLComponents.URL;
}

- (void)getUnreadEntriesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[self unreadEntriesURLWithUser:self.credential.user password:self.credential.password]];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (data) {
            NSArray *entries = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completionHandler(entries, error);
        } else {
            completionHandler(nil, error);
        }
    }];
}

@end
