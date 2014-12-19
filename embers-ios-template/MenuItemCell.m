//
//  MenuItemCell.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/18/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MenuItemCell.h"
#import "MenuItem.h"
#import "EMBERSConfig.h"

@interface MenuItemCell(){
  CGFloat _miTopPad;
  CGFloat _miBottomPad;
  CGFloat _miHeaderDetailLeftPadding;
  CGFloat _miHeaderDetailWidth;
  CGFloat _mhCellHeight;
  CGFloat _miCellHeight;
  CGFloat _priceLeftPad;
  CGFloat _spotLeftPad;
  NSString  *_miAccentPositions;
  CGFloat _newLeftOffset;
  CGFloat _newContentWidth;
  CGFloat _priceHeight;

}

@end

@implementation MenuItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

-(UIView *)circleWithColor:(UIColor *)color radius:(int)radius {
  UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * radius, 2 * radius)];
  circle.backgroundColor = color;
  circle.layer.cornerRadius = radius;
  circle.layer.masksToBounds = YES;
  return circle;
}

-(void)updateCell:(MenuItem *)menuItem
{
  _miTopPad=10.0f;
  _miBottomPad=10.0f;
  _miHeaderDetailLeftPadding=30.0f;
  _miHeaderDetailWidth=230.0f;
  _miAccentPositions=@"top";
  _priceLeftPad=280.0f;
  _spotLeftPad=9.0f;
  
  [self renderPrice:menuItem.price];
  
  if(![menuItem.binNumber isEqualToString:@""]  && [menuItem.whichPrice isEqualToString:@"bottle"]){
    self.headerLabel.text=[NSString stringWithFormat:@"%@    %@",menuItem.header, menuItem.binNumber];
  }else{
    self.headerLabel.text=menuItem.header;
    //self.headerLabel.text=@"";
  }
  
  [self renderHeader:menuItem.header];
  [self renderDetail:menuItem.detail];
  [self renderMeta:menuItem];
  
  if([_miAccentPositions isEqualToString:@"top"]){
    //self.priceLabel.frame = CGRectMake(_newLeftOffset, _miTopPad, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    self.spotView.frame = CGRectMake(_spotLeftPad, _miTopPad, 10.0f, 16.0f);
  }else if([_miAccentPositions isEqualToString:@"middle"]){
    self.priceLabel.frame = CGRectMake(_newLeftOffset, ((self.height - self.priceLabel.frame.size.height)/2), self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    self.spotView.frame = CGRectMake(_spotLeftPad, ((self.height - self.spotView.frame.size.height)/2), 10.0f, 16.0f);
  }else if([_miAccentPositions isEqualToString:@"bottom"]){
    self.priceLabel.frame = CGRectMake(_newLeftOffset, (self.height - _miBottomPad - self.priceLabel.frame.size.height) , self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    self.spotView.frame = CGRectMake(_spotLeftPad, (self.height - _miBottomPad - self.spotView.frame.size.height), 10.0f, 16.0f);
  }
  
  if(![menuItem.miSeparator isEqualToString:@""]){
    NSLog(@"this is not blank with %@", menuItem.miSeparator);
    UILabel *miSeparator=[[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.height, 200.0f, 0.0f)];
    miSeparator.text=menuItem.miSeparator;
    [miSeparator sizeToFit];
    [self.contentView addSubview:miSeparator];
    CGFloat leftOffset=((320.0f - miSeparator.frame.size.width)/2);
    miSeparator.frame=CGRectMake(leftOffset, self.height, miSeparator.frame.size.width, miSeparator.frame.size.height);
    self.height+=miSeparator.frame.size.height + 3.0f;
  }
}

- (void)renderMeta:(MenuItem *)menuItem{
  if([menuItem hasInstoreImage] || [menuItem hasTastingNotes]){
    if([menuItem hasInstoreImage]){
      UIView *instoreImageDot=[self circleWithColor:[UIColor redColor] radius:4];
      [self.spotView addSubview:instoreImageDot];
    }
    
    if([menuItem hasTastingNotes]){
      UIView *tastingNoteDot=[self circleWithColor:[UIColor blackColor] radius:4];
      [self.spotView addSubview:tastingNoteDot];
      tastingNoteDot.frame=CGRectMake(tastingNoteDot.frame.origin.x, tastingNoteDot.frame.origin.y + 10.0f, tastingNoteDot.frame.size.width, tastingNoteDot.frame.size.height);
      
      NSLog(@"THIS ITEM %@ has tasting notes", menuItem.header);
      UIView *tastingNote=[self circleWithColor:[UIColor blackColor] radius:4];
      tastingNote.frame=CGRectMake(tastingNote.frame.origin.x, tastingNote.frame.origin.y + 10.0f, tastingNote.frame.size.width, tastingNote.frame.size.height);
    }
  }

}

- (void)renderDetail:(NSString *)detail{
  if(MYLog()){
    NSLog(@"AT TOP OF renderDetail");
  }
  
  if(detail){
    self.detailLabel.frame=CGRectMake(_miHeaderDetailLeftPadding, _miTopPad, _newContentWidth, 1000.0f);

    self.detailLabel.text=detail;
    self.detailLabel.numberOfLines=0;

    self.detailLabel.font=MYMainFont();
    [self.detailLabel sizeToFit];
    //self.detailLabel.frame=CGRectMake(_miHeaderDetailLeftPadding, self.headerLabel.frame.size.height + 10.0f + 5.0f, newContentWidth, 1000.0f);
    //NSLog(@"HEIGHT of Detail: %f",self.detailLabel.frame.size.height);

    NSLog(@"HEIGHT of Detail: %f and self.headerLabel.frame.size.height: %f",self.detailLabel.frame.size.height, self.headerLabel.frame.size.height);

    self.detailLabel.frame=CGRectMake(_miHeaderDetailLeftPadding, self.headerLabel.frame.size.height +  12.0f, _newContentWidth, self.detailLabel.frame.size.height);
    NSLog(@"HEIGHT of Detail: %f",self.detailLabel.frame.size.height);
    if(MYShowBorders()){
      self.detailLabel.layer.borderColor=[UIColor blueColor].CGColor;
      self.detailLabel.layer.borderWidth=2.0f;
    }
    self.height+=self.detailLabel.frame.size.height;
  }
  
  if(MYLog()){
    //NSLog(@"here is width for price for %@ : %f", self.priceLabel.text, self.priceLabel.frame.size.width);
    //NSLog(@"here is height for price %@ : %f",self.priceLabel.text, self.priceLabel.frame.size.height);
  }
  if(MYLog()){
    NSLog(@"AT BOTTOM OF renderDetail %f", self.detailLabel.frame.size.height);
  }

}


- (void)renderHeader:(NSString *)header
{
  NSLog(@"here is the header %@", header);
  self.headerLabel.numberOfLines=0;
  self.headerLabel.font=MYMainFont();
  
  self.headerLabel.frame=CGRectMake(_miHeaderDetailLeftPadding, _miTopPad, _newContentWidth, 1000.0f);
  [self.headerLabel sizeToFit];
  if(MYShowBorders()){
    self.headerLabel.layer.borderColor=[UIColor redColor].CGColor;
    self.headerLabel.layer.borderWidth=2.0f;
  }
  
  self.headerLabel.frame=CGRectMake(_miHeaderDetailLeftPadding, _miTopPad, _newContentWidth, self.headerLabel.frame.size.height);
  
  if(MYLog()){
    NSLog(@"here is width for %@ : %f", self.headerLabel.text, self.headerLabel.frame.size.width);
    NSLog(@"here is height for %@ : %f",self.headerLabel.text, self.headerLabel.frame.size.height);
  }
  self.height=self.headerLabel.frame.size.height + _miTopPad + _miBottomPad;
  
  if(_priceHeight>self.height){
    self.height=_priceHeight + 10.0f;
  }
  
  NSLog(@"HEIGHT AT BOTTOM  OF HEADER: %f for %@", self.height, header);
}


- (void)renderPrice:(NSString *)price
{
  //price=@"here \nis a price for you \nif you like it";
  //if([price isEqualToString:@"17"]){
  //  price=@"you are 17 \nother things \nlike this";
  //}
  //NSLog(@"here is the price %@", price);
  self.priceLabel.font=MYMainFont();
  //[self.priceLabel sizeToFit];
  if(MYShowBorders()){
    self.priceLabel.layer.borderWidth=2.0f;
    self.priceLabel.layer.borderColor=[UIColor blueColor].CGColor;
    self.spotView.layer.borderWidth=2.0f;
    self.spotView.layer.borderColor=[UIColor redColor].CGColor;
  }
  self.priceLabel.textAlignment = NSTextAlignmentLeft;
  CGSize size = [price sizeWithAttributes:
                 @{NSFontAttributeName:
                     MYMainFont()}];
  
  size.height = ceilf(size.height);
  size.width = ceilf(size.width);
  
  NSLog(@"values are %f or %f", size.height, size.width);
  // Values are fractional -- you should take the ceilf to get equivalent values
  size.height = ceilf(size.height);
  size.width = ceilf(size.width);
  NSLog(@"price width %f for %@", self.priceLabel.frame.size.width, self.priceLabel.text);
  
  
  if ([price rangeOfString:[NSString stringWithFormat:@"%@",@"\n"]].location != NSNotFound)
  {
    //return YES;
    NSLog(@"this value is found");
    self.priceLabel.frame=CGRectMake(20.0f, 20.0f, 300.0f, 5.0f);

    //NSLog(@"this value is not found");
    //if(self.priceLabel.frame.size.width > 25.0f){
    _newLeftOffset=_priceLeftPad + 20.0f - self.priceLabel.frame.size.width;
    _newContentWidth=_miHeaderDetailWidth + 20.0f - self.priceLabel.frame.size.width;
    self.priceLabel.text=price;
    self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.priceLabel.numberOfLines=0;
    [self.priceLabel sizeToFit];
    NSLog(@"the priceLabel width is: %f for %@", self.priceLabel.frame.size.width, price);
    
    //self.priceLabel.frame.size.width
    CGFloat leftSide=320.0f - self.priceLabel.frame.size.width - 20.0f;
    self.priceLabel.frame = CGRectMake(leftSide, _miTopPad, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
    //_newLeftOffset=200.0f;
    _newContentWidth=320.0f - self.priceLabel.frame.size.width - 20.0f - 40.0f;

    
    
  }else{
    if(size.width > 25.0f){
      NSLog(@"this value is not found");
      //if(self.priceLabel.frame.size.width > 25.0f){
      _newLeftOffset=_priceLeftPad + 20.0f - self.priceLabel.frame.size.width;
      _newContentWidth=_miHeaderDetailWidth + 20.0f - self.priceLabel.frame.size.width;
      self.priceLabel.text=price;
      self.priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
      self.priceLabel.frame=CGRectMake(20.0f, 20.0f, 100.0f, 5.0f);
      self.priceLabel.numberOfLines=0;
      [self.priceLabel sizeToFit];
      NSLog(@"the priceLabel width is: %f for %@", self.priceLabel.frame.size.width, price);
      self.priceLabel.frame = CGRectMake(200.0f, _miTopPad, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);
      _newLeftOffset=200.0f;
      _newContentWidth=160.0f;
    }else{
    _newLeftOffset=_priceLeftPad;
    _newContentWidth=_miHeaderDetailWidth;
    self.priceLabel.text=price;
    [self.priceLabel sizeToFit];
    NSLog(@"here is the width in the not > 25.0 width: %f for %@ and _newLeftOffset: %f", self.priceLabel.frame.size.width, self.priceLabel.text, _newLeftOffset);
    _newLeftOffset=290.0f-self.priceLabel.frame.size.width;
    self.priceLabel.frame = CGRectMake(_newLeftOffset, _miTopPad, self.priceLabel.frame.size.width, self.priceLabel.frame.size.height);

  
  }
  }
  _priceHeight=self.priceLabel.frame.size.height;
  NSLog(@"HEIGHT AT BOTTOM  OF PRICE: %f for price: %@", self.priceLabel.frame.size.height, price);
  
}

- (void)prepareForReuse
{
  
  self.headerLabel.text = nil;
  self.detailLabel.text= nil;
  //self.spotView.subviews=nil;
  for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
    [self removeGestureRecognizer:recognizer];
  }
  [[self.spotView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
  [super prepareForReuse];
}


@end
