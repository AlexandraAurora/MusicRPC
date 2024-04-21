//
//  PreferenceManager.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Foundation/Foundation.h>

@interface PreferenceManager : NSObject {
    NSUserDefaults* _userDefaults;
}
@property(nonatomic, assign)BOOL appleMusicEnabled;
@property(nonatomic, assign)BOOL spotifyEnabled;
@property(nonatomic, assign)BOOL tidalEnabled;
@property(nonatomic, assign)BOOL deezerEnabled;
@property(nonatomic, assign)BOOL launchAtLogin;
- (void)setPreference:(id)value forKey:(NSString *)key;
@end
