//
//  PreferenceWindowController.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSUInteger, PreferenceTabTypes) {
    PreferenceTabGeneral = 0,
    PreferenceTabAbout = 1
};

@interface PreferenceWindowController : NSWindowController {
    BOOL _hasCenteredWindow;
}
- (void)show;
- (void)showWithTab:(PreferenceTabTypes)tab;
@end
