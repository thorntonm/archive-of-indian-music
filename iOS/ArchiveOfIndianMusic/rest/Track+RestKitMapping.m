#import "Track+RestKitMapping.h"

@implementation Track (RestKitMapping)

+ (RKObjectMapping*)restKitObjectMapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Track class]];

  [mapping addAttributeMappingsFromDictionary:@{
                                                @"title" : @"title",
                                                @"genre" : @"genre",
                                                @"stream_url" : @"streamURL"
                                              }];

  return mapping;
}

@end
