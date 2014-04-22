#import "SCRestClient.h"

#import <RestKit/RestKit.h>

#import "String+URLEncoding.h"
#import "Playlist+RestKitMapping.h"
#import "ArchiveOfIndianMusicAppDelegate.h"

@implementation SCRestClient

- (id)initWithURL:(NSString*)url {
  self = [super init];

  if (self) {
    _baseURL = url;
  }

  return self;
}

+ (SCRestClient*)clientWithURL:(NSString*)url {
  return [[SCRestClient alloc] initWithURL:url];
}

- (void)searchPlaylists:(NSString*)query
                 offset:(int)offset
                  limit:(int)limit
                success:(void (^)(NSArray* playlists))successBlock
                failure:(void (^)(NSError* error))failureBlock {
  if (!query) {
    query = @"";
  }

  NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:
    @"%@/users/archive-of-indian-music/playlists.json?client_id=%@&%@&offset=%d&limit=%d",
    _baseURL, [ArchiveOfIndianMusicAppDelegate soundCloudClientId], query, offset, limit]];
  [self getPlaylists:url success:successBlock failure:failureBlock];
}

- (void)getPlaylists:(NSURL*)url
             success:(void (^)(NSArray* results))successBlock
             failure:(void (^)(NSError* error))errorBlock {
  RKResponseDescriptor* responseDescriptor = [RKResponseDescriptor
      responseDescriptorWithMapping:[Playlist restKitObjectMapping]
                             method:RKRequestMethodAny
                        pathPattern:nil
                            keyPath:nil
                        statusCodes:RKStatusCodeIndexSetForClass(
                                        RKStatusCodeClassSuccessful)];

  NSURLRequest* request = [NSURLRequest requestWithURL:url];
  RKObjectRequestOperation* objectRequestOperation =
      [[RKObjectRequestOperation alloc]
              initWithRequest:request
          responseDescriptors:@[ responseDescriptor ]];

  [objectRequestOperation
      setCompletionBlockWithSuccess:^(RKObjectRequestOperation* operation,
                                      RKMappingResult* mappingResult) {
          if (mappingResult != nil && mappingResult.array != nil) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{ successBlock(mappingResult.array); });
          }
      }
      failure:^(RKObjectRequestOperation* operation, NSError* error) {
          dispatch_async(dispatch_get_main_queue(), ^{ errorBlock(error); });
      }];

  [objectRequestOperation start];
}

@end
