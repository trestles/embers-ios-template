//
//  MYUtility.h
//  instore
//
//  Created by jonathan twaddell on 2/26/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* EMBERSnotificationToken();
extern NSString* EMBERSlocationName();
extern NSString* EMBERSlocationAddressShort();
extern NSString* EMBERSlocationAddressCity();

extern UIFont* EMBERSMapMiniViewFont();
extern NSString* EMBERSnewsURL();
extern NSString *MYLocationID();
extern CGFloat MYLocationLatitude();
extern CGFloat MYLocationLongitude();

extern NSString *MYHost();
extern NSString *MYImageHost();
extern NSString *MYLocationId();
extern BOOL MYShowBorders();
extern BOOL MYLog();
extern UIFont* MYMenuListFont(); // used in MenuListViewController

extern UIFont* MYMenuHeaderFont();

extern UIFont *MYSplashMenuFont();
extern UIFont *MYPriceFont();
extern UIFont *MYMainSlightlyLargerFont();
extern UIFont *MYMainFont();
extern UIFont *MYMainSmallerFont();
extern UIFont *MYSmallerMainFont();
extern UIFont *MYLargerMainFont();
extern UIColor *MYMenuFontColor();
extern UIFont *MYBoldedFont();
extern UIFont *MYHeaderNameFont();
extern CGFloat MYBorderWidth();
extern CGFloat MYCornerRadius();
extern CGFloat MYLeftPosition();
extern CGFloat MYMIHeaderWidth();
extern CGFloat MYMIViewWidth();
extern CGFloat MYLeftTopViewPosition();
extern CGFloat MYLeftDetailOffset();
extern CGFloat MYFullWidth();
extern CGFloat MYFullHeight();
extern BOOL MYRefTN1();
extern UIColor *MYBrownColor();
extern NSString *MYWhichItemLayout();

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )



