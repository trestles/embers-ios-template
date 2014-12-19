//
//  AppData.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/16/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

+ (NSDictionary *)getData:(NSInteger)menuID;

+ (id)sharedManager;


@end
