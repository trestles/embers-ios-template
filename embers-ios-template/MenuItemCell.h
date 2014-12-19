//
//  MenuItemCell.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/18/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
#import "MenuItemView.h"

@interface MenuItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (nonatomic, assign) NSUInteger menuItemID;
@property (nonatomic, strong) MenuItem *menuItem;
@property (nonatomic, assign) CGFloat height;
//@property (nonatomic, strong) MenuItemView* menuItemView;
@property (weak, nonatomic) IBOutlet UIView *spotView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

-(void)updateCell:(MenuItem *)menu_item;
@end


