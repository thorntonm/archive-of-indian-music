#import "TrackViewController.h"

#import "PlaylistAudioPlayer.h"

@interface TrackViewController ()

@property(weak, nonatomic) IBOutlet UIButton* playPauseButton;
@property(weak, nonatomic) IBOutlet UILabel* timeLabel;
@property(weak, nonatomic) IBOutlet UILabel* timeRemainingLabel;
@property(weak, nonatomic) IBOutlet UISlider* positionSlider;
@property(nonatomic, assign) BOOL sliding;
@property(nonatomic, strong) id timeObserver;

@end

@implementation TrackViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak TrackViewController* weakSelf = self;
  __weak PlaylistAudioPlayer* player = [PlaylistAudioPlayer sharedInstance];

  if (self.timeObserver != nil) {
    [player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
  }
  self.timeObserver = [player
      addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                   queue:nil
                              usingBlock:^(CMTime time) {
    int timeInSeconds = CMTimeGetSeconds(time);
    int timeRemainingInSeconds = player.durationInSeconds - timeInSeconds;
    weakSelf.title = player.currentTrack.title;
    weakSelf.timeLabel.text = [NSString stringWithFormat:@"%d:%02d",
        timeInSeconds / 60, timeInSeconds % 60];
    weakSelf.timeRemainingLabel.text = [NSString stringWithFormat:@"-%d:%02d",
        timeRemainingInSeconds / 60, timeRemainingInSeconds % 60];
    
    weakSelf.positionSlider.minimumValue = 0;
    weakSelf.positionSlider.maximumValue = player.durationInSeconds;
    if (!weakSelf.sliding) {
        [weakSelf.positionSlider setValue:timeInSeconds animated:YES];
    }
    [self setPlaying: player.playing];
  }];
    
}

- (IBAction)playPause:(id)sender {
  [self setPlaying:![PlaylistAudioPlayer sharedInstance].playing];
}

- (void)setPlaying:(BOOL)playing {
  PlaylistAudioPlayer* player = [PlaylistAudioPlayer sharedInstance];

  if (playing) {
    [player play];
    [self.playPauseButton setImage:[UIImage imageNamed:@"pause"]
                          forState:UIControlStateNormal];
  } else {
    [self.playPauseButton setImage:[UIImage imageNamed:@"play"]
                          forState:UIControlStateNormal];
    [player pause];
  }
}

- (IBAction)previous:(id)sender {
  [[PlaylistAudioPlayer sharedInstance] previousTrack];
  [[PlaylistAudioPlayer sharedInstance] play];
}

- (IBAction)next:(id)sender {
  [[PlaylistAudioPlayer sharedInstance] nextTrack];
  [[PlaylistAudioPlayer sharedInstance] play];
}

- (IBAction)updatePosition:(id)sender {
}

- (IBAction)slideBegan:(id)sender {
  self.sliding = YES;
}

- (IBAction)slideEnd:(id)sender {
  self.sliding = NO;
  [[PlaylistAudioPlayer sharedInstance]
      seekToSecondsPosition:(int)self.positionSlider.value];
}

- (void)dealloc {
  if (self.timeObserver != nil) {
    [[PlaylistAudioPlayer sharedInstance] removeTimeObserver:self.timeObserver];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
