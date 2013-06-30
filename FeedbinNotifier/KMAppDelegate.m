//
//  KMAppDelegate.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMPreferencesWindowController.h"
#import "KMFeedbinClient.h"

@interface KMAppDelegate ()

@property (strong, nonatomic) KMPreferencesWindowController *preferencesWindowController;
@property (strong, nonatomic) KMFeedbinClient *feedbinClient;

@end

@implementation KMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"";
    _statusItem.image = [NSImage imageNamed:@"icon"];
    _statusItem.highlightMode = YES;
    _statusItem.menu = [[NSMenu alloc] init];
    [_statusItem.menu addItemWithTitle:@"Open Feedbin" action:@selector(openFeedbin:) keyEquivalent:@""];
    [_statusItem.menu addItemWithTitle:@"Log In..." action:@selector(logIn:) keyEquivalent:@""];
    [_statusItem.menu addItem:[NSMenuItem separatorItem]];
    [_statusItem.menu addItemWithTitle:@"Quit Feedbin Notifier" action:@selector(terminate:) keyEquivalent:@""];
    
    [self getUnreadEntries:self];
    [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(getUnreadEntries:) userInfo:nil repeats:YES];
}

- (void)getUnreadEntries:(id)sender
{
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinEmail"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"KMFeedbinPassword"];
    
    if (!email || !password) {
        return;
    }
    
    if (!_feedbinClient) {
        NSURLCredential *credential = [NSURLCredential credentialWithUser:email password:password persistence:NSURLCredentialPersistenceForSession];
        _feedbinClient = [[KMFeedbinClient alloc] initWithCredential:credential];
    }
    
    [self.feedbinClient getUnreadEntriesWithCompletionHandler:^(NSArray *entries, NSError *error)
    {
        self.statusItem.title = [NSString stringWithFormat:@"%lu", entries.count];
    }];
}

#pragma mark - Menu actions

- (void)openFeedbin:(id)sender
{
    NSURL *URL = [NSURL URLWithString:@"https://feedbin.me"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

- (void)logIn:(id)sender
{
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[KMPreferencesWindowController alloc] init];
    }
    [self.preferencesWindowController showWindow:self.statusItem.menu];
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)terminate:(id)sender
{
    [[NSApplication sharedApplication] terminate:self.statusItem.menu];
}

@end
