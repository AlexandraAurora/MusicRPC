//
//  MediaRemote.js
//  EncoreCore
//
//  Created by EinTim23 and Alexandra Göttlicher
//

ObjC.import('Foundation');

try {
    const frameworkPath = '/System/Library/PrivateFrameworks/MediaRemote.framework';
    const framework = $.NSBundle.bundleWithPath($(frameworkPath));
    framework.load

    const MRNowPlayingRequest = $.NSClassFromString('MRNowPlayingRequest');
    const playerPath = MRNowPlayingRequest.localNowPlayingPlayerPath;
    const nowPlayingItem = MRNowPlayingRequest.localNowPlayingItem;

    const nowPlayingInfo = nowPlayingItem.nowPlayingInfo;

    const bundleIdentifier = ObjC.unwrap(playerPath.client.bundleIdentifier);
    const isPlaying = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoPlaybackRate');
    const title = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoTitle');
    const album = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoAlbum');
    const artist = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoArtist');
    const duration = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoDuration');
    const elapsed = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoElapsedTime');
    const artworkData = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoArtworkData');

    JSON.stringify({
        bundle_identifier: ObjC.unwrap(bundleIdentifier),
        is_playing: ObjC.unwrap(isPlaying),
        title: ObjC.unwrap(title),
        album: ObjC.unwrap(album),
        artist: ObjC.unwrap(artist),
        duration: ObjC.unwrap(duration),
        elapsed: ObjC.unwrap(elapsed),
        artwork_data: ObjC.unwrap(artworkData)
    });
} catch (error) {
    JSON.stringify({
        player: null,
        error: error.toString()
    });
}
