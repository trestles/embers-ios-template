//
//  MenuItemView.h
//  instore
//
//  Created by jonathan twaddell on 3/6/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuItemView : UIView

@property (nonatomic, retain) UILabel *binNumberLabel;
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, assign) CGFloat miVHeight;
@property (nonatomic, strong) MenuItem *menuItem;

-(id) initWithFrame:(CGRect)frame menuItem:(MenuItem *)menuItem;
@end
