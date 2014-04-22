//
//  PlaylistAudioPlayer.h
//  ArchiveOfIndianMusic
//
//  Created by Megha Thornton on 4/21/14.
//  Copyright (c) 2014 cfi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVPlayer.h>

#import "Playlist.h"
#import "Track.h"

// A class which manages playback of a selected Playlist. When the current track is finished
// playing the next track will be played. When the last track is finished the first track will
// play.
@interface PlaylistAudioPlayer : NSObject

+ (PlaylistAudioPlayer*)sharedInstance;

@property(nonatomic, strong) Playlist* playlist;
@property(nonatomic, strong) Track* currentTrack;
@property(nonatomic, readonly) BOOL playing;
@property(nonatomic, readonly) int durationInSeconds;

- (void)play;
- (void)pause;
- (void)nextTrack;
- (void)previousTrack;

- (void)seekToSecondsPosition: (int) positionInSeconds;
- (void)seekToTime:(CMTime)time;

- (id)addPeriodicTimeObserverForInterval:(CMTime)interval
                                   queue:(dispatch_queue_t)queue
                              usingBlock:(void (^)(CMTime time))block;

- (void)removeTimeObserver:(id)observer;

@end
