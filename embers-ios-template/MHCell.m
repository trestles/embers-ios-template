//
//  MHCell.m
//  embers-ios-template
//
//  Created by jonathan twaddell on 12/20/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MHCell.h"
#import "EMBERSConfig.h"

@implementation MHCell

- (void)awakeFromNib {
    // Initialization code
  self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 10.0f)];
  self.nameLabel.font=MYMenuHeaderFont();
  self.nameLabel.numberOfLines=0;
  self.nameLabel.lineBreakMode = UILineBreakModeWordWrap;
  self.nameLabel.textAlignment = NSTextAlignmentCenter;

  [self.contentView addSubview:self.nameLabel];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
