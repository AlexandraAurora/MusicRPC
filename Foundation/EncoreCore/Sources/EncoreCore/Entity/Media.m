//
//  Media.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "./Media.h"

@implementation Media
- (BOOL)shouldBeCached {
    return [self coverUrl];
}

- (void)encodeWithCoder:(NSCoder* _Nonnull const)coder {
    [coder encodeObject:[self coverUrl] forKey:kMediaKeyCoverUrl];
}

- (instancetype _Nullable const)initWithCoder:(NSCoder* _Nonnull const)coder {
    self = [super init];

    if (self) {
        [self setCoverUrl:[coder decodeObjectOfClass:[NSURL class] forKey:kMediaKeyCoverUrl]];
    }

    return self;
}

- (NSDictionary* _Nonnull const)jsonSerialize {
    return @{
        kMediaKeyApplicationBundleIdentifier: [self applicationBundleIdentifier],
        kMediaKeyIsPlaying: @([self isPlaying]),
        kMediaKeyTitle: [self title],
        kMediaKeySubtitle: [self subtitle] ? [self subtitle] : @"",
        kMediaKeyDetails: [self details] ? [self details] : @"",
        kMediaKeyCoverUrl: [self coverUrl] ? [self coverUrl] : @"",
        kMediaKeyDuration: @([self elapsed]),
        kMediaKeyElapsed: @([self duration])
    };
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
