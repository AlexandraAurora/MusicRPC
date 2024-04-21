//
//  GeneralPreferenceViewController.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "GeneralPreferenceViewController.h"
#import "../../AppDelegate.hpp"
#import "../../Environment.h"
#import "../PreferenceManager.h"
#import "../PreferenceKeys.h"
#import "Cells/CheckboxCell.h"
#import "Cells/DropdownCell.h"
#import "Cells/DescriptionCell.h"
#import "Cells/SeparatorCell.h"
#import "ServiceManagement/ServiceManagement.h"

@implementation GeneralPreferenceViewController
- (instancetype)init {
    self = [super init];

    if (self) {
        _appDelegate = [[Environment sharedInstance] appDelegate];
    }

    return self;
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [[[self view] window] setContentSize:NSSizeFromCGSize(CGSizeMake(430, 190))];
}

- (void)loadView {
    [self setView:[[NSView alloc] init]];

    NSString* appleMusicEnabledCellTitle = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"GeneralPreferencesEnabledApps", nil)];
    [self setAppleMusicEnabledCell:[[CheckboxCell alloc] init]];
    [[self appleMusicEnabledCell] setTarget:self];
    [[self appleMusicEnabledCell] setAction:@selector(setAppleMusicEnabled)];
    [[self appleMusicEnabledCell] setTitle:appleMusicEnabledCellTitle];
    [[self appleMusicEnabledCell] setCheckboxTitle:NSLocalizedString(@"AppleMusic", nil)];
    [[self view] addSubview:[self appleMusicEnabledCell]];

    [[self appleMusicEnabledCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self appleMusicEnabledCell] heightAnchor] constraintEqualToConstant:20],
        [[[self appleMusicEnabledCell] topAnchor] constraintEqualToAnchor:[[self view] topAnchor] constant:16],
        [[[self appleMusicEnabledCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:40],
        [[[self appleMusicEnabledCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-40]
    ]];

    [self setSpotifyEnabledCell:[[CheckboxCell alloc] init]];
    [[self spotifyEnabledCell] setTarget:self];
    [[self spotifyEnabledCell] setAction:@selector(setSpotifyEnabled)];
    [[self spotifyEnabledCell] setCheckboxTitle:NSLocalizedString(@"Spotify", nil)];
    [[self view] addSubview:[self spotifyEnabledCell]];

    [[self spotifyEnabledCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self spotifyEnabledCell] heightAnchor] constraintEqualToConstant:20],
        [[[self spotifyEnabledCell] topAnchor] constraintEqualToAnchor:[[self appleMusicEnabledCell] bottomAnchor] constant:8],
        [[[self spotifyEnabledCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:40],
        [[[self spotifyEnabledCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-40]
    ]];

    [self setTidalEnabledCell:[[CheckboxCell alloc] init]];
    [[self tidalEnabledCell] setTarget:self];
    [[self tidalEnabledCell] setAction:@selector(setTidalEnabled)];
    [[self tidalEnabledCell] setCheckboxTitle:NSLocalizedString(@"Tidal", nil)];
    [[self view] addSubview:[self tidalEnabledCell]];

    [[self tidalEnabledCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self tidalEnabledCell] heightAnchor] constraintEqualToConstant:20],
        [[[self tidalEnabledCell] topAnchor] constraintEqualToAnchor:[[self spotifyEnabledCell] bottomAnchor] constant:8],
        [[[self tidalEnabledCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:40],
        [[[self tidalEnabledCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-40]
    ]];

    [self setDeezerEnabledCell:[[CheckboxCell alloc] init]];
    [[self deezerEnabledCell] setTarget:self];
    [[self deezerEnabledCell] setAction:@selector(setDeezerEnabled)];
    [[self deezerEnabledCell] setCheckboxTitle:NSLocalizedString(@"Deezer", nil)];
    [[self view] addSubview:[self deezerEnabledCell]];

    [[self deezerEnabledCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self deezerEnabledCell] heightAnchor] constraintEqualToConstant:20],
        [[[self deezerEnabledCell] topAnchor] constraintEqualToAnchor:[[self tidalEnabledCell] bottomAnchor] constant:8],
        [[[self deezerEnabledCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:40],
        [[[self deezerEnabledCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-40]
    ]];

    [self setSeparatorCell:[[SeparatorCell alloc] init]];
    [[self view] addSubview:[self separatorCell]];

    [[self separatorCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self separatorCell] topAnchor] constraintEqualToAnchor:[[self deezerEnabledCell] bottomAnchor] constant:16],
        [[[self separatorCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:40],
        [[[self separatorCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-40]
    ]];

    NSString* launchAtLoginCellTitle = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"GeneralPreferencesStartup", nil)];
    NSString* launchAtLoginCellCheckboxTitle = NSLocalizedString(@"GeneralPreferencesStartupLabel", nil);
    [self setLaunchAtLoginCell:[[CheckboxCell alloc] init]];
    [[self launchAtLoginCell] setTarget:self];
    [[self launchAtLoginCell] setAction:@selector(setLaunchAtLogin)];
    [[self launchAtLoginCell] setTitle:launchAtLoginCellTitle];
    [[self launchAtLoginCell] setCheckboxTitle:launchAtLoginCellCheckboxTitle];
    [[self view] addSubview:[self launchAtLoginCell]];

    [[self launchAtLoginCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self launchAtLoginCell] heightAnchor] constraintEqualToConstant:20],
        [[[self launchAtLoginCell] topAnchor] constraintEqualToAnchor:[[self separatorCell] bottomAnchor] constant:16],
        [[[self launchAtLoginCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:40],
        [[[self launchAtLoginCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-40]
    ]];

    [self loadPreferences];
}

- (void)setAppleMusicEnabled {
    BOOL appleMusicEnabled = [[self appleMusicEnabledCell] getIsOn];
    [_preferenceManager setPreference:@(appleMusicEnabled) forKey:kPreferenceKeyAppleMusicEnabled];
    [_appDelegate loadPreferences];
}

- (void)setSpotifyEnabled {
    BOOL spotifyEnabled = [[self spotifyEnabledCell] getIsOn];
    [_preferenceManager setPreference:@(spotifyEnabled) forKey:kPreferenceKeySpotifyEnabled];
    [_appDelegate loadPreferences];
}

- (void)setTidalEnabled {
    BOOL tidalEnabled = [[self tidalEnabledCell] getIsOn];
    [_preferenceManager setPreference:@(tidalEnabled) forKey:kPreferenceKeyTidalEnabled];
    [_appDelegate loadPreferences];
}

- (void)setDeezerEnabled {
    BOOL deezerEnabled = [[self deezerEnabledCell] getIsOn];
    [_preferenceManager setPreference:@(deezerEnabled) forKey:kPreferenceKeyDeezerEnabled];
    [_appDelegate loadPreferences];
}

- (void)setLaunchAtLogin {
    BOOL launchAtLogin = [[self launchAtLoginCell] getIsOn];
    [_preferenceManager setPreference:@(launchAtLogin) forKey:kPreferenceKeyLaunchAtLogin];
    SMLoginItemSetEnabled((__bridge CFStringRef)@"codes.aurora.MusicRPCAutoLauncher", (Boolean)launchAtLogin);
}

- (void)loadPreferences {
    BOOL appleMusicEnabled = [_preferenceManager appleMusicEnabled];
    BOOL spotifyEnabled = [_preferenceManager spotifyEnabled];
    BOOL tidalEnabled = [_preferenceManager tidalEnabled];
    BOOL deezerEnabled = [_preferenceManager deezerEnabled];
    BOOL launchAtLogin = [_preferenceManager launchAtLogin];

    [[self appleMusicEnabledCell] setOn:appleMusicEnabled];
    [[self spotifyEnabledCell] setOn:spotifyEnabled];
    [[self tidalEnabledCell] setOn:tidalEnabled];
    [[self deezerEnabledCell] setOn:deezerEnabled];
    [[self launchAtLoginCell] setOn:launchAtLogin];
}
@end
