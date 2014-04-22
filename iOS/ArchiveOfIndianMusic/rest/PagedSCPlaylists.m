#import "PagedSCPlaylists.h"

@implementation PagedSCPlaylists

- (id)initWithQuery:(NSString*)query
             client:(id<SCClient>)client
         fetchCount:(int)fetchCount
     maxResultCount:(int)maxResultCount
           delegate:(id<PlaylistsResultDelegate>)delegate {
  self = [super init];

  if (self) {
    self.fetchCount = fetchCount;
    self.maxResultCount = maxResultCount;
    self.query = query;
    self.client = client;
    self.finished = NO;
    self.playlists = [NSMutableArray arrayWithCapacity:100];
    self.delegate = delegate;
    self.loadInProgress = NO;

    [self loadNextPage];
  }

  return self;
}

- (BOOL)hasMoreResults {
  return !_finished;
}

- (void)loadNextPage {
  if (_loadInProgress) {
    return;
  }

  _loadInProgress = YES;

  [_client searchPlaylists:self.query
      offset:_playlists.count
      limit:_fetchCount
      success:^(NSArray* results) {
          NSLog(@"Loaded %d playlists", results.count);

          [_playlists addObjectsFromArray:results];

          if (results.count < _fetchCount ||
              _playlists.count > _maxResultCount) {
            // Retrieved all playlists or exceeded maximum result count.
            _finished = YES;
          }

          _loadInProgress = NO;

          if ([_delegate respondsToSelector:@selector(didLoadPlaylists:)]) {
            [_delegate didLoadPlaylists:_playlists];
          }
      }
      failure:^(NSError* error) {
          _loadInProgress = NO;

          if ([_delegate
                  respondsToSelector:@selector(
                                         playlistsLoadDidFailWithError:)]) {
            [_delegate playlistsLoadDidFailWithError:error];
          }
      }];
}

@end
