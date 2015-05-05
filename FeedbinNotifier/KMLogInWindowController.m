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

@property (nonatomic, strong) IBOutlet NSTextField *userTextField;
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
    
    [self.userTextField becomeFirstResponder];
    
    self.completionHandler = completionHandler;
}

- (IBAction)logIn:(id)sender
{
    NSString *user = self.userTextField.stringValue;
    NSString *password = self.passwordTextField.stringValue;
    NSURLCredential *credential = [NSURLCredential credentialWithUser:user password:password persistence:NSURLCredentialPersistenceNone];
    
    self.completionHandler(credential);
    
    self.userTextField.stringValue = @"";
    self.passwordTextField.stringValue = @"";
    
    [self close];
}

@end
