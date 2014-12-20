//
//  MenuHeaderCell.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/18/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MenuHeaderCell.h"
#import "Menuheader.h"
#import "EMBERSConfig.h"

@interface MenuHeaderCell(){
  CGFloat _mhTopPad;
  CGFloat _mhBottomPad;
  CGFloat _mhCellHeight;

}
@end

@implementation MenuHeaderCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  NSLog(@"this was called in custom initWithCoder");
  
  if (self) {
  }
  return self;
}

-(void)initWithMenuHeader:(MenuHeader *)mh
{

  //self.nameLabel.text=mh.name;
}

-(void)updateCell:(MenuHeader *)menuHeader
{
  self.nameLabel=nil;
  self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, 200.0f, 30.0f)];
  _mhCellHeight=40;
  _mhTopPad=5.0f;
  _mhBottomPad=5.0f;
  
  
  //self.nameLabel.text=menuHeader.name;
  //self.nameLabel.text=@"my thinking";

  self.nameLabel.font=MYMenuHeaderFont();
  self.nameLabel.numberOfLines=0;
  self.nameLabel.textAlignment = NSTextAlignmentCenter;
  [self.nameLabel setBackgroundColor:[UIColor blueColor]];
  self.nameLabel.text=@"";
  self.nameLabel.text=menuHeader.name;
  //self.nameLabel.text=@"some"; //menuHeader.name;

  if(EMBERSLog()){
    NSLog(@"EMBERSLog: MENU_HEADER %@",menuHeader.nameExt);
  }
  [self.nameLabel sizeToFit];
  if(EMBERSShowBorders()){
    self.nameLabel.layer.borderColor=[UIColor redColor].CGColor;
    self.nameLabel.layer.borderWidth=2.0f;
  }
  if(MYLog()){
    NSLog(@"here is width: %f and heigth: %f", self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    NSLog(@"here is width: %f", self.nameLabel.frame.size.width);
  }
  
  //CGFloat leftOffset=((320.0f - self.nameLabel.frame.size.width) / 2 );
  //self.nameLabel.frame=CGRectMake(leftOffset, _mhTopPad , self.nameLabel.frame.size.width,self.nameLabel.frame.size.height);
  //self.nameLabel.frame=CGRectMake(20.0f, _mhTopPad , 280.0f,self.nameLabel.frame.size.height);

  //self.nameLabel.frame=CGRectMake(20.0f, _mhTopPad , /* 280.0f */ self.contentView.frame.size.width - 40.0f ,self.nameLabel.frame.size.height);
  
  // left offset
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  CGFloat leftOffset=(width-self.nameLabel.frame.size.width)/2;
  NSLog(@"here is the width: %f",width);
  
  self.nameLabel.frame=CGRectMake(leftOffset, _mhTopPad , self.nameLabel.frame.size.width ,self.nameLabel.frame.size.height);
  
  //self.nameLabel.frame=CGRectMake(20.0f, _mhTopPad , 280.0f,30.0f);
  /*
  if(EMBERSShowBorders()){
    self.nameLabel.layer.borderColor=[UIColor greenColor].CGColor;
    self.nameLabel.layer.borderWidth=2.0f;
  }
  */
  self.height=self.nameLabel.frame.size.height + _mhTopPad;
  
  if(![menuHeader.topDecorator isEqualToString:@""]){
    [self renderDecorator:menuHeader.topSecondaryDecorator];
  }
  
  if(![menuHeader.topSecondaryDecorator isEqualToString:@""]){
    [self renderDecorator:menuHeader.topSecondaryDecorator];
  }
  self.height+=5.0f;
  
  [self.contentView addSubview:self.nameLabel];
  //NSLog(@"about to update menuHeader cell: %@", menuHeader.name);
}

-(void)renderDecorator:(NSString *)decoratorValue
{
  UILabel *decoratorLabel=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 0.0f)];
  decoratorLabel.text=decoratorValue;
  [decoratorLabel sizeToFit];
  decoratorLabel.frame=CGRectMake(((320.0f - decoratorLabel.frame.size.width)/2), self.height + 10.0f , decoratorLabel.frame.size.width,decoratorLabel.frame.size.height);
  //self.height+=decoratorLabel.frame.size.height;

  if(EMBERSShowBorders()){
    decoratorLabel.layer.borderWidth=2.0f;
    decoratorLabel.layer.borderColor=[UIColor blueColor].CGColor;
  }
  
  [self.contentView addSubview:decoratorLabel];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
  
  self.nameLabel = nil;
  //[self.nameLabel removeFromSuperview];

  //self.detailLabel.text = nil;
  //self.spotView.subviews=nil;
  for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
    [self removeGestureRecognizer:recognizer];
  }
  //[[self.spotView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
  [super prepareForReuse];
}


@end
