//
//  CFUtil.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <AppKit/AppKit.h>

@interface CFUtil : NSObject
+ (NSString *)getNameFromBundle:(NSBundle *)bundle;
+ (NSString *)getVersionFromBundle:(NSBundle *)bundle;
@end
