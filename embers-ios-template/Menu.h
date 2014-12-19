//
//  Menu.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/10/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmbersRecord.h"

@interface Menu : EmbersRecord
@property (nonatomic, assign) NSInteger menuID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSMutableArray *menuHeaders;
@property (nonatomic, strong) NSMutableArray *listItems;
@end
