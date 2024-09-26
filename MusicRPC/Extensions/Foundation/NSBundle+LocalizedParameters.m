//
//  NSBundle+LocalizedParameters.m
//  MusicRPC
//
//  Created by Alexandra Göttlicher
//

#import "NSBundle+LocalizedParameters.h"

@implementation NSBundle (LocalizedParameters)
/**
 * Returns a localized string with parameters.
 *
 * For example:
 * "UserGreeting" = "Hello %UserName%!";
 * ...parameters:@{"UserName": @"Alexandra"}...
 *
 * @param key The key for the base string
 * @param parameters The parameters dictionary
 *
 * @return The localized string
 */
- (NSString *)localizedStringForKeyWithParameters:(NSString *)key parameters:(NSDictionary *)parameters {
    NSString* string = NSLocalizedString(key, nil);
    
    for (NSString* key in [parameters allKeys]) {
        NSString* parameterLiteral = [NSString stringWithFormat:@"%%%@%%", key];
        NSString* parameterValue = parameters[key];
        string = [string stringByReplacingOccurrencesOfString:parameterLiteral withString:parameterValue];
    }
    
    return string;
}
@end
