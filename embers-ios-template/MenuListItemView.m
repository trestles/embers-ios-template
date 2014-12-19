//
//  MenuListItemView.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/10/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MenuListItemView.h"

@implementation MenuListItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
  self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 100.0f)];
  [self addSubview:self.nameLabel];
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
