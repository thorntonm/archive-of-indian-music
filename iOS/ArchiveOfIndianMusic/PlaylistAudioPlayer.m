#import "PlaylistAudioPlayer.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVPlayerItem.h>

#import "ArchiveOfIndianMusicAppDelegate.h"

@interface PlaylistAudioPlayer ()

@property(nonatomic, strong) AVPlayer* player;

@end

@implementation PlaylistAudioPlayer

+ (PlaylistAudioPlayer*)sharedInstance {
  static dispatch_once_t once;
  static PlaylistAudioPlayer* instance;
  dispatch_once(&once, ^{ instance = [[PlaylistAudioPlayer alloc] init]; });
  return instance;
}

- (id)init {
  self = [super init];
  if (self) {
    _playing = NO;
    _player = [[AVPlayer alloc] init];
  }
  return self;
}

- (void)setPlaylist:(Playlist*)playlist {
  _playlist = playlist;
  if (_playlist.tracks.count > 0) {
    // Set the current track to the first track of the playlist.
    [self setCurrentTrack:[_playlist.tracks firstObject]];
  }
}

- (void)setCurrentTrack:(Track*)track {
  _currentTrack = track;
  NSString* clientId = [ArchiveOfIndianMusicAppDelegate soundCloudClientId];
  NSString* url =
      [NSString stringWithFormat:@"%@?client_id=%@", track.streamURL, clientId];

  AVPlayerItem* playerItem =
      [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];

  // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(itemDidFinishPlaying:)
             name:AVPlayerItemDidPlayToEndTimeNotification
           object:playerItem];

  [self.player replaceCurrentItemWithPlayerItem:playerItem];
  [self play];
}

- (void)itemDidFinishPlaying:(NSNotification*)notification {
  _playing = NO;
  [self nextTrack];
}

- (int)durationInSeconds {
  return CMTimeGetSeconds(self.player.currentItem.asset.duration);
}

- (void)seekToSecondsPosition: (int) positionInSeconds {
  [self seekToTime: CMTimeMake(positionInSeconds, 1)];
}

- (void)seekToTime:(CMTime)time {
  [self.player seekToTime: time];
}

- (void)play {
  if (!_playing) {
    [self.player play];
    _playing = YES;
  }
}

- (void)pause {
  if (_playing) {
    [self.player pause];
    _playing = NO;
  }
}

- (void)nextTrack {
  if (self.playlist.tracks.count == 0) {
    return;
  }
  for (int idx = 0; idx < self.playlist.tracks.count - 1; idx++) {
    Track* track = self.playlist.tracks[idx];
    if (track == self.currentTrack) {
      self.currentTrack = self.playlist.tracks[idx + 1];
      return;
    }
  }
  self.currentTrack = [self.playlist.tracks firstObject];
}

- (void)previousTrack {
  if (self.playlist.tracks.count == 0) {
    return;
  }
  for (int idx = 1; idx < self.playlist.tracks.count; idx++) {
    Track* track = self.playlist.tracks[idx];
    if (track == self.currentTrack) {
      self.currentTrack = self.playlist.tracks[idx - 1];
      return;
    }
  }
  self.currentTrack = [self.playlist.tracks firstObject];
}

- (id)addPeriodicTimeObserverForInterval:(CMTime)interval
                                   queue:(dispatch_queue_t)queue
                              usingBlock:(void (^)(CMTime time))block {
  return [self.player addPeriodicTimeObserverForInterval:interval
                                                   queue:queue
                                              usingBlock:block];
}

- (void)removeTimeObserver:(id)observer {
  [self.player removeTimeObserver:observer];
}

@end
