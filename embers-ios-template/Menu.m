//
//  Menu.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/10/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "Menu.h"
#import "menuHeader.h"
#import "menuItem.h"
#import "MYUtility.h"

@implementation Menu
- (id)initWithAttributes:(NSDictionary *)attributes {
  self = [super initWithAttributes:attributes];
  if (!self) {
    return nil;
  }
  
  self.name = [attributes notNullObjectForKey:@"name"];
  self.timestamp = [attributes notNullObjectForKey:@"timestamp"];
  self.menuID = [[attributes notNullObjectForKey:@"id"] integerValue];

  NSArray *tmpMHArray = [attributes notNullObjectForKey:@"menu_headers"];

  self.menuHeaders=[[NSMutableArray alloc] init];
  for(NSDictionary *mh in tmpMHArray){
    MenuHeader *menuHeader = [[MenuHeader alloc] initWithAttributes:mh];
    if(menuHeader!=nil){
      [self.menuHeaders addObject:menuHeader];
      if(MYLog()){
        NSLog(@"that is with count: %li", (long)[self.menuHeaders count]);
        NSLog(@"that is NOT nil with %@", menuHeader.name);
      }
    }else{
      NSLog(@"that is nil");
    }
  }
  self.listItems=[[NSMutableArray alloc]init];
  for(MenuHeader *mh in self.menuHeaders ){
    [self generateListItems: mh];
  }
  NSDictionary *bottomDecorator=@{@"name":@"*A 3% charge is added to all checks to cover the cost of full health care benefits for our employees.Thank you for supporting a healthier & happier staff."};
  [self.listItems addObject:bottomDecorator];
  return self;
}

-(void)generateListItems:(MenuHeader *)menu_header
{
  if(MYLog()){
    NSLog(@"GOING TO GENERATE LIST ITEMS");
    NSLog(@"withinListItems %@", menu_header.name);
  }
  [self.listItems addObject:menu_header];
  if([menu_header.menuItems count] > 0){
    for(MenuItem *mi in menu_header.menuItems ){
      [self.listItems addObject:mi];
    }
  }
  if(![menu_header.bottomDecorator isEqualToString:@""]){
    NSDictionary *bD=@{@"name":menu_header.bottomDecorator};
    [self.listItems addObject:bD];
  }
  
  if([menu_header.menuHeaders count] > 0){
    for(MenuHeader *mh in menu_header.menuHeaders ){
      if(MYLog()){
        NSLog(@"withinListItems - MenuHeaders %@", mh.name);
      }
      [self generateListItems: mh];
    }
  }


  if(MYLog()){
    NSLog(@"listItems count %lu", (unsigned long)[self.listItems count]);
  }
}

@end
