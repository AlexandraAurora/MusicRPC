//
//  AboutPreferenceViewController.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractPreferenceViewController.h"

@class SeparatorCell;

@interface AboutPreferenceViewController : AbstractPreferenceViewController
@property(nonatomic)NSTextField* titleLabel;
@property(nonatomic)NSTextField* versionLabel;
@property(nonatomic)SeparatorCell* versionSeparatorCell;
@property(nonatomic)NSButton* sponsorButton;
@property(nonatomic)NSTextField* sponsorLabel;
@property(nonatomic)SeparatorCell* sponsorSeparatorCell;
@property(nonatomic)NSButton* githubButton;
@property(nonatomic)NSTextField* creditsLabel;
@property(nonatomic)SeparatorCell* creditsSeparatorCell;
@property(nonatomic)NSTextField* copyrightLabel;
@end
