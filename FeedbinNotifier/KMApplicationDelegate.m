//
//  KMApplicationDelegate.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMApplicationDelegate.h"
#import "KMLogInWindowController.h"
#import "KMFeedbinClient.h"
#import "KMFeedbinCredentialStorage.h"

NSString * const KMFeedbinRefreshInterval = @"KMFeedbinRefreshInterval";

@interface KMApplicationDelegate ()

@property (nonatomic, strong, readwrite) NSStatusItem *statusItem;

@property (nonatomic, strong) KMLogInWindowController *logInWindowController;

@end

@implementation KMApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{KMFeedbinRefreshInterval: @120.0}];
    
    [self setupStatusItem];
    [self getUnreadEntries:nil];
    
    NSTimeInterval timeInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:KMFeedbinRefreshInterval];
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(getUnreadEntries:) userInfo:nil repeats:YES];
}

- (void)setupStatusItem
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.button.image = [NSImage imageNamed:@"StatusItem-Image"];
    
    [self updateStatusItemMenu];
}

- (void)updateStatusItemMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Open Feedbin" action:@selector(openFeedbin:) keyEquivalent:@""];
    
    if ([[KMFeedbinCredentialStorage readCredential] hasPassword]) {
        [menu addItemWithTitle:@"Refresh" action:@selector(getUnreadEntries:) keyEquivalent:@""];
        [menu addItemWithTitle:@"Log Out" action:@selector(logOut:) keyEquivalent:@""];
    } else {
        [menu addItemWithTitle:@"Refresh" action:NULL keyEquivalent:@""];
        [menu addItemWithTitle:@"Log In" action:@selector(logIn:) keyEquivalent:@""];
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    
    self.statusItem.menu = menu;
}

- (void)getUnreadEntries:(id)sender
{
    NSURLCredential *credential = [KMFeedbinCredentialStorage readCredential];
    
    if (!credential.hasPassword) {
        return;
    }
    
    KMFeedbinClient *feedbinClient = [[KMFeedbinClient alloc] initWithCredential:credential];
    
    [feedbinClient getUnreadEntriesWithCompletionHandler:^(NSArray *entries, NSError *error) {
        NSNumber *number = [NSNumber numberWithUnsignedInteger:entries.count];
        NSString *title = [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterDecimalStyle];
        
        // Work around bug where setting the title only once will cause a layout issue
        self.statusItem.title = title;
        self.statusItem.title = title;
    }];
}

#pragma mark - Menu actions

- (void)openFeedbin:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"https://feedbin.com"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)logIn:(id)sender
{
    if (!self.logInWindowController) {
        self.logInWindowController = [[KMLogInWindowController alloc] init];
    }
    
    [self.logInWindowController showWindowWithCompletionHandler:^(NSURLCredential *credential) {
        [KMFeedbinCredentialStorage createCredential:credential];
        [self getUnreadEntries:self];
        [self updateStatusItemMenu];
    }];
    
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)logOut:(id)sender
{
    [KMFeedbinCredentialStorage deleteCredential];
    
    self.statusItem.title = nil;
    
    [self updateStatusItemMenu];
}

@end
