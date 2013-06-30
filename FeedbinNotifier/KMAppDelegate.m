//
//  KMAppDelegate.m
//  FeedbinNotifier
//
//  Created by Mikael Konutgan on 30/06/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMPreferencesWindowController.h"

@interface KMAppDelegate ()

@property (strong, nonatomic) KMPreferencesWindowController *preferencesWindowController;

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
