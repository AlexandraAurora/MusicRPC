//
//  HashUtil.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import "HashUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HashUtil
/**
 * Returns the SHA1 hash for a string.
 */
+ (NSString *)getSHA1ForString:(NSString *)string {
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1([data bytes], (CC_LONG)[data length], digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}
@end
