//
//  MenuTableViewController.h
//  lucques-ios
//
//  Created by jonathan twaddell on 8/18/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"

@interface MenuTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSUInteger menuID;
@property (nonatomic, strong) Menu* menu;
@property (strong, nonatomic) IBOutlet UITableView *menuTV;
@property (nonatomic, assign) Boolean presentedAsModal;
@end
