//
//  Location.h
//  embers
//
//  Created by jonathan twaddell on 9/15/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmbersRecord.h"

@interface Location : EmbersRecord

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) int locationID;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double distance;

//@property (nonatomic, strong) NSNumber *longitude;
//@property (nonatomic, strong) NSNumber *latitude;

+(void)getHomeLocation:(int)locationID;
+(void)getCacheAndCallback:(int)menuID andCallback:(void(^)(id JSON))completionBlock;


@end
