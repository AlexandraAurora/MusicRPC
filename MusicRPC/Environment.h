//
//  Environment.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Foundation/Foundation.h>

@class AppDelegate;
@class PreferenceManager;
@class PreferenceWindowController;

@interface Environment : NSObject
@property(nonatomic)AppDelegate* appDelegate;
@property(nonatomic)PreferenceManager* preferenceManager;
@property(nonatomic)PreferenceWindowController* preferenceWindowController;
+ (instancetype)sharedInstance;
@end
