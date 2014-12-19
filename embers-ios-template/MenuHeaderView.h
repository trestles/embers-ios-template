//
//  MenuHeaderView.h
//  instore
//
//  Created by jonathan twaddell on 3/11/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuHeader.h"

@interface MenuHeaderView : UIView

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat height;
  -(id) initWithFrame:(CGRect)frame menuHeader:(MenuHeader *)menuHeader;
@end
