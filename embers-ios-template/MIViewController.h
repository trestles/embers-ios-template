//
//  MIViewController.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/19/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MIViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, retain) UIScrollView *bgSV;
@property (weak, nonatomic) IBOutlet UIView *noteView;
@property (nonatomic, assign) NSUInteger menuItemID;
@property (nonatomic, strong) MenuItem *menuItem;
@property (nonatomic, strong) UIImageView *backgroundImage;

@end
