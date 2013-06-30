//
//  KMPreferencesWindowController.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMLogInWindowController.h"

@interface KMLogInWindowController ()

@property (copy, nonatomic) void (^completionHandler)(NSURLCredential *credential);
@property (weak, nonatomic) IBOutlet NSTextField *emailTextField;
@property (weak, nonatomic) IBOutlet NSSecureTextField *passwordTextField;

@end

@implementation KMLogInWindowController

- (id)init
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
