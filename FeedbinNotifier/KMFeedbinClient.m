//
//  KMFeedbinClient.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMFeedbinClient.h"

@interface KMFeedbinClient ()

@property (strong, nonatomic) NSURLCredential *credential;

@end

@implementation KMFeedbinClient

- (id)initWithCredential:(NSURLCredential *)credential;
{
    self = [super init];
    if (self) {
        _credential = credential;
    }
    return self;
}

- (void)getUnreadEntriesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler
{
    NSString *user = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)(self.credential.user), NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8));
    NSString *password = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)(self.credential.password), NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8));
    NSString *string = [NSString stringWithFormat:@"https://%@:%@@api.feedbin.me/v2/unread_entries.json", user, password];
    NSURL *URL = [NSURL URLWithString:string];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:URL]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (data && !error) {
            NSArray *entries = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            completionHandler(entries, error);
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}

@end
