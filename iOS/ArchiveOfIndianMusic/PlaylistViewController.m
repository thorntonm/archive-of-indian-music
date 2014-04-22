#import "PlaylistViewController.h"
#import "Track.h"
#import "TrackViewController.h"
#import "PlaylistAudioPlayer.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setPlaylist:(Playlist*)playlist {
  _playlist = playlist;
  self.title = playlist.title;
  [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {

  UITableViewCell* cell =
      [tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
  Track* track = [self.playlist.tracks objectAtIndex:indexPath.row];
  cell.textLabel.text = track.title;

  return cell;
}

- (NSInteger)tableView:(UITableView*)ta5bleView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return self.playlist.tracks.count;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowTrack"]) {
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    PlaylistAudioPlayer* player = [PlaylistAudioPlayer sharedInstance];
    player.playlist = self.playlist;
    player.currentTrack = [self.playlist.tracks objectAtIndex:indexPath.row];
  }
}

@end
