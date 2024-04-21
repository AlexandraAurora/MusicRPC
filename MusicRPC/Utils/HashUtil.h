//
//  HashUtil.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Foundation/Foundation.h>

@interface HashUtil : NSObject
+ (NSString *)getSHA1ForString:(NSString *)string;
@end
