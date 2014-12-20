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
  NSLog(@"height of nameLabel: %f",self.nameLabel.frame.size.height);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(NSString *)val
{
  NSLog(@"update with type");
  //self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 10.0f)];
  self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 10.0f)];
  self.nameLabel.font=MYMenuHeaderFont();
  self.nameLabel.layer.borderColor=[UIColor greenColor].CGColor;
  self.nameLabel.layer.borderWidth=2.0f;
  self.nameLabel.numberOfLines=0;
  self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
  self.nameLabel.textAlignment = NSTextAlignmentCenter;
  self.nameLabel.text=val;
  [self.nameLabel sizeToFit];
  self.height=self.nameLabel.frame.size.height + 20.0f;
  // lets figure out left

  CGFloat screenWidth=[UIScreen mainScreen].bounds.size.width;
  CGFloat leftOffset=(screenWidth-self.nameLabel.frame.size.width)/2;
  self.nameLabel.frame=CGRectMake(leftOffset, 0.0f, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
  [self.contentView addSubview:self.nameLabel];
}


- (void)prepareForReuse
{
  [super prepareForReuse];
  //self.nameLabel=nil;
  [self.nameLabel removeFromSuperview];
}


@end
