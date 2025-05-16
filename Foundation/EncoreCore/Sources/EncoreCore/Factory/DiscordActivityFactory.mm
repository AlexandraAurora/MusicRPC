//
//  DiscordActivityFactory.mm
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "SPMDiscordRPC.h"

#import "./DiscordActivityFactory.hpp"
#import "../Entity/Media.h"

@implementation DiscordActivityFactory
- (DiscordRichPresence const)buildForMedia:(Media* _Nonnull const)media {
    DiscordRichPresence activity{};
    activity.type = LISTENING;
    activity.displayType = DETAILS;
    activity.details = [[self spacedStringFromString:[media title]] UTF8String];

    if ([media subtitle]) {
        activity.state = [[self spacedStringFromString:[media subtitle]] UTF8String];
    }

    if ([media duration] > 0) {
        CGFloat const remainingTime = [media duration] - [media elapsed];
        activity.endTimestamp = time(nullptr) + (NSUInteger)remainingTime;
        activity.startTimestamp = time(nullptr) - (NSUInteger)[media elapsed];
    }

    if ([media coverUrl]) {
        activity.largeImageKey = [[[media coverUrl] absoluteString] UTF8String];

        if ([media details]) {
            activity.largeImageText = [[self spacedStringFromString:[media details]] UTF8String];
        }

        activity.smallImageKey = [@"tidal" UTF8String];
        activity.smallImageText = [@"TIDAL" UTF8String];
    } else {
        activity.largeImageKey = [@"tidal" UTF8String];
        activity.largeImageText = [@"TIDAL" UTF8String];
    }

//    activity.button1name = [@"Custom button" UTF8String];
//    activity.button1link = [@"https://google.lu" UTF8String];
//    activity.button2name = [@"Search on Odesli" UTF8String];
//    activity.button2link = [@"" UTF8String];

    return activity;
}

- (NSString* _Nonnull const)spacedStringFromString:(NSString* _Nonnull const)string {
    NSString* _Nonnull spacedString = [string copy];

    if (1 == [spacedString length]) {
        spacedString = [spacedString stringByAppendingString:@" "];
    }

    return spacedString;
}
@end
