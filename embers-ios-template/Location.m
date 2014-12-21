//
//  Location.m
//  embers
//
//  Created by jonathan twaddell on 9/15/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "Location.h"
#import "EmbersRecord.h"
#import "AFNetworking.h"
#import "CacheController.h"
#import "EMBERSConfig.h"

@implementation Location



-(id)initWithAttributes:(NSDictionary *)attributes
{
  self = [super initWithAttributes:attributes];
  if (!self) {
    return nil;
  }
  self.name=[attributes objectForKey:@"name"];
  if ([attributes objectForKey:@"longitude"] == [NSNull null]) {
    self.longitude=0.0;
  }else{
    self.longitude=[[attributes objectForKey:@"longitude"] doubleValue];
  }
  
  if ([attributes objectForKey:@"latitude"] == [NSNull null]) {
    self.latitude=0.0;
  }else{
    self.latitude=[[attributes objectForKey:@"latitude"] doubleValue];
  }
  self.locationID=[[attributes objectForKey:@"id"] integerValue];
  self.distance=[[attributes objectForKey:@"distance"] doubleValue];
  self.city=[attributes objectForKey:@"city"];
  self.state=[attributes objectForKey:@"state"];
  self.street=[attributes objectForKey:@"street"];
  self.phoneNumber=[attributes objectForKey:@"phone"];
  return self;
}

+(void)getHomeLocation:(int)locationID
{
  NSLog(@"within this class method");
}

+(void)getCacheAndCallback:(int)locationID andCallback:(void(^)(id JSON))completionBlock
{
  NSLog(@"within getCacheAndCallback");
  //CredentialStore  *credentialStore = [[CredentialStore alloc] init];

  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  manager.responseSerializer = [AFJSONResponseSerializer serializer];
  manager.requestSerializer = [AFJSONRequestSerializer serializer];
//  [manager.requestSerializer setValue:[credentialStore authToken] forHTTPHeaderField:@"X-auth_token"];
  NSString *arcURL = [NSString stringWithFormat:@"%@/arc/v1/api/locations/%i/mobile_home",EMBERSHost(), locationID];
  NSLog(@"here is the tmpURL %@", arcURL);
  [manager GET:arcURL parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
    
    //NSLog(@"JSON: %@", responseObject);
    //NSDictionary *tmpResult=[responseObject objectForKey:@"menu"];
    //NSString *tmpCacheKey=[NSString stringWithFormat:@"/locations/%i", locationID];
    NSString *tmpCacheKey= [NSString stringWithFormat:@"locations/%i/mobile_home",locationID];

    //NSString *tmpCacheKey=[NSString stringWithFormat:@"menu/%li",(long)[[tmpResult objectForKey:@"id"] integerValue]];
    [[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
    
    if(completionBlock){
      NSLog(@"here is callback");
      completionBlock(responseObject);
    }else{
      NSLog(@"here is NO callback");
    }
  } failure:^(NSURLSessionDataTask *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet jtjt" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert show];
  }];
}


@end
