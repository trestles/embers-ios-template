//
//  ProcessedInstore.m
//  instore
//
//  Created by jonathan twaddell on 3/4/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "ProcessedInstore.h"
#import "EMBERSConfig.h"

@implementation ProcessedInstore

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    
    self.body = [attributes notNullObjectForKey:@"body"];
    self.header = [attributes notNullObjectForKey:@"header"];
    self.frags = [[NSMutableArray alloc] init];
    NSArray *tmp_frags=[attributes objectForKey:@"frags"];
    //NSLog(@"here are the frags: %@", tmp_frags);
    for (NSString *val in tmp_frags){
      if(MYLog()){
        NSLog(@"here is %@", val);
      }
      [self.frags addObject:val];
        //NSRange r = [myString rangeOfString:val];
        //[atString addAttributes:@ {
        //    NSFontAttributeName : _boldedFont} range:r ];
    }


    //self.tastingNoteID = [[attributes notNullObjectForKey:@"id"] integerValue];

    return self;
}


@end
