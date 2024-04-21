//
//  CFUtil.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "CFUtil.h"

@implementation CFUtil
/**
 * Returns the app name for a given bundle.
 */
+ (NSString *)getNameFromBundle:(NSBundle *)bundle {
    return [bundle infoDictionary][@"CFBundleName"];
}

/**
 * Returns the app version for a given bundle.
 */
+ (NSString *)getVersionFromBundle:(NSBundle *)bundle {
    return [bundle infoDictionary][@"CFBundleShortVersionString"];
}
@end
