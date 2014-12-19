#import <Foundation/Foundation.h>

//#import "AtFHTTPClient.h"

#import "NSDictionary+Additions.h"

@interface EmbersRecord : NSObject

@property (nonatomic, assign) NSUInteger globalID;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
