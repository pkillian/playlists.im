//
//  AppDelegate.h
//  Playlists
//
//  Created by Patrick Killian on 2/23/14.
//  Copyright (c) 2014 playlists.im. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, SPSessionDelegate> {
@private
    SPPlaybackManager *playbackManager;
}

@property (nonatomic, readwrite, strong) SPPlaybackManager *playbackManager;


# pragma mark -
# pragma mark Login Window

@property (unsafe_unretained) IBOutlet NSWindow *loginWindow;
@property (weak) IBOutlet NSProgressIndicator *loginProgress;
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSButton *playButton;
@property (weak) IBOutlet NSButton *pauseButton;

- (IBAction)login:(id)sender;
- (IBAction)quit:(id)sender;


# pragma mark -
# pragma mark Main Window

@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *uriField;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

@end