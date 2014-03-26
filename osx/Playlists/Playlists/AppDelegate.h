//
//  AppDelegate.h
//  Playlists
//
//  Created by Patrick Killian on 2/23/14.
//  Copyright (c) 2014 playlists.im. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *mSpotifyUriField;

- (IBAction)playSong:(id)sender;
- (IBAction)playArtist:(id)sender;
- (IBAction)playPlaylist:(id)sender;
- (IBAction)clearUriField:(id)sender;

@end