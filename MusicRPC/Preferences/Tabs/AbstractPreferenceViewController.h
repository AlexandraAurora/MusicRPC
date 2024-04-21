//
//  AbstractPreferenceViewController.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <AppKit/AppKit.h>

@class PreferenceManager;

@interface AbstractPreferenceViewController : NSViewController {
    PreferenceManager* _preferenceManager;
}
@end
