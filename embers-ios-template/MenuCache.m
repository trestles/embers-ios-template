//
//  MenuCache.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/16/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MenuCache.h"

@implementation MenuCache

- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super initWithAttributes:attributes];
  if (!self) {
    return nil;
  }
  
  NSString *tmpStr=[attributes notNullObjectForKey:@"jsonString"];
  self.jsonString = tmpStr;
  
  return self;
}


@end
