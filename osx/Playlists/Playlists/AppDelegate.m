//
//  AppDelegate.m
//  Playlists
//
//  Created by Patrick Killian on 2/23/14.
//  Copyright (c) 2014 playlists.im. All rights reserved.
//

#import "AppDelegate.h"
#include "appkey.c"

@implementation AppDelegate

@synthesize playbackManager;

@synthesize loginWindow;
@synthesize loginProgress;
@synthesize usernameField;
@synthesize passwordField;

@synthesize window;
@synthesize uriField;
@synthesize pauseButton;


# pragma mark -
# pragma mark Application Lauch

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    NSError *error = nil;
	[SPSession
        initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
        userAgent:@"im.playlists.osx"
        loadingPolicy:SPAsyncLoadingManual
        error:&error];

	if (error != nil) {
		NSLog(@"CocoaLibSpotify init failed: %@", error);
		abort();
	}

	[[SPSession sharedSession] setDelegate:self];
	self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];

    [self.window center];
	[self.window orderFront:nil];
    [self.loginWindow center];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSApp beginSheet:self.loginWindow
	   modalForWindow:self.window
		modalDelegate:nil
	   didEndSelector:nil
		  contextInfo:nil];
}


# pragma mark -
# pragma mark Playback Controls

- (IBAction)play:(id)sender {
    // Invoked by clicking the "Play" button in the UI.

	if ([[uriField stringValue] length] > 0) {

		NSURL *trackURL = [NSURL URLWithString:[uriField stringValue]];
		[[SPSession sharedSession] trackForURL:trackURL callback:^(SPTrack *track) {
			if (track != nil) {

				[SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
					[self.playbackManager playTrack:track callback:^(NSError *error) {
						if (error)
							[self.window presentError:error];

					}];
				}];
			}
		}];
		return;
	}
	NSBeep();
}

- (IBAction)pause:(id)sender {

    if (!self.playbackManager.currentTrack) {
        return;
    }

    if (self.playbackManager.isPlaying) {
        self.playbackManager.isPlaying = false;
        [self.pauseButton setTitle:@"Resume"];
    } else {
        self.playbackManager.isPlaying = true;
        [self.pauseButton setTitle:@"Pause"];
    }

}


# pragma mark -
# pragma mark Login/Quit Interaction

- (IBAction)quit:(id)sender {
    [self.loginWindow close];
	[NSApp terminate:self];
}

- (IBAction)login:(id)sender {
    // Invoked by clicking the "Login" button in the UI.

	if ([[usernameField stringValue] length] > 0 &&
		[[passwordField stringValue] length] > 0) {

		[[SPSession sharedSession]
            attemptLoginWithUserName:[usernameField stringValue]
            password:[passwordField stringValue]
        ];

	} else {
		NSBeep();
	}
}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession; {

	// Invoked by SPSession after a successful login.

	// [self.loginWindow orderOut:self];
    [self.loginWindow close];
}

- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {

	// Invoked by SPSession after a failed login.

    [NSApp presentError:error
         modalForWindow:self.loginWindow
               delegate:nil
     didPresentSelector:nil
            contextInfo:nil];
}

-(void)sessionDidLogOut:(SPSession *)aSession; {}
-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {}
-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {}
-(void)sessionDidChangeMetadata:(SPSession *)aSession; {}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {

	[[NSAlert alertWithMessageText:aMessage
					 defaultButton:@"OK"
				   alternateButton:@""
					   otherButton:@""
		 informativeTextWithFormat:@"This message was sent to you from the Spotify service."] runModal];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	if ([SPSession sharedSession].connectionState == SP_CONNECTION_STATE_LOGGED_OUT ||
		[SPSession sharedSession].connectionState == SP_CONNECTION_STATE_UNDEFINED)
		return NSTerminateNow;

	[[SPSession sharedSession] logout:^{
		[[NSApplication sharedApplication] replyToApplicationShouldTerminate:YES];
	}];

	return NSTerminateLater;
}



@end