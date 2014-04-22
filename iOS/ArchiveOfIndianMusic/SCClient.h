//
//  SCClient.h
//  ArchiveOfIndianMusic
//
//  Created by Megha Thornton on 4/20/14.
//  Copyright (c) 2014 cfi. All rights reserved.
//

#import <Foundation/Foundation.h>

// An interface for SoundCloud clients.
@protocol SCClient<NSObject>

// Searches for playlists which match the given query. Offset and limit can be set to retrieve
// results one page at a time.
- (void)searchPlaylists:(NSString*)query
                 offset:(int)offset
                  limit:(int)limit
                success:(void (^)(NSArray* playlists))successBlock
                failure:(void (^)(NSError* error))failureBlock;

@end
