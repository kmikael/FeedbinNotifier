//
//  KMAppDelegate.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMLogInWindowController.h"
#import "KMFeedbinClient.h"
#import "KMFeedbinCredentialStorage.h"

@interface KMAppDelegate ()

@property (strong, nonatomic) KMLogInWindowController *logInWindowController;
@property (strong, nonatomic) KMFeedbinClient *feedbinClient;

@end

@implementation KMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"KMFeedbinRefreshInterval": @120}];
    
    [self setupStatusItem];
    [self getUnreadEntries:nil];
    
    NSTimeInterval ti = [[NSUserDefaults standardUserDefaults] doubleForKey:@"KMFeedbinRefreshInterval"];
    [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(getUnreadEntries:) userInfo:nil repeats:YES];
}

- (void)setupStatusItem
{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"";
    _statusItem.image = [NSImage imageNamed:@"feedbin-logo"];
    _statusItem.alternateImage = [NSImage imageNamed:@"feedbin-logo-alt"];
    _statusItem.highlightMode = YES;
    [self setupMenu];
}

- (void)setupMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Open Feedbin" action:@selector(openFeedbin:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Refresh" action:@selector(getUnreadEntries:) keyEquivalent:@""];
    if ([[[KMFeedbinCredentialStorage sharedCredentialStorage] credential] hasPassword]) {
        [menu addItemWithTitle:@"Log Out" action:@selector(logOut:) keyEquivalent:@""];
    } else {
        [menu addItemWithTitle:@"Log In" action:@selector(logIn:) keyEquivalent:@""];
    }
    [menu addItem:[NSMenuItem separatorItem]];
    [menu addItemWithTitle:@"Quit Feedbin Notifier" action:@selector(terminate:) keyEquivalent:@""];
    self.statusItem.menu = menu;
}

- (void)getUnreadEntries:(id)sender
{
    NSURLCredential *credential = [[KMFeedbinCredentialStorage sharedCredentialStorage] credential];
    
    if (credential.hasPassword) {
        if (!_feedbinClient) {
            _feedbinClient = [[KMFeedbinClient alloc] initWithCredential:credential];
        }
        
        [self.feedbinClient getUnreadEntriesWithCompletionHandler:^(NSArray *entries, NSError *error)
        {
            self.statusItem.title = [NSString stringWithFormat:@"%lu", entries.count];
        }];
    } else {
        [self logIn:nil];
    }
}

#pragma mark - Menu actions

- (void)openFeedbin:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"https://feedbin.com"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)logIn:(id)sender
{
    if (!_logInWindowController) {
        _logInWindowController = [[KMLogInWindowController alloc] init];
    }
    [self.logInWindowController showWindowWithCompletionHandler:^(NSURLCredential *credential){
        [[KMFeedbinCredentialStorage sharedCredentialStorage] setCredential:credential];
        [self getUnreadEntries:self];
        [self setupMenu];
    }];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)logOut:(id)sender
{
    [[KMFeedbinCredentialStorage sharedCredentialStorage] removeCredential];
    self.statusItem.title = @"";
    [self setupMenu];
}

- (void)terminate:(id)sender
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

@end
