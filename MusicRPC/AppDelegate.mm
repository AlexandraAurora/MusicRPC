//
//  AppDelegate.mm
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AppDelegate.hpp"
#import <thread>
#import "Environment.h"
#import "MediaRemote.h"
#import "Preferences/PreferenceManager.h"
#import "Preferences/PreferenceWindowController.h"
#import "RPC/discord.h"
#import "Utils/CFUtil.h"
#import "Utils/HashUtil.h"

discord::Core* core;

@interface AppDelegate ()
@end

@implementation AppDelegate
/**
 * Registers and initializes required classes for later use.
 */
- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[Environment sharedInstance] setAppDelegate:self];
    [[Environment sharedInstance] setPreferenceManager:[[PreferenceManager alloc] init]];
    [[Environment sharedInstance] setPreferenceWindowController:[[PreferenceWindowController alloc] init]];
}

/**
 * Sets up, loads and registers a few things.
 *
 * Defines the Client IDs and services.
 * Loads the preferences.
 * Registers the MediaRemote notification observers.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _clientIdMap = @{
        kBundleIdentifierAppleMusic: @(kClientIdAppleMusic),
        kBundleIdentifierSpotify: @(kClientIdSpotify),
        kBundleIdentifierTidal: @(kClientIdTidal),
        kBundleIdentifierDeezer: @(kClientIdDeezer)
    };
    _serviceMap = @{
        kBundleIdentifierAppleMusic: NSLocalizedString(@"AppleMusic", nil),
        kBundleIdentifierSpotify: NSLocalizedString(@"Spotify", nil),
        kBundleIdentifierTidal: NSLocalizedString(@"Tidal", nil),
        kBundleIdentifierDeezer: NSLocalizedString(@"Deezer", nil)
    };

    [self loadPreferences];

    [self createStatusItemMenu];

    // Register the app to receive notifications by the MediaRemote framework.
    MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_queue_main_t());
    // Now the app can listen for notifications when the now-playing info changes.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoDidChange) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
}

/**
 * Creates the status item's menu.
 *
 * The menu is re-created when the now-playing data changes.
 */
- (void)createStatusItemMenu {
    [_statusItem setMenu:[[NSMenu alloc] init]];
    [[_statusItem button] setImage:[NSImage imageWithSystemSymbolName:@"music.note.list" accessibilityDescription:nil]];
    
    NSMenuItem* nowPlayingTitleItem;
    if (_nowPlayingInfo && _isPlaying) {
        NSString* songTitle = [self getTitleFromNowPlayingInfo:_nowPlayingInfo];
        NSString* songArtist = [self getArtistFromNowPlayingInfo:_nowPlayingInfo];
        NSString* songAlbum = [self getAlbumFromNowPlayingInfo:_nowPlayingInfo];
        
        nowPlayingTitleItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"StatusItemNowPlaying", nil) action:nil keyEquivalent:@""];
        [nowPlayingTitleItem setEnabled:NO];
        [[_statusItem menu] addItem:nowPlayingTitleItem];
        
        NSMenuItem* songTitleItem = [[NSMenuItem alloc] initWithTitle:songTitle action:nil keyEquivalent:@""];
        [songTitleItem setEnabled:NO];
        [songTitleItem setIndentationLevel:1];
        [[_statusItem menu] addItem:songTitleItem];
        
        NSString* artistItemTitle = [NSString stringWithFormat:@"%@ — %@", songArtist, songAlbum];
        NSMenuItem* artistItem = [[NSMenuItem alloc] initWithTitle:artistItemTitle action:nil keyEquivalent:@""];
        [artistItem setEnabled:NO];
        [artistItem setIndentationLevel:1];
        [[_statusItem menu] addItem:artistItem];
    } else {
        nowPlayingTitleItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"StatusItemNotPlaying", nil) action:nil keyEquivalent:@""];
        [nowPlayingTitleItem setEnabled:NO];
        [[_statusItem menu] addItem:nowPlayingTitleItem];
    }
    
    [[_statusItem menu] addItem:[NSMenuItem separatorItem]];

    NSString* aboutItemTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"StatusItemAbout", nil), [CFUtil getNameFromBundle:[NSBundle mainBundle]]];
    NSMenuItem* aboutItem = [[NSMenuItem alloc] initWithTitle:aboutItemTitle action:@selector(openAbout) keyEquivalent:@""];
    [[_statusItem menu] addItem:aboutItem];

    NSString* preferencesItemTitle = NSLocalizedString(@"StatusItemPreferences", nil);
    NSMenuItem* preferencesItem = [[NSMenuItem alloc] initWithTitle:preferencesItemTitle action:@selector(openPreferences) keyEquivalent:@","];
    [[_statusItem menu] addItem:preferencesItem];
    
    [[_statusItem menu] addItem:[NSMenuItem separatorItem]];
    
    NSString* quitItemTitle = [NSString stringWithFormat:@"%@ %@...", NSLocalizedString(@"StatusItemQuit", nil), [CFUtil getNameFromBundle:[NSBundle mainBundle]]];
    NSMenuItem* quitItem = [[NSMenuItem alloc] initWithTitle:quitItemTitle action:@selector(quit) keyEquivalent:@"q"];
    [[_statusItem menu] addItem:quitItem];
}

/**
 * Opens the about panel.
 */
- (void)openAbout {
    [[[Environment sharedInstance] preferenceWindowController] showWithTab:PreferenceTabAbout];
}

/**
 * Opens the preferences panel.
 */
- (void)openPreferences {
    [[[Environment sharedInstance] preferenceWindowController] show];
}

/**
 * Quits the app.
 */
- (void)quit {
    [[NSApplication sharedApplication] terminate:nil];
}

/**
 * Calls the updateNowPlayingInfo() function.
 *
 * This method acts as the NSNotification callback.
 */
- (void)nowPlayingInfoDidChange {
    updateNowPlayingInfo();
}

/**
 * Updates the now-playing info.
 *
 * Updates/clears the RPC and status item menu accordingly.
 */
void updateNowPlayingInfo() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];

    // Getting the data needs to be done first.
    // Else, the following blocks won't have the latest data.
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        // Clear the RPC when nothing is playing.
        if (!information) {
            clearRichPresence();
            return;
        }
        NSDictionary* nowPlayingInfo = (__bridge NSDictionary *)information;

        MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
            // Clear the RPC when the player is paused.
            if (!isPlaying) {
                clearRichPresence();
                return;
            }
            self->_isPlaying = isPlaying;

            MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int PID) {
                /**
                 * Depending on the now-playing app, the info is updated up to ten times at once.
                 * To prevent RPC rate limits, the updates are reduced up to nine times.
                 *
                 * Either one of the song title, artist and album change when a new song starts playing.
                 * The timestamps change when seeking or the same song starts again.
                 * The song title,.. is checked, because Apple Music sometimes returns 0 for the timestamps...
                 * Meaning, if 0 is returned for the current *and* next song, the RPC wouldn't be updated for the next song.
                 */
                NSString* newSongTitle = [self getTitleFromNowPlayingInfo:nowPlayingInfo];
                NSString* currentSongTitle = [self getTitleFromNowPlayingInfo:self->_nowPlayingInfo];
                NSString* newSongArtist = [self getArtistFromNowPlayingInfo:nowPlayingInfo];
                NSString* currentSongArtist = [self getArtistFromNowPlayingInfo:self->_nowPlayingInfo];
                NSString* newSongAlbum = [self getAlbumFromNowPlayingInfo:nowPlayingInfo];
                NSString* currentSongAlbum = [self getAlbumFromNowPlayingInfo:self->_nowPlayingInfo];
                CGFloat newSongDuration = [self getDurationFromNowPlayingInfo:nowPlayingInfo];
                CGFloat currentSongDuration = [self getDurationFromNowPlayingInfo:self->_nowPlayingInfo];
                CGFloat newSongElapsedTime = [self getTimeElapsedFromNowPlayingInfo:nowPlayingInfo];
                CGFloat currentSongElapsedTime = [self getTimeElapsedFromNowPlayingInfo:self->_nowPlayingInfo];

                if ([newSongTitle isEqualToString:currentSongTitle] &&
                    [newSongArtist isEqualToString:currentSongArtist] &&
                    [newSongAlbum isEqualToString:currentSongAlbum] &&
                    newSongDuration == currentSongDuration &&
                    newSongElapsedTime == currentSongElapsedTime
                ) {
                    return;
                }
                self->_nowPlayingInfo = nowPlayingInfo;

                // Check if the now-playing app is one of the apps listed in the preferences.
                NSString* bundleIdentifier = [self getBundleIdentifierForNowPlayingApplicationWithPID:PID];
                if (![enabledApps containsObject:bundleIdentifier]) {
                    return;
                }

                // Re-initialize the RPC when the now-playing app changes.
                if (PID != self->_nowPlayingApplicationPID) {
                    killRichPresence();
                    // The RPC is put on another thread, so that the main thread can continue running normally.
                    std::thread (initRPC).detach();
                }
                self->_nowPlayingApplicationPID = PID;

                updateRichPresence();
                [self createStatusItemMenu];
            });
        });
    });
}

/**
 * Initializes and keeps the connection to the Discord client alive.
 */
void initRPC() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];
    self->_userUsernameHash = nil;

    // Wait until a valid Client ID is returned.
    // This happens as the now-playing app PID becomes available.
    int64_t clientId = kClientIdNone;
    for (;;) {
        clientId = getClientId();
        if (kClientIdNone != clientId) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    // Wait until the connection to the Discord client has been established.
    discord::Result create_result = discord::Result::NotRunning;
    for (;;) {
        create_result = discord::Core::Create(clientId, DiscordCreateFlags_NoRequireDiscord, &core);
        if (discord::Result::Ok == create_result) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    setUserUsernameHash();

    // Run callbacks as long as the "thread version" doesn't change.
    // The version is increased every time a new valid app starts playing.
    // This way the current thread is terminated.
    NSUInteger currentThreadVersion = threadVersion;
    while (currentThreadVersion == threadVersion) {
        if (!core) {
            continue;
        }

        // Re-initialize the RPC when the connection to the Discord client is lost.
        discord::Result callbacks_result = core->RunCallbacks();
        if (discord::Result::Ok != callbacks_result) {
            initRPC();
        }

        sleep(kTimeoutCallbacks);
    }
}

/**
 * Returns the Client ID assigned the corresponding now-playing app.
 */
int64_t getClientId() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];
    NSString* bundleIdentifier = [self getBundleIdentifierForNowPlayingApplicationWithPID:self->_nowPlayingApplicationPID];
    NSNumber* clientId = self->_clientIdMap[bundleIdentifier];
    return clientId ? [clientId unsignedLongLongValue] : kClientIdNone;
}

/**
 * Waits for Discord to call the OnCurrentUserUpdate.Connect function and then saves the username as a SHA1 hash.
 */
void setUserUsernameHash() {
    core->UserManager().OnCurrentUserUpdate.Connect([=] {
        discord::User user{};
        core->UserManager().GetCurrentUser(&user);

        AppDelegate* self = [[Environment sharedInstance] appDelegate];
        NSString* username = [NSString stringWithCString:user.GetUsername() encoding:[NSString defaultCStringEncoding]];
        self->_userUsernameHash = [HashUtil getSHA1ForString:username];

        // Update the RPC when the new hash is known.
        // If it would be updated somewhere else before, the artwork won't be available.
        updateNowPlayingInfo();
    });
}

/**
 * Updates the RPC with the current now-playing info.
 *
 * This function is intended to be only called by updateNowPlayingInfo().
 */
void updateRichPresence() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];

    [self fetchItunesArtworkForNowPlayingInfo:self->_nowPlayingInfo completion:^(NSURL* artworkUrl) {
        // Check if the core is still available once the artwork has been fetched.
        // There's also the possibility that the core's private internal_ property isn't initialized yet.
        if (!core || !*(uintptr_t *)core) {
            return;
        }

        NSString* bundleIdentifier = [self getBundleIdentifierForNowPlayingApplicationWithPID:self->_nowPlayingApplicationPID];
        NSString* songTitle = [self getTitleFromNowPlayingInfo:self->_nowPlayingInfo];
        NSString* songAlbum = [self getAlbumFromNowPlayingInfo:self->_nowPlayingInfo];
        NSString* songArtist = [self getArtistFromNowPlayingInfo:self->_nowPlayingInfo];
        CGFloat songDuration = [self getDurationFromNowPlayingInfo:self->_nowPlayingInfo];
        CGFloat songElapsedTime = [self getTimeElapsedFromNowPlayingInfo:self->_nowPlayingInfo];

        // The song title and artist are the minimum required info.
        // If they don't exist, don't update the RPC.
        if ([songTitle isEqualToString:@""] && [songArtist isEqualToString:@""]) {
            clearRichPresence();
            return;
        }

        discord::Activity activity{};

        activity.SetType(discord::ActivityType::Playing);
        activity.SetDetails([songTitle UTF8String]);
        activity.SetState([songArtist UTF8String]);

        if (artworkUrl) {
            activity.GetAssets().SetLargeImage([[artworkUrl absoluteString] UTF8String]);

            NSString* description = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SmallImageDescription", nil), self->_serviceMap[bundleIdentifier]];
            activity.GetAssets().SetSmallImage([@"appicon" UTF8String]);
            activity.GetAssets().SetSmallText([description UTF8String]);
        } else {
            activity.GetAssets().SetLargeImage([@"appicon" UTF8String]);
        }
        activity.GetAssets().SetLargeText([songAlbum UTF8String]);

        // Don't show a timestamp if no duration is available.
        // Deezer for example doesn't provide timestamps at all.
        if (songDuration > 0) {
            CGFloat remainingTime = songDuration - songElapsedTime;
            activity.GetTimestamps().SetEnd(time(nullptr) + (NSUInteger)remainingTime);
        }

        core->ActivityManager().UpdateActivity(activity, [](discord::Result result) {});
    }];
}

/**
 * Clears the RPC.
 */
void clearRichPresence() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];

    self->_nowPlayingInfo = nil;
    self->_lastArtworkTerm = nil;
    self->_lastArtworkUrl = nil;
    [self createStatusItemMenu];

    if (!core) {
        return;
    }

    // The Discord Game SDK has a known bug that the ClearActivity function doesn't work.
    // Killing the RPC is my workaround.

    // core->ActivityManager().ClearActivity([](discord::Result result) {});

    killRichPresence();
}

/**
 * Kills the current RPC thread.
 */
void killRichPresence() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];

    // Increase the thread version so that the current RPC thread's callback loop breaks, and thus the thread terminates.
    threadVersion++;

    delete core;
    core = nullptr;

    // Set the now-playing app PID to null, so that when the same app plays again, the RPC is re-initialized.
    self->_nowPlayingApplicationPID = NULL;
}

/**
 * Fetches the artwork for the current song.
 *
 * I made my own temporary "link shortener" API, because the Discord Game SDK has a limit of 128 characters for the SetLargeImage function.
 * Artwork URLs returned by the iTunes search API are often longer than that.
 *
 * My API doesn't do more than call https://itunes.apple.com/search?media=music&entity=song&term= and generate a short URL for it.
 * The returned short URLs are linked to the user's Discord username hash, so only one link shortener exists for one user.
 */
- (void)fetchItunesArtworkForNowPlayingInfo:(NSDictionary *)nowPlayingInfo completion:(void (^)(NSURL* artworkUrl))completion {
    if (!_userUsernameHash) {
        completion(nil);
        return;
    }

    NSString* songTitle = [self getTitleFromNowPlayingInfo:self->_nowPlayingInfo];
    NSString* songArtist = [self getArtistFromNowPlayingInfo:self->_nowPlayingInfo];
    NSString* songAlbum = [self getAlbumFromNowPlayingInfo:self->_nowPlayingInfo];

    // If the last search term contains the same artist and album name, return the last artwork url.
    if ([_lastArtworkTerm containsString:[NSString stringWithFormat:@"%@ %@", songArtist, songAlbum]]) {
        completion(_lastArtworkUrl);
        return;
    }
    _lastArtworkTerm = [NSString stringWithFormat:@"%@ %@ %@", songTitle, songArtist, songAlbum];
    
    NSString* term = _lastArtworkTerm;
    // The iTunes API doesn't return any result if * is included.
    term = [term stringByReplacingOccurrencesOfString:@"*" withString:@""];
    term = [term stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", kItunesApiEndpoint, term, _userUsernameHash]];
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
        if (error) {
            completion(nil);
            return;
        }

        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            completion(nil);
            return;
        }

        NSString* responseUrl = json[@"text"];
        if (responseUrl) {
            self->_lastArtworkUrl = [NSURL URLWithString:responseUrl];
            completion(self->_lastArtworkUrl);
            return;
        }

        completion(nil);
    }];

    [task resume];
}

/**
 * Extracts the song title from the current now-playing info.
 */
- (NSString *)getTitleFromNowPlayingInfo:(NSDictionary *)nowPlayingInfo {
    return nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] ?: @"";
}

/**
 * Extracts the song album from the current now-playing info.
 */
- (NSString *)getAlbumFromNowPlayingInfo:(NSDictionary *)nowPlayingInfo {
    return nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] ?: @"";
}

/**
 * Extracts the song artist from the current now-playing info.
 */
- (NSString *)getArtistFromNowPlayingInfo:(NSDictionary *)nowPlayingInfo {
    return nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] ?: @"";
}

/**
 * Extracts the song duration from the current now-playing info.
 */
- (CGFloat)getDurationFromNowPlayingInfo:(NSDictionary *)nowPlayingInfo {
    NSString* duration = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration] ?: @"0";
    return [duration doubleValue];
}

/**
 * Extracts the song elapsed time from the current now-playing info.
 */
- (CGFloat)getTimeElapsedFromNowPlayingInfo:(NSDictionary *)nowPlayingInfo {
    NSString* elapsedTime = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] ?: @"0";
    return [elapsedTime doubleValue];
}

/**
 * Returns the Bundle Identifier for the current now-playing app.
 */
- (NSString *)getBundleIdentifierForNowPlayingApplicationWithPID:(pid_t)pid {
    NSRunningApplication* application = [NSRunningApplication runningApplicationWithProcessIdentifier:pid];
    return [application bundleIdentifier];
}

/**
 * Loads the user's preferences.
 */
- (void)loadPreferences {
    PreferenceManager* preferenceManager = [[Environment sharedInstance] preferenceManager];
    pfAppleMusicEnabled = [preferenceManager appleMusicEnabled];
    pfSpotifyEnabled = [preferenceManager spotifyEnabled];
    pfTidalEnabled = [preferenceManager tidalEnabled];
    pfDeezerEnabled = [preferenceManager deezerEnabled];

    enabledApps = [@[] mutableCopy];
    if (pfAppleMusicEnabled) {
        [enabledApps addObject:kBundleIdentifierAppleMusic];
    }
    if (pfSpotifyEnabled) {
        [enabledApps addObject:kBundleIdentifierSpotify];
    }
    if (pfTidalEnabled) {
        [enabledApps addObject:kBundleIdentifierTidal];
    }
    if (pfDeezerEnabled) {
        [enabledApps addObject:kBundleIdentifierDeezer];
    }

    // Initialize the RPC again after preferences have changed.
    killRichPresence();
    updateNowPlayingInfo();
}
@end
