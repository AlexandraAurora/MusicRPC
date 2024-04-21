//
//  AppDelegate.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <AppKit/AppKit.h>

static NSUInteger const kTimeoutReconnect = 5;
static NSUInteger const kTimeoutCallbacks = 1;

static NSString* const kBundleIdentifierAppleMusic = @"com.apple.Music";
static NSString* const kBundleIdentifierSpotify = @"com.spotify.client";
static NSString* const kBundleIdentifierTidal = @"com.tidal.desktop";
static NSString* const kBundleIdentifierDeezer = @"com.deezer.deezer-desktop";

static int64_t const kClientIdNone = 0;
static int64_t const kClientIdAppleMusic = 1245257240890310686;
static int64_t const kClientIdSpotify = 1245257414715113573;
static int64_t const kClientIdTidal = 1245257493966225488;
static int64_t const kClientIdDeezer = 1245257566779609141;

static NSString* const kItunesApiEndpoint = @"https://api.aurora.codes/v1/musicrpc/artwork/";
static NSString* const kItunesApiEndpointKeyText = @"text";

static NSUInteger threadVersion = 0;
static NSMutableArray* enabledApps;

static BOOL pfAppleMusicEnabled;
static BOOL pfSpotifyEnabled;
static BOOL pfTidalEnabled;
static BOOL pfDeezerEnabled;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem* _statusItem;
    NSDictionary* _clientIdMap;
    NSDictionary* _serviceMap;
    NSString* _userUsernameHash;
    NSDictionary* _nowPlayingInfo;
    BOOL _isPlaying;
    pid_t _nowPlayingApplicationPID;
    NSString* _lastArtworkTerm;
    NSURL* _lastArtworkUrl;
}
- (void)loadPreferences;
@end
