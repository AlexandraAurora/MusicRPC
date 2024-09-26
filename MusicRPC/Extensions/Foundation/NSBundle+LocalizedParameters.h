//
//  NSBundle+LocalizedParameters.h
//  MusicRPC
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@interface NSBundle (LocalizedParameters)
- (NSString *)localizedStringForKeyWithParameters:(NSString *)key parameters:(NSDictionary *)parameters;
@end

static inline NSString* NSLocalizedStringWithParameters(NSString* key, NSDictionary* parameters) {
    return [[NSBundle mainBundle] localizedStringForKeyWithParameters:key parameters:parameters];
}
