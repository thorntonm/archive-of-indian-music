//
//  PlaylistViewController.h
//  ArchiveOfIndianMusic
//
//  Created by Megha Thornton on 4/10/14.
//  Copyright (c) 2014 cfi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Playlist.h"

@interface PlaylistViewController
    : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) Playlist* playlist;

@end
