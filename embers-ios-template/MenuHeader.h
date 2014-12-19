//
//  MenuHeader.h
//  instore
//
//  Created by jonathan twaddell on 3/11/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "AtFRecord.h"

@interface MenuHeader : AtFRecord

@property (nonatomic, assign) NSUInteger menuHeaderID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameExt;
@property (nonatomic, strong) NSString *topDecorator;
@property (nonatomic, strong) NSString *topSecondaryDecorator;
@property (nonatomic, strong) NSString *bottomDecorator;
@property (nonatomic, strong) NSString *layout;
@property (nonatomic, assign) NSUInteger depth;
@property (nonatomic, strong) NSMutableArray *menuHeaders;
@property (nonatomic, strong) NSMutableArray *menuItems;
@end
