//
//  MHCell.h
//  embers-ios-template
//
//  Created by jonathan twaddell on 12/20/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) CGFloat height;
@end
