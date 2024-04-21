//
//  main.m
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Cocoa/Cocoa.h>

/**
 * Launches the main app if applicable and then terminates.
 */
int main(int argc, const char* argv[]) {
    @autoreleasepool {
        NSArray* runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
        BOOL isRunning = NO;

        // Loop through all running apps to check if the main app is already running.
        for (NSUInteger i = 0; i < [runningApplications count]; i++) {
            NSRunningApplication* application = runningApplications[i];
            if ([[application bundleIdentifier] isEqualToString:@"codes.aurora.MusicRPC"]) {
                isRunning = YES;
                break;
            }
        }

        // If it's not running yet, run it.
        if (!isRunning) {
            NSString* path  = [[NSBundle mainBundle] bundlePath];
            for (NSUInteger i = 0; i < 4; i++) {
                path = [path stringByDeletingLastPathComponent];
            }

            NSURL* pathURL = [NSURL fileURLWithPath:path];
            if (pathURL) {
                [[NSWorkspace sharedWorkspace] openApplicationAtURL:pathURL configuration:[NSWorkspaceOpenConfiguration configuration] completionHandler:nil];
            }
        }

        [[NSApplication sharedApplication] terminate:nil];
    }
    return NSApplicationMain(argc, argv);
}
