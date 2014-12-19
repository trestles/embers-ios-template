//
//  TastingNote.h
//  instore
//
//  Created by jonathan twaddell on 3/4/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "EmbersRecord.h"
#import "MenuItem.h"
#import "ProcessedInstore.h"
#import "MenuItem.h"

@interface TastingNote : EmbersRecord

@property (nonatomic, assign) NSUInteger tastingNoteID;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) ProcessedInstore *processedInstore;
@property (nonatomic, strong) MenuItem *menuItem;

@end

