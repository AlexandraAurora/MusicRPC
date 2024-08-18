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
static NSString* const kBundleIdentifierFoobar2000 = @"com.foobar2000.mac";

static NSString* const kClientIdNone = nil;
static NSString* const kClientIdAppleMusic = @"1245257240890310686";
static NSString* const kClientIdSpotify = @"1245257414715113573";
static NSString* const kClientIdTidal = @"1245257493966225488";
static NSString* const kClientIdDeezer = @"1245257566779609141";
static NSString* const kClientIdFoobar2000 = @"1274555138962620436";

static NSString* const kItunesApiEndpoint = @"https://itunes.apple.com/search?media=music&entity=song&term=";
static NSString* const kItunesApiEndpointKeyResults = @"results";
static NSString* const kItunesApiEndpointKeyArtworkUrl = @"artworkUrl100";

static NSString* const kLookupEndpointAppleMusic = @"https://music.apple.com/search?term=";
static NSString* const kLookupEndpointSpotify = @"https://open.spotify.com/search/";
static NSString* const kLookupEndpointTidal = @"https://listen.tidal.com/search?q=";
static NSString* const kLookupEndpointDeezer = @"https://deezer.com/search/";

static NSUInteger threadVersion = 0;
static NSMutableArray* enabledApps;

static BOOL pfAppleMusicEnabled;
static BOOL pfSpotifyEnabled;
static BOOL pfTidalEnabled;
static BOOL pfDeezerEnabled;
static BOOL pfFoobar2000Enabled;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem* _statusItem;
    NSDictionary* _clientIdMap;
    NSDictionary* _serviceMap;
    NSDictionary* _lookupEndpointMap;
    NSDictionary* _nowPlayingInfo;
    BOOL _isPlaying;
    pid_t _nowPlayingApplicationPID;
    NSString* _lastArtworkTerm;
    NSURL* _lastArtworkUrl;
}
- (void)loadPreferences;
@end
