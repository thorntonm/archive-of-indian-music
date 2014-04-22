
#import <Foundation/Foundation.h>

#import "SCClient.h"

// A REST SoundCloud client.
@interface SCRestClient : NSObject<SCClient>

- (id)initWithURL:(NSString*)url;

+ (SCRestClient*)clientWithURL:(NSString*)url;

@property(strong, nonatomic) NSString* baseURL;

@end
