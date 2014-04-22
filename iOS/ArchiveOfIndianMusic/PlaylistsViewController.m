#import "PlaylistsViewController.h"

#import "SCRestClient.h"

#import "Playlist.h"
#import "Track.h"
#import "PlaylistViewController.h"
#import "LoadingCellTableViewCell.h"

@interface PlaylistsViewController ()

@property(nonatomic, strong) PagedSCPlaylists* pagedPlaylists;

@end

@implementation PlaylistsViewController

static const int kLoadingCellTag = 1;

- (void)viewDidLoad {
  [super viewDidLoad];

  self.edgesForExtendedLayout = UIRectEdgeAll;
  self.tableView.contentInset = UIEdgeInsetsMake(
      0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);

  id<SCClient> client = [SCRestClient clientWithURL:@"http://api.soundcloud.com"];
  self.pagedPlaylists = [[PagedSCPlaylists alloc] initWithQuery:@"genre=Film"
                                                         client:client
                                                     fetchCount:100
                                                 maxResultCount:500
                                                       delegate:self];
}

- (void)didLoadPlaylists:(NSArray*)playlists {
  [self.tableView reloadData];
}

- (void)playlistsLoadDidFailWithError:(NSError*)error {
  NSString* message =
      [NSString stringWithFormat:@"Failed to load playlist data: %@",
                                 [error localizedDescription]];
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

- (NSInteger)tableView:(UITableView*)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (!_pagedPlaylists) {
    return 0;
  } else {
    if ([_pagedPlaylists hasMoreResults]) {
      return _pagedPlaylists.playlists.count + 1;
    } else {
      return _pagedPlaylists.playlists.count;
    }
  }
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  if (indexPath.row < self.pagedPlaylists.playlists.count) {
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell"];
    Playlist* playlist =
        [self.pagedPlaylists.playlists objectAtIndex:[indexPath row]];
    cell.textLabel.text = playlist.title;
    return cell;
  } else {
    LoadingCellTableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
    [cell.activityIndicator startAnimating];
    return cell;
  }
}

- (void)tableView:(UITableView*)tableView
      willDisplayCell:(UITableViewCell*)cell
    forRowAtIndexPath:(NSIndexPath*)indexPath {
  if (cell.tag == kLoadingCellTag) {
    [self.pagedPlaylists loadNextPage];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowPlaylistDetails"]) {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    PlaylistViewController* destViewController =
        segue.destinationViewController;

    destViewController.playlist =
        (Playlist*)[self.pagedPlaylists.playlists objectAtIndex:indexPath.row];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
