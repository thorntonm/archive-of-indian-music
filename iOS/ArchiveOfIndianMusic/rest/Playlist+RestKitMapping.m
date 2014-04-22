#import "Playlist+RestKitMapping.h"
#import "Track+RestKitMapping.h"

@implementation Playlist (RestKitMapping)

+ (RKObjectMapping*)restKitObjectMapping {
  RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[Playlist class]];

  [mapping
      addRelationshipMappingWithSourceKeyPath:@"tracks"
                                      mapping:[Track restKitObjectMapping]];

  [mapping addAttributeMappingsFromDictionary:
               @{@"genre" : @"genre", @"title" : @"title"}];

  return mapping;
}

@end
