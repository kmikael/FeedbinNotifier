//
//  KMPreferencesWindowController.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMPreferencesWindowController.h"

@interface KMPreferencesWindowController ()

@property (weak, nonatomic) IBOutlet NSTextField *emailTextField;
@property (weak, nonatomic) IBOutlet NSSecureTextField *passwordTextField;

@end

@implementation KMPreferencesWindowController

- (id)init
{
    return [self initWithWindowNibName:@"KMPreferencesWindowController" owner:self];
}

- (void)windowDidLoad
{
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinEmail"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinPassword"];
    self.emailTextField.stringValue = email ? email : @"";
    self.passwordTextField.stringValue = password ? password : @"";
}

- (IBAction)logIn:(id)sender
{
    NSString *email = self.emailTextField.stringValue;
    NSString *password = self.passwordTextField.stringValue;
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"KMFeedbinEmail"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"KMFeedbinPassword"];
    [self close];
}

@end
