#import "Track.h"

#import <RestKit/RestKit.h>

@interface Track (RestKitMapping)

+ (RKObjectMapping*)restKitObjectMapping;

@end
