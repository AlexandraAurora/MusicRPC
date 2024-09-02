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
#import "RPC/discord_rpc.h"
#import "Preferences/PreferenceManager.h"
#import "Preferences/PreferenceWindowController.h"
#import "Utils/CFUtil.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURL *> *artworkCache;
@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadArtworkCache];
    }
    return self;
}

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
        kBundleIdentifierAppleMusic: kClientIdAppleMusic,
        kBundleIdentifierSpotify: kClientIdSpotify,
        kBundleIdentifierTidal: kClientIdTidal,
        kBundleIdentifierDeezer: kClientIdDeezer,
        kBundleIdentifierFoobar2000: kClientIdFoobar2000
    };
    _serviceMap = @{
        kBundleIdentifierAppleMusic: NSLocalizedString(@"AppleMusic", nil),
        kBundleIdentifierSpotify: NSLocalizedString(@"Spotify", nil),
        kBundleIdentifierTidal: NSLocalizedString(@"Tidal", nil),
        kBundleIdentifierDeezer: NSLocalizedString(@"Deezer", nil),
        kBundleIdentifierFoobar2000: NSLocalizedString(@"Foobar2000", nil)
    };
    _lookupEndpointMap = @{
        kBundleIdentifierAppleMusic: kLookupEndpointAppleMusic,
        kBundleIdentifierSpotify: kLookupEndpointSpotify,
        kBundleIdentifierTidal: kLookupEndpointTidal,
        kBundleIdentifierDeezer: kLookupEndpointDeezer
    };

    [self loadPreferences];

    [self createStatusItemMenu];
    updateNowPlayingInfo();

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
    // Wait until a valid Client ID is returned.
    // This happens as the now-playing app PID becomes available.
    NSString* clientId = kClientIdNone;
    for (;;) {
        clientId = getClientId();
        if (kClientIdNone != clientId) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    for (;;) {
        DiscordEventHandlers discordHandler{};
        Discord_Initialize([clientId UTF8String], &discordHandler);
        if (Discord_IsConnected()) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    // Run callbacks as long as the "thread version" doesn't change.
    // The version is increased every time a new valid app starts playing.
    // This way the current thread is terminated.
    NSUInteger currentThreadVersion = threadVersion;
    while (currentThreadVersion == threadVersion) {
        // Re-initialize the RPC when the connection to the Discord client is lost.
        Discord_RunCallbacks();
        if (!Discord_IsConnected()) {
            initRPC();
        }
        sleep(kTimeoutCallbacks);
    }
}

/**
 * Returns the Client ID assigned the corresponding now-playing app.
 */
NSString* getClientId() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];
    NSString* bundleIdentifier = [self getBundleIdentifierForNowPlayingApplicationWithPID:self->_nowPlayingApplicationPID];
    NSString* clientId = self->_clientIdMap[bundleIdentifier];
    return clientId ? clientId : kClientIdNone;
}

/**
 * Updates the RPC with the current now-playing info.
 *
 * This function is intended to be only called by updateNowPlayingInfo().
 */
void updateRichPresence() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];

    [self getAlbumArtwork:[self getArtworkBase64FromNowPlayingInfo:self->_nowPlayingInfo] completion:^(NSURL *artworkUrl, NSError *error) {
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

        DiscordRichPresence activity{};
        activity.type = LISTENING;
        activity.details = [songTitle UTF8String];
        activity.state = [[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"StatePrefix", nil), songArtist] UTF8String];

        if (artworkUrl) {
            activity.largeImageKey = [[artworkUrl absoluteString] UTF8String];
            NSString* description = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"SmallImageDescription", nil), self->_serviceMap[bundleIdentifier]];
            activity.smallImageKey = [@"appicon" UTF8String];
            activity.smallImageText = [description UTF8String];
        } else {
            activity.largeImageKey = [@"appicon" UTF8String];
        }
        activity.largeImageText = [songAlbum UTF8String];

        // Don't show a timestamp if none are available.
        // Deezer for example doesn't provide timestamps at all.
        if (songDuration > 0) {
            CGFloat remainingTime = songDuration - songElapsedTime;
            activity.endTimestamp = time(nullptr) + (NSUInteger)remainingTime;
        }

        NSString* lookupEndpoint = self->_lookupEndpointMap[bundleIdentifier];
        if (lookupEndpoint) {
            NSString* button1Title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"LookupButtonTitle", nil), self->_serviceMap[bundleIdentifier]];

            NSString* query = [NSString stringWithFormat:@"%@ %@", songTitle, songArtist];
            [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL* button1Url = [NSURL URLWithString:[lookupEndpoint stringByAppendingString:query]];

            activity.button1name = [button1Title UTF8String];
            activity.button1link = [[button1Url absoluteString] UTF8String];
        }

        Discord_UpdatePresence(&activity);
    }];
}

/**
 * Clears the RPC.
 */
void clearRichPresence() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];
    self->_nowPlayingInfo = nil;
    [self createStatusItemMenu];

    Discord_ClearPresence();
}

/**
 * Kills the current RPC thread.
 */
void killRichPresence() {
    AppDelegate* self = [[Environment sharedInstance] appDelegate];

    // Increase the thread version so that the current RPC thread's callback loop breaks, and thus the thread terminates.
    threadVersion++;
    Discord_Shutdown();

    // Set the now-playing app PID to null, so that when the same app plays again, the RPC is re-initialized.
    self->_nowPlayingApplicationPID = NULL;
}

/**
 * Fetches the artwork for the current song.
 *
 * It's trivial to get the album artwork because we're using the MediaRemote framework; however, getting it to show up in Discord is a bit more complicated.
 * We need to upload the artwork to a hosting service and then provide the URL to Discord.
 * This function takes the base64 encoded artwork data, uploads it to freeimage.host, and then returns the URL. The URL and artwork data are then cached on disk for future use.
 *
 * In comparison to using the iTunes API, we don't have to worry about the artwork matching because we're grabbing the artwork directly associated with the current track (if applicable).
 */
- (void)getAlbumArtwork:(NSString *)base64ImageData completion:(void (^)(NSURL * _Nullable imageURL, NSError * _Nullable error))completion {
    if ([base64ImageData isEqualToString:@""]) {
        completion(nil, nil);
        return;
    }
    
    // Check if the artwork is already in the cache
    NSURL *cachedURL = self.artworkCache[base64ImageData];
    if (cachedURL) {
        NSLog(@"Using cached image URL: %@", cachedURL);
        completion(cachedURL, nil);
        return;
    }

    NSString *urlString = @"https://freeimage.host/api/1/upload";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData *body = [NSMutableData data];

    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"6d207e02198a847aa98d0a2a901485a5\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    // Add image base64 data
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"source\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", base64ImageData] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:body];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error uploading image: %@", error);
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                NSLog(@"JSON serialization error: %@", jsonError);
                completion(nil, jsonError);
            } else {
                if ([json[@"status_code"] integerValue] == 200) {
                    NSString *imageUrlString = json[@"image"][@"url"];
                    if (imageUrlString) {
                        NSURL *uploadedImageUrl = [NSURL URLWithString:imageUrlString];
                        NSLog(@"Uploaded image URL: %@", uploadedImageUrl);

                        self.artworkCache[base64ImageData] = uploadedImageUrl;
                        [self saveArtworkCache];
                        
                        completion(uploadedImageUrl, nil);
                    } else {
                        NSLog(@"No image URL found in the response.");
                        NSError *noImageUrlError = [NSError errorWithDomain:@"com.example.error" code:0 userInfo:@{NSLocalizedDescriptionKey: @"No image URL found in the response."}];
                        completion(nil, noImageUrlError);
                    }
                } else {
                    NSLog(@"Failed to upload image: %@", json[@"status_txt"]);
                    NSError *uploadError = [NSError errorWithDomain:@"com.example.error" code:[json[@"status_code"] integerValue] userInfo:@{NSLocalizedDescriptionKey: json[@"status_txt"]}];
                    completion(nil, uploadError);
                }
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];

    [task resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
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
 * Extracts the album artwork to a base64 encoded string from the current now-playing info.
 */
- (NSString *)getArtworkBase64FromNowPlayingInfo:(NSDictionary *)nowPlayingInfo {
    NSData *artworkData = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
    return [artworkData base64EncodedStringWithOptions:0] ?: @"";
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
 * Returns the file path for the artwork cache.
 */
- (NSString *)artworkCacheFilePath {
    NSArray<NSURL *> *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL *appSupportDirectory = urls.firstObject;
    NSURL *musicRPCDirectory = [appSupportDirectory URLByAppendingPathComponent:@"MusicRPC" isDirectory:YES];
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:musicRPCDirectory.path]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:musicRPCDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"Error creating MusicRPC directory: %@", error);
        }
    }
    
    return [[musicRPCDirectory URLByAppendingPathComponent:@"artworkCache.plist"] path];
}

/**
 * Saves the artwork cache to a file.
 */
- (void)saveArtworkCache {
    NSString *filePath = [self artworkCacheFilePath];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.artworkCache toFile:filePath];
    if (!success) {
        NSLog(@"Failed to save artwork cache.");
    }
}

/**
 * Loads the artwork cache from a file.
 */
- (void)loadArtworkCache {
    NSString *filePath = [self artworkCacheFilePath];
    NSDictionary<NSString *, NSURL *> *cachedArtwork = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (cachedArtwork) {
        self.artworkCache = [cachedArtwork mutableCopy];
    } else {
        self.artworkCache = [NSMutableDictionary dictionary];
    }
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
    pfFoobar2000Enabled = [preferenceManager foobar2000Enabled];
    
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
    if (pfFoobar2000Enabled) {
        [enabledApps addObject:kBundleIdentifierFoobar2000];
    }

    // Initialize the RPC again after preferences have changed.
    killRichPresence();
    updateNowPlayingInfo();
}
@end
