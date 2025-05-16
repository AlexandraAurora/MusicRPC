//
//  Logger.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LogType) {
    LogTypeInfo = 0,
    LogTypeWarning = 1,
    LogTypeError = 2
};

static NSString* _Nonnull const kLogDateFormatFileName = @"yyyyMMdd";
static NSString* _Nonnull const kLogDateFormatLogMessage = @"yyyy-MM-dd'T'HH:mm:ss.SSS";

@interface Logger : NSObject {
    NSFileManager* _Nonnull _fileManager;
    NSString* _Nonnull _logsPath;
}
+ (instancetype _Nonnull const)sharedInstance;
- (void)logMessage:(NSString* _Nonnull const)message forType:(LogType)type;
- (void)ensureFileSystem;
- (NSString* _Nonnull const)logsPath;
@end
