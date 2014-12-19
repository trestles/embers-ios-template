//
//  AppData.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/16/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "AppData.h"
#import "MenuCache.h"

@interface AppData(){
  NSDictionary *_appData;
}

@end

@implementation AppData


+(NSDictionary *)getData:(NSInteger)menuID {
  NSDictionary *myDict=@{@"menuID":@2,@"data":@"here is my data"};
  return myDict;
}


+(void) addMenu:(NSString *)jsonString{
  // does this already exist
/*
  if([_appData objectForKey:menuID]){
    NSLog(@"there is nothing here");
  }
 */
}

 

#pragma mark Singleton Methods

+ (id)sharedManager {
  static AppData *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

/*
- (id)init {
  if (self = [super init]) {
    someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
  }
  return self;
}
 */

@end
