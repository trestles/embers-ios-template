//
//  MenuHeaderCell.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/18/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuHeader.h"

@interface MenuHeaderCell : UITableViewCell
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) MenuHeader* menuHeader;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

-(void)updateCell:(MenuHeader *)menuHeader;

@end
