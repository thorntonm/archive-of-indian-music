//
//  Playlist.h
//  ArchiveOfIndianMusic
//
//  Created by Megha Thornton on 4/6/14.
//  Copyright (c) 2014 cfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property(nonatomic, strong) NSArray* tracks;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* genre;

@end
