//
//  ProcessedInstore.h
//  instore
//
//  Created by jonathan twaddell on 3/4/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "AtFRecord.h"

@interface ProcessedInstore : AtFRecord
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSMutableArray *frags;

@end
