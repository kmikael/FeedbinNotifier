//
//  KMPreferencesWindowController.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMLogInWindowController.h"

@interface KMLogInWindowController ()

@property (nonatomic, strong) void (^completionHandler)(NSURLCredential *credential);
@property (nonatomic, strong) IBOutlet NSTextField *emailTextField;
@property (nonatomic, strong) IBOutlet NSSecureTextField *passwordTextField;

@end

@implementation KMLogInWindowController

- (instancetype)init
{
    return [self initWithWindowNibName:@"KMLogInWindowController" owner:self];
}

- (void)showWindowWithCompletionHandler:(void (^)(NSURLCredential *))completionHandler
{
    [self showWindow:nil];
    self.completionHandler = completionHandler;
}

- (IBAction)logIn:(id)sender
{
    if (self.completionHandler) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.emailTextField.stringValue password:self.passwordTextField.stringValue persistence:NSURLCredentialPersistenceNone];
        self.completionHandler(credential);
        [self close];
    }
}

@end
