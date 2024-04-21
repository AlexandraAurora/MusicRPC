//
//  MediaRemote.h
//  MusicRPC
//
//  Created by Alexandra Aurora Göttlicher
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT CFStringRef _Nullable kMRMediaRemoteNowPlayingInfoDidChangeNotification;

FOUNDATION_EXPORT CFStringRef _Nullable kMRMediaRemoteNowPlayingInfoTitle;
FOUNDATION_EXPORT CFStringRef _Nullable kMRMediaRemoteNowPlayingInfoAlbum;
FOUNDATION_EXPORT CFStringRef _Nullable kMRMediaRemoteNowPlayingInfoArtist;
FOUNDATION_EXPORT CFStringRef _Nullable kMRMediaRemoteNowPlayingInfoDuration;
FOUNDATION_EXPORT CFStringRef _Nullable kMRMediaRemoteNowPlayingInfoElapsedTime;

typedef void (^ MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef _Nullable information);
typedef void (^ MRMediaRemoteGetNowPlayingApplicationPIDCompletion)(int PID);
typedef void (^ MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion)(Boolean isPlaying);

FOUNDATION_EXPORT void MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_queue_t _Nullable queue);
FOUNDATION_EXPORT void MRMediaRemoteGetNowPlayingApplicationPID(dispatch_queue_t _Nullable queue, MRMediaRemoteGetNowPlayingApplicationPIDCompletion _Nullable completion);
FOUNDATION_EXPORT void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t _Nullable queue, MRMediaRemoteGetNowPlayingInfoCompletion _Nullable completion);
FOUNDATION_EXPORT void MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_queue_t _Nullable queue, MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion _Nullable completion);
