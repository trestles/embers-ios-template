//
//  TastingNote.m
//  instore
//
//  Created by jonathan twaddell on 3/4/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "TastingNote.h"
#import "ProcessedInstore.h"
#import "MenuItem.h"


@implementation TastingNote

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
    
    self.header = [[attributes notNullObjectForKey:@"header"] capitalizedString];
    self.body = [attributes notNullObjectForKey:@"body"];
    self.tastingNoteID = [[attributes notNullObjectForKey:@"id"] integerValue];
    self.processedInstore = [[ProcessedInstore alloc] initWithAttributes:[attributes objectForKey:@"processed_body_instore"]];
    self.menuItem = [[MenuItem alloc] initWithAttributes:[attributes objectForKey:@"menu_item"]];
    return self;
}

@end
