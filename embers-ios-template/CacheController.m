//
//  CacheController.m
//  NSCacheSample
//
// Copyright 2011 by Michal Tuszynski
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


#import "CacheController.h"
#import "MYUtility.h"

static CacheController *sharedInstance = nil;

@implementation CacheController

//@synthesize cache;

+(CacheController *)sharedInstance {
    
    if (sharedInstance == nil) {
        
        sharedInstance = [[CacheController alloc] init];
    }
    
    return sharedInstance;
}

+(void)destroySharedInstance {
    
    //[sharedInstance release];
    sharedInstance = nil;
}

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        self.cache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void)setCache:(NSDictionary *)obj forKey:(NSString *)key {
    //NSLog(@"writing %@ with key: %@", obj, key);
    [_cache setObject:obj forKey:key];
    
}


-(NSDictionary *)getCacheForKey:(id)key {
    if(MYLog()){
      //NSLog(@"within getCacheForKey; getting with key: %@", key);
    }
   return [_cache objectForKey:key];
}


/*
-(void)dealloc {
    
    [cache release];
    
    [super dealloc];
}
*/
@end
