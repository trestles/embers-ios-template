//
//  ModelData.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/23/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "ModelData.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "CacheController.h"
#import "MYUtility.h"

@interface ModelData(){
 
  NSMutableArray *_menus;
}

@end


@implementation ModelData

+(void)sayHello
{
  NSLog(@"I am saying hello");
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/locations/37/mobile_home",MYHost()]];
  //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    NSString *tmpCacheKey= @"locations/37/mobile_home";
    //NSData *cachedObject = [[CacheController sharedInstance] getCacheForKey:tmpCacheKey];
    //if (cachedObject != nil) {
    //  NSLog(@"got from cache with %@", cachedObject);
    //}else{
    //NSLog(@"nothing in cache");
    [[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
    
    //NSLog(@"here are the keys: %@",[[[CacheController sharedInstance] cache] allKeys]);
    //NSLog(@"write to cache with %@",tmpCacheKey);
    //}
    
    // lets just create an array of dictionaryies
    
    
    
    NSData *cachedObject = [[CacheController sharedInstance] getCacheForKey:tmpCacheKey];
    
    if (cachedObject != nil) {
      NSLog(@"GOT FROM CACHE with %@", cachedObject);
    }else{
      NSLog(@"NOTHING IN CACHE");
      //[[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
    }
    
    
    
    
    
    //NSDictionary *result=[responseObject objectForKey:@"location_ipad_home"];
    NSDictionary *result=[responseObject objectForKey:@"data"];
    
    /*
    _buttonsView=[[UIView alloc] initWithFrame:CGRectMake(20.0f, _runningY, 280.0f, 200.0f)];
    [_buttonsView setBackgroundColor:[UIColor redColor]];
    _buttonsView.alpha=0.3f;
    [self.view addSubview:_buttonsView];
    [self showButtonsViewInSeconds];
    
    [self renderMenuButton];
    [self renderNewsButton];
    if([result objectForKey:@"current_mec"]){
      [self renderSundaySupperButton:result];
    }
    */
    
    
    NSArray *menus=[result objectForKey:@"ipad_menus"];
    for(NSDictionary *m in menus){
      // will also increment into the _menus array
      [self getEachMenu:[m objectForKey:@"id"]];
     // [self getImages:[m objectForKey:@"id"]];
      //[MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //NSLog(@"Error: %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert show];
  }];
  
  
  
  [[NSOperationQueue mainQueue] addOperation:op];
  

}

+(void)getEachMenu:(NSString *) menuID
{
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/ipad-menu/%@",MYHost(), menuID]];
  //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op2 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op2.responseSerializer = [AFJSONResponseSerializer serializer];
  [op2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSDictionary *tmpResult=[responseObject objectForKey:@"menu"];
    
    NSMutableDictionary *objMenu=[[NSMutableDictionary alloc] init];
    //NSString *menuName=[tmpResult objectForKey:@"id"];
    
    [objMenu setObject:[tmpResult objectForKey:@"id"] forKey:@"menuID"];
    //[objMenu setObject:[tmpResult objectForKey:@"name"] forKey:@"name"];
    //[_menus addObject:objMenu];
    
    
    
    NSString *tmpCacheKey=[NSString stringWithFormat:@"menu/%li",(long)[[tmpResult objectForKey:@"id"] integerValue]];
    NSData *cachedObject = [[CacheController sharedInstance] getCacheForKey:tmpCacheKey];
    if (cachedObject != nil) {
      NSLog(@"got from cache with %@", cachedObject);
    }else{
      NSLog(@"nothing in cache");
      [[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
      NSLog(@"here are the keys: %@",[[[CacheController sharedInstance] cache] allKeys]);
      NSLog(@"write to cache with %@",tmpCacheKey);
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
  }];
  [[NSOperationQueue mainQueue] addOperation:op2];
}


@end
