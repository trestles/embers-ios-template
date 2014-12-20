//
//  MYUtility.m
//  instore
//
//  Created by jonathan twaddell on 2/26/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(R, G, B)                        ([UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f])



NSString* EMBERSlocationName(){
  return @"A.O.C.";
}

NSString* EMBERSlocationAddressShort(){
  return @"8700 W 3rd St";
}

NSString* EMBERSlocationAddressCity(){
  return @"Los Angeles, CA 90048";
}

NSString* EMBERSenv(){
  return @"production";
  //return @"dev";
}

NSString* EMBERSnotificationToken(){
  if([EMBERSenv() isEqualToString:@"dev"]){
    return @"yz4mGQKvpr92Kszq5Mqo";
  }else if([EMBERSenv() isEqualToString:@"production"]){
    return @"36erYnJXDkVDxzuQCQT4";
  }
  return nil;
}

NSString* EMBERSnewsURL(){
  return @"/arc/news/aoc";
  //return @"dev";
}


NSString* MYWhichItemLayout(){
  return @"top";
  //return @"middle";
  //return @"bottom";
}

CGFloat MYLocationLatitude(){
  //return 34.073609;
  return 34.07335;
}

CGFloat MYLocationLongitude(){
  //return -118.381711;
  return -118.3818;
}


BOOL MYLog(){
  return YES;
  //return NO;
}

NSString *EMBERSLocationID() {
  return @"48";  // AOC
  //return @"37";  // LUCQUES

}


NSString *EMBERSHost() {
  if([EMBERSenv() isEqualToString:@"dev"]){
    return @"http://localhost:3000";
  }else if([EMBERSenv() isEqualToString:@"production"]){
    return @"http://www.embers.io";
  }
  return nil;
}

NSString *EMBERSImageHost() {
  if([EMBERSenv() isEqualToString:@"dev"]){
    return @"http://localhost:3000";
  }else if([EMBERSenv() isEqualToString:@"production"]){
    return @"";
  }
  return nil;
}

BOOL EMBERSShowBorders() {
  return YES;
  //return NO;
}


UIFont* EMBERSMapMiniViewFont() {
  return [UIFont fontWithName:@"Helvetica" size:18.0];
}

UIFont* MYSplashMenuFont(){
  return [UIFont fontWithName:@"Courier-Bold" size:22.0];
}

UIFont* MYMenuListFont() {
  return [UIFont fontWithName:@"Courier-Bold" size:30.0];
}

UIFont* MYMenuHeaderFont() {
  return [UIFont fontWithName:@"Courier-Bold" size:16.0];
}


UIFont* MYLinkFont() {
  return [UIFont fontWithName:@"Courier-Bold" size:18.0]; // for iPhone
}


UIFont* MYPriceFont() {
  //return [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)]; // for iPad
  return [UIFont fontWithName:@"HelveticaNeue-Light" size:(20.0)]; // for iPhone
}


UIFont* MYMainSlightlyLargerFont() {
  //return [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)]; // for iPad
  return [UIFont fontWithName:@"HelveticaNeue-Light" size:(19.0)]; // for iPhone
}


UIFont* MYMainFont() {
  //return [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)]; // for iPad
  //return [UIFont fontWithName:@"HelveticaNeue-Light" size:(16.0)]; // for iPhone
  return [UIFont fontWithName:@"Courier" size:(16.0)]; // for iPhone

}

UIFont* MYMainSmallerFont() {
  //return [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)]; // for iPad
  return [UIFont fontWithName:@"HelveticaNeue-Light" size:(14.0)]; // for iPhone
}


UIFont* MYMenuItemListFont() {
  return [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)]; // for iPad
  //return [UIFont fontWithName:@"HelveticaNeue-Light" size:(20.0)]; // for iPhone
}




UIFont* MYSmallerMainFont() {
    //return [UIFont fontWithName:@"HelveticaNeue" size:(22.0)];
    //return [UIFont fontWithName:@"HelveticaNeue" size:(16.0)];
    return [UIFont fontWithName:@"HelveticaNeue" size:(8.0)];

    //return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:(22.0)];
}


UIFont* MYLargerMainFont() {
    //return [UIFont fontWithName:@"HelveticaNeue" size:(22.0)];
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:(32.0)];
    //return [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:(22.0)];
}


UIColor* MYMenuFontColor(){
  return [UIColor blackColor];
  
}

UIFont* MYMenyHeaderFont(){
  return [UIFont fontWithName:@"Courier-Bold" size:14.0];  // iPhone
}


UIFont* MYBoldedFont(){
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:(14.0)];  // iPhone
}

UIFont* MYHeaderNameFont(){
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:(24.0)];
}

CGFloat MYBorderWidth(){
    return 1.0f;
}

CGFloat MYCornerRadius(){
    return 10.0f;
}

CGFloat MYLeftPosition(){
    //return 40.0f;
    return 12.0f; // <- bump for left side meta
}

CGFloat MYMIHeaderWidth(){
    //return 40.0f;
    return 260.0f; // <- bump for left side meta
}

CGFloat MYMIViewWidth(){
    //return 40.0f;
    return 320.0f; // <- bump for left side meta
}

CGFloat MYLeftTopViewPosition(){
    //return 40.0f;
    return 20.0f; // <- bump for left side meta
}


CGFloat MYLeftDetailOffset(){
    return 0.0f;
    //return 600.0f; // <- bump for left side meta
}

CGFloat MYFullWidth(){
    return 320.0f;
}

CGFloat MYFullHeight(){
    return 568.0f;
}


BOOL MYRefTN1() {
    // return YES;
    return NO;
}

UIColor *MYBrownColor() {
    return RGB(71, 50, 29);
}


