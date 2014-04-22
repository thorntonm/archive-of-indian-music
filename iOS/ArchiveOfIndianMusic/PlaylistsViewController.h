//
//  ArchiveOfIndianMusicFirstViewController.h
//  ArchiveOfIndianMusic
//
//  Created by Megha Thornton on 4/6/14.
//  Copyright (c) 2014 cfi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PagedSCPlaylists.h"

@interface PlaylistsViewController
    : UITableViewController<UITableViewDataSource,
                            UITableViewDelegate,
                            PlaylistsResultDelegate>

@end
