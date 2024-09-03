//
//  GeneralPreferenceViewController.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractPreferenceViewController.h"

@class AppDelegate;
@class CheckboxCell;
@class SeparatorCell;

@interface GeneralPreferenceViewController : AbstractPreferenceViewController {
    AppDelegate* _appDelegate;
}
@property(nonatomic)CheckboxCell* appleMusicEnabledCell;
@property(nonatomic)CheckboxCell* iTunesEnabledCell;
@property(nonatomic)CheckboxCell* spotifyEnabledCell;
@property(nonatomic)CheckboxCell* tidalEnabledCell;
@property(nonatomic)CheckboxCell* deezerEnabledCell;
@property(nonatomic)CheckboxCell* foobar2000EnabledCell;
@property(nonatomic)SeparatorCell* separatorCell;
@property(nonatomic)CheckboxCell* launchAtLoginCell;
@end
