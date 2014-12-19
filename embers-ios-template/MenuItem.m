// MenuItem.m
// 
// Copyright (c) 2012年 Trestles
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MenuItem.h"
#import "TastingNote.h"
//#import "Venue.h"
//#import "Menu.h"

@implementation MenuItem

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super initWithAttributes:attributes];
    if (!self) {
        return nil;
    }
  
    NSString *tmpStr=[attributes notNullObjectForKey:@"header"];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpStr = [tmpStr stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.header = tmpStr;
    //self.header = [attributes notNullObjectForKey:@"header"];


    NSString *tmpDetail=[attributes notNullObjectForKey:@"detail"];
    tmpStr = [tmpDetail stringByReplacingOccurrencesOfString: @"<br />" withString: @"\n"];
    tmpStr = [tmpDetail stringByReplacingOccurrencesOfString: @"<br>" withString: @"\n"];
    self.detail = tmpDetail;
    //self.isDrink = [[attributes notNullObjectForKey:@"is_drink"] boolValue];
    //self.isWine = [[attributes notNullObjectForKey:@"is_wine"] boolValue];
    self.menuItemID = [[attributes notNullObjectForKey:@"id"] integerValue];
    self.hasInstoreImage = [[attributes notNullObjectForKey:@"has_instore_image"] integerValue];
    self.hasTastingNotes = [[attributes notNullObjectForKey:@"has_tasting_notes"] integerValue];
    self.instoreImageURL = [attributes notNullObjectForKey:@"instore_image_url"];
    self.instoreImage = [attributes notNullObjectForKey:@"instore_image"];
    self.layout= [attributes notNullObjectForKey:@"layout"];
    self.price = [attributes notNullObjectForKey:@"price_value_api"];
    self.processedPrice = [attributes notNullObjectForKey:@"processed_price"];
    self.binNumber = [attributes notNullObjectForKey:@"bin_number"];
    self.whichPrice = [attributes notNullObjectForKey:@"which_price"];
    self.miSeparator = [attributes notNullObjectForKey:@"mi_separator"];

    self.tastingNotes=[[NSMutableArray alloc] init];
    NSArray *tmpArray= [attributes notNullObjectForKey:@"tasting_notes"];
    for(NSDictionary *dict=[[NSDictionary alloc] init] in tmpArray){
      TastingNote *tmpTastingNote = [[TastingNote alloc] initWithAttributes:dict];
      [self.tastingNotes addObject:tmpTastingNote];
    }

    self.referencedTastingNotes=[[NSMutableArray alloc] init];
    NSArray *tmpRTNArray= [attributes notNullObjectForKey:@"referenced_tasting_notes"];
    for(NSDictionary *dict=[[NSDictionary alloc] init] in tmpRTNArray){
      TastingNote *tmpTastingNote = [[TastingNote alloc] initWithAttributes:dict];
      [self.referencedTastingNotes addObject:tmpTastingNote];
    }

  
  
  /*
    Venue *venue = [[Venue alloc] init];
    venue.globalID = [[attributes notNullObjectForKey:@"location_id"] integerValue];
    venue.venueID = [[attributes notNullObjectForKey:@"location_id"] integerValue];
    venue.name = [attributes notNullObjectForKey:@"location_name"];
    venue.location = [[CLLocation alloc] initWithLatitude:[[attributes notNullObjectForKey:@"latitude"] doubleValue] longitude:[[attributes notNullObjectForKey:@"longitude"] doubleValue]];
    self.venue = venue;
    */
    /*
    Menu *menu = [[Menu alloc] init];
    menu.menuID = [[attributes notNullObjectForKey:@"menu_id"] integerValue];
    self.menu = menu;
    */
    
    return self;
}
@end
