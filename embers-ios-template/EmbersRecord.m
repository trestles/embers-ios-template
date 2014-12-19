#import "EmbersRecord.h"

@implementation EmbersRecord

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    //self.globalID = [[attributes notNullObjectForKey:@"global_id"] integerValue];
    
    return self;
}

@end
