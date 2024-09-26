//
//  AboutPreferenceViewController.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AboutPreferenceViewController.h"
#import "Cells/SeparatorCell.h"
#import "../../Utils/CFUtil.h"
#import "../../Extensions/Foundation/NSBundle+LocalizedParameters.h"

@implementation AboutPreferenceViewController
- (void)viewDidAppear {
    [super viewDidAppear];
    [[[self view] window] setContentSize:NSSizeFromCGSize(CGSizeMake(430, 320))];
}

- (void)loadView {
    [self setView:[[NSView alloc] init]];

    [self setTitleLabel:[[NSTextField alloc] init]];
    [[self titleLabel] setStringValue:[CFUtil getNameFromBundle:[NSBundle mainBundle]]];
    [[self titleLabel] setFont:[NSFont systemFontOfSize:19]];
    [[self titleLabel] setBezeled:NO];
    [[self titleLabel] setDrawsBackground:NO];
    [[self titleLabel] setEditable:NO];
    [[self titleLabel] setSelectable:NO];
    [[self view] addSubview:[self titleLabel]];

    [[self titleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self titleLabel] topAnchor] constraintEqualToAnchor:[[self view] topAnchor] constant:16],
        [[[self titleLabel] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self titleLabel] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    NSString* version = [CFUtil getVersionFromBundle:[NSBundle mainBundle]];
    NSString* versionLabelText = NSLocalizedStringWithParameters(@"PreferencesAboutVersion", @{@"Version": version});
    [self setVersionLabel:[[NSTextField alloc] init]];
    [[self versionLabel] setStringValue:versionLabelText];
    [[self versionLabel] setFont:[NSFont systemFontOfSize:14]];
    [[self versionLabel] setBezeled:NO];
    [[self versionLabel] setDrawsBackground:NO];
    [[self versionLabel] setEditable:NO];
    [[self versionLabel] setSelectable:NO];
    [[self versionLabel] setAlphaValue:0.6];
    [[self view] addSubview:[self versionLabel]];

    [[self versionLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self versionLabel] topAnchor] constraintEqualToAnchor:[[self titleLabel] bottomAnchor] constant:4],
        [[[self versionLabel] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self versionLabel] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setVersionSeparatorCell:[[SeparatorCell alloc] init]];
    [[self view] addSubview:[self versionSeparatorCell]];

    [[self versionSeparatorCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self versionSeparatorCell] topAnchor] constraintEqualToAnchor:[[self versionLabel] bottomAnchor] constant:16],
        [[[self versionSeparatorCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self versionSeparatorCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setSponsorButton:[[NSButton alloc] init]];
    [[self sponsorButton] setTarget:self];
    [[self sponsorButton] setAction:@selector(openSponsoring)];
    [[self sponsorButton] setTitle:NSLocalizedString(@"PreferencesAboutSponsor", nil)];
    [[self sponsorButton] setFont:[NSFont systemFontOfSize:14 weight:NSFontWeightMedium]];
    [[self sponsorButton] setAlignment:NSTextAlignmentLeft];
    [[self sponsorButton] setContentTintColor:[NSColor labelColor]];
    [[self sponsorButton] setBordered:NO];
    [[self view] addSubview:[self sponsorButton]];

    [[self sponsorButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self sponsorButton] topAnchor] constraintEqualToAnchor:[[self versionSeparatorCell] bottomAnchor] constant:16],
        [[[self sponsorButton] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self sponsorButton] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setSponsorLabel:[[NSTextField alloc] init]];
    [[self sponsorLabel] setStringValue:NSLocalizedString(@"PreferencesAboutSponsorAcknowledgement", nil)];
    [[self sponsorLabel] setFont:[NSFont systemFontOfSize:11]];
    [[self sponsorLabel] setBezeled:NO];
    [[self sponsorLabel] setDrawsBackground:NO];
    [[self sponsorLabel] setEditable:NO];
    [[self sponsorLabel] setSelectable:NO];
    [[self sponsorLabel] setAlphaValue:0.6];
    [[self view] addSubview:[self sponsorLabel]];

    [[self sponsorLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self sponsorLabel] topAnchor] constraintEqualToAnchor:[[self sponsorButton] bottomAnchor] constant:4],
        [[[self sponsorLabel] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self sponsorLabel] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setSponsorSeparatorCell:[[SeparatorCell alloc] init]];
    [[self view] addSubview:[self sponsorSeparatorCell]];

    [[self sponsorSeparatorCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self sponsorSeparatorCell] topAnchor] constraintEqualToAnchor:[[self sponsorLabel] bottomAnchor] constant:16],
        [[[self sponsorSeparatorCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self sponsorSeparatorCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setGithubButton:[[NSButton alloc] init]];
    [[self githubButton] setTarget:self];
    [[self githubButton] setAction:@selector(openGitHub)];
    [[self githubButton] setTitle:NSLocalizedString(@"PreferencesAboutGitHub", nil)];
    [[self githubButton] setFont:[NSFont systemFontOfSize:14 weight:NSFontWeightMedium]];
    [[self githubButton] setAlignment:NSTextAlignmentLeft];
    [[self githubButton] setContentTintColor:[NSColor labelColor]];
    [[self githubButton] setBordered:NO];
    [[self view] addSubview:[self githubButton]];

    [[self githubButton] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self githubButton] topAnchor] constraintEqualToAnchor:[[self sponsorSeparatorCell] bottomAnchor] constant:16],
        [[[self githubButton] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self githubButton] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    NSString* creditsLabelText = NSLocalizedString(@"PreferencesAboutCredits", nil);
    creditsLabelText = [NSString stringWithFormat:@"%@\n\n%@", creditsLabelText, NSLocalizedString(@"PreferencesAboutCreditsLeptos", nil)];
    creditsLabelText = [NSString stringWithFormat:@"%@\n%@", creditsLabelText, NSLocalizedString(@"PreferencesAboutCreditsEinTim23", nil)];
    creditsLabelText = [NSString stringWithFormat:@"%@\n%@", creditsLabelText, NSLocalizedString(@"PreferencesAboutCreditsNextFire", nil)];
    [self setCreditsLabel:[[NSTextField alloc] init]];
    [[self creditsLabel] setStringValue:creditsLabelText];
    [[self creditsLabel] setFont:[NSFont systemFontOfSize:11]];
    [[self creditsLabel] setBezeled:NO];
    [[self creditsLabel] setDrawsBackground:NO];
    [[self creditsLabel] setEditable:NO];
    [[self creditsLabel] setSelectable:NO];
    [[self creditsLabel] setAlphaValue:0.6];
    [[self view] addSubview:[self creditsLabel]];

    [[self creditsLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self creditsLabel] topAnchor] constraintEqualToAnchor:[[self githubButton] bottomAnchor] constant:4],
        [[[self creditsLabel] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self creditsLabel] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setCreditsSeparatorCell:[[SeparatorCell alloc] init]];
    [[self view] addSubview:[self creditsSeparatorCell]];

    [[self creditsSeparatorCell] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self creditsSeparatorCell] topAnchor] constraintEqualToAnchor:[[self creditsLabel] bottomAnchor] constant:16],
        [[[self creditsSeparatorCell] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self creditsSeparatorCell] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];

    [self setCopyrightLabel:[[NSTextField alloc] init]];

    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString* year = [dateFormatter stringFromDate:[NSDate date]];

    NSString* author = NSLocalizedString(@"MetaAuthor", nil);
    NSString* copyrightLabelText = NSLocalizedStringWithParameters(@"PreferencesAboutCopyright", @{@"Year": year, @"Author": author});
    [[self copyrightLabel] setStringValue:copyrightLabelText];
    [[self copyrightLabel] setFont:[NSFont systemFontOfSize:12]];
    [[self copyrightLabel] setBezeled:NO];
    [[self copyrightLabel] setDrawsBackground:NO];
    [[self copyrightLabel] setEditable:NO];
    [[self copyrightLabel] setSelectable:NO];
    [[self view] addSubview:[self copyrightLabel]];

    [[self copyrightLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self copyrightLabel] topAnchor] constraintEqualToAnchor:[[self creditsSeparatorCell] bottomAnchor] constant:16],
        [[[self copyrightLabel] leadingAnchor] constraintEqualToAnchor:[[self view] leadingAnchor] constant:32],
        [[[self copyrightLabel] trailingAnchor] constraintEqualToAnchor:[[self view] trailingAnchor] constant:-32]
    ]];
}

- (void)openSponsoring {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://ko-fi.com/AlexandraAurora"]];
}

- (void)openGitHub {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/AlexandraAurora/MusicRPC"]];
}
@end
