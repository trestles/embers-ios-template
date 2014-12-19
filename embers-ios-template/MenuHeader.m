//
//  MenuHeader.m
//  instore
//
//  Created by jonathan twaddell on 3/11/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "MenuHeader.h"
#import "MenuItem.h"

@implementation MenuHeader

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
  
    NSString *tmpStr=[attributes notNullObjectForKey:@"name"];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.name = tmpStr;

    NSString *tmpNameExt=[attributes notNullObjectForKey:@"name_ext"];
    tmpNameExt = [tmpNameExt stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpNameExt = [tmpNameExt stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.nameExt = tmpNameExt;
  
    self.depth = [[attributes notNullObjectForKey:@"depth"] integerValue];

    NSString *tmpBottomDecorator=[attributes notNullObjectForKey:@"bottom_decorator_clean"];
    tmpBottomDecorator = [tmpBottomDecorator stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpBottomDecorator = [tmpBottomDecorator stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.bottomDecorator = tmpBottomDecorator;

    NSString *tmpTopDecorator=[attributes notNullObjectForKey:@"top_decorator_clean"];
    tmpTopDecorator = [tmpTopDecorator stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpTopDecorator = [tmpTopDecorator stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.topDecorator = tmpTopDecorator;

    NSString *tmpSecondaryDecorator=[attributes notNullObjectForKey:@"top_secondary_decorator_clean"];
    tmpSecondaryDecorator = [tmpSecondaryDecorator stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpSecondaryDecorator = [tmpSecondaryDecorator stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.topSecondaryDecorator = tmpSecondaryDecorator;
  
    self.menuItems=[[NSMutableArray alloc] init];
    for(NSDictionary *mi in [attributes objectForKey:@"menu_items"]){
      MenuItem *tmpMenuItem=[[MenuItem alloc] initWithAttributes:mi];
      [self.menuItems addObject:tmpMenuItem];
    }

    self.menuHeaders=[[NSMutableArray alloc] init];
    for(NSDictionary *mh in [attributes objectForKey:@"menu_headers"]){
      MenuHeader *tmpMenuHeader=[[MenuHeader alloc] initWithAttributes:mh];
      [self.menuHeaders addObject:tmpMenuHeader];
    }
  

  
  return self;
}

@end
