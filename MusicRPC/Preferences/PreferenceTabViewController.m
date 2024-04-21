//
//  PreferenceTabViewController.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "PreferenceTabViewController.h"
#import "GeneralPreferenceViewController.h"
#import "AboutPreferenceViewController.h"

@implementation PreferenceTabViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTabStyle:NSTabViewControllerTabStyleToolbar];

    NSTabViewItem* generalTabItem = [[NSTabViewItem alloc] initWithIdentifier:@"General"];
    [generalTabItem setViewController:[[GeneralPreferenceViewController alloc] init]];
    [generalTabItem setLabel:NSLocalizedString(@"PreferencesTabGeneral", nil)];
    [generalTabItem setImage:[NSImage imageWithSystemSymbolName:@"gearshape" accessibilityDescription:nil]];
    [self addTabViewItem:generalTabItem];

    NSTabViewItem* aboutTabItem = [[NSTabViewItem alloc] initWithIdentifier:@"About"];
    [aboutTabItem setViewController:[[AboutPreferenceViewController alloc] init]];
    [aboutTabItem setLabel:NSLocalizedString(@"PreferencesTabAbout", nil)];
    [aboutTabItem setImage:[NSImage imageWithSystemSymbolName:@"info.circle" accessibilityDescription:nil]];
    [self addTabViewItem:aboutTabItem];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [[[self view] window] setTitle:[[self tabViewItems][0] label]];
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    [super tabView:tabView didSelectTabViewItem:tabViewItem];
    [[[self view] window] setTitle:[tabViewItem label]];
}
@end
