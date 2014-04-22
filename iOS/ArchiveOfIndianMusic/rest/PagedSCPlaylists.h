//
//  PagedSCPlaylists.h
//  ArchiveOfIndianMusic
//
//  Created by Megha Thornton on 4/20/14.
//  Copyright (c) 2014 cfi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SCClient.h"

@protocol PlaylistsResultDelegate<NSObject>

- (void)didLoadPlaylists:(NSArray*)playlists;

- (void)playlistsLoadDidFailWithError:(NSError*)error;

@end

////////////////////////////////////////////////////////////////////////////////

// A class which retrieves playlists one page at a time.
@interface PagedSCPlaylists : NSObject

@property(assign, nonatomic) int fetchCount;
@property(assign, nonatomic) int maxResultCount;

@property(strong, nonatomic) NSString* query;
@property(assign, nonatomic) BOOL finished;
@property(strong, nonatomic) NSMutableArray* playlists;

@property(strong, nonatomic) id<SCClient> client;

@property(weak, nonatomic) id<PlaylistsResultDelegate> delegate;

@property(assign, atomic) BOOL loadInProgress;

- (id)initWithQuery:(NSString*)query
             client:(id<SCClient>)client
         fetchCount:(int)fetchCount
     maxResultCount:(int)maxResultCount
           delegate:(id<PlaylistsResultDelegate>)delegate;

- (BOOL)hasMoreResults;
- (void)loadNextPage;

@end
