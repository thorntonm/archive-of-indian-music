#import "Playlist.h"

#import <RestKit/RestKit.h>

@interface Playlist (RestKitMapping)

+ (RKObjectMapping*)restKitObjectMapping;

@end
