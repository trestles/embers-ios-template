//
//  MenuCache.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/16/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmbersRecord.h"

@interface MenuCache : EmbersRecord
  @property (nonatomic, assign) NSInteger menuID;
  @property (nonatomic, strong) NSString *jsonString;
@end
