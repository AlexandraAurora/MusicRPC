//
//  PreferenceManager.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "PreferenceManager.h"
#import "PreferenceKeys.h"

@implementation PreferenceManager
- (instancetype)init {
    self = [super init];

    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        [self reloadPreferences];
    }

    return self;
}

- (void)reloadPreferences {
    [_userDefaults registerDefaults:@{
        kPreferenceKeyAppleMusicEnabled: @(kPreferenceKeyAppleMusicEnabledDefaultValue),
        kPreferenceKeySpotifyEnabled: @(kPreferenceKeySpotifyEnabledDefaultValue),
        kPreferenceKeyTidalEnabled: @(kPreferenceKeyTidalEnabledDefaultValue),
        kPreferenceKeyDeezerEnabled: @(kPreferenceKeyDeezerEnabledDefaultValue),
        kPreferenceKeyLaunchAtLogin: @(kPreferenceKeyLaunchAtLoginDefaultValue)
    }];

    [self setAppleMusicEnabled:[[_userDefaults objectForKey:kPreferenceKeyAppleMusicEnabled] boolValue]];
    [self setSpotifyEnabled:[[_userDefaults objectForKey:kPreferenceKeySpotifyEnabled] boolValue]];
    [self setTidalEnabled:[[_userDefaults objectForKey:kPreferenceKeyTidalEnabled] boolValue]];
    [self setDeezerEnabled:[[_userDefaults objectForKey:kPreferenceKeyDeezerEnabled] boolValue]];
    [self setLaunchAtLogin:[[_userDefaults objectForKey:kPreferenceKeyLaunchAtLogin] boolValue]];
}

- (void)setPreference:(id)value forKey:(NSString *)key {
    [_userDefaults setObject:value forKey:key];
    [self reloadPreferences];
}
@end
