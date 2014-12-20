//
//  MenuItemView.m
//  instore
//
//  Created by jonathan twaddell on 3/6/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#define RGB(R, G, B)                        ([UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f])


#import "MenuItemView.h"
#import "EMBERSConfig.h"
#import "MenuItem.h"


@interface MenuItemView ()
{
@private
  MenuItem *_menuItem;
  UIFont *_mainFont;
  UIFont *_priceFont;

  CGFloat _headerWidth;
  CGFloat _detailWidth;
  CGFloat _leftPosition;
  CGSize _exptectedDetailSize;
  UIView *_spotView;
  CGFloat _totalMenuItemViewHeight;
}
@end

@implementation MenuItemView

-(id)initWithFrame:(CGRect)frame menuItem:(MenuItem *)menuItem
{
  self = [self initWithFrame:frame];
  if (self) {
    _menuItem = menuItem;
    if(_menuItem.isTopView){
      _mainFont = MYMainFont();
      _leftPosition = 10.0f;
    }else {
      _mainFont = MYMainFont();
      _leftPosition = 30.0f;
      _priceFont=MYPriceFont();
    }
    
    [self renderPrice:menuItem];
    self.miVHeight=0.0f;

    
    NSString *tmpString;
    if([menuItem.whichPrice isEqualToString:@"bottle"]){
      self.binNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
      [self.binNumberLabel setUserInteractionEnabled:YES];
      self.binNumberLabel.text=menuItem.binNumber;
      self.binNumberLabel.textColor = MYMenuFontColor();
      tmpString=[NSString stringWithFormat:@"%@       %@",[menuItem header], menuItem.binNumber];
    }else{
      tmpString=[NSString stringWithFormat:@"%@",[menuItem header]];
    }
        
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 1000.0f)];
    self.headerLabel.numberOfLines=0;
    self.headerLabel.textColor=[UIColor darkGrayColor];
    [self.headerLabel setUserInteractionEnabled:YES];

    
    NSMutableAttributedString *headerAS = [[NSMutableAttributedString alloc] initWithString:tmpString attributes:@{NSFontAttributeName:_mainFont}];
    if(!menuItem.isTopView){
      _spotView = [[UIView alloc] initWithFrame:CGRectMake(9.0f, 0.0f, 10.0f, 16.0f)];
    }

    if(EMBERSShowBorders()){
      self.layer.borderColor =[UIColor blackColor].CGColor;
      self.layer.borderWidth = 3.0f;
      self.headerLabel.layer.borderColor = [UIColor redColor].CGColor;
      self.headerLabel.layer.borderWidth = 3.0f;
      self.binNumberLabel.layer.borderColor = [UIColor orangeColor].CGColor;
      self.binNumberLabel.layer.borderWidth = 3.0f;
    }

    self.headerLabel.attributedText = headerAS;
    self.headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.headerLabel sizeToFit];

    if(_menuItem.isTopView){
      NSLog(@"THIS IS TOP VIEW");
      _headerWidth = 240.0F;
      _detailWidth = 240.0F;
    }

    if([menuItem.whichPrice isEqualToString:@"bottle"]){
      _headerWidth = 195.0F;
      CGRect binNumberRect;
      binNumberRect=CGRectMake(30.0f ,0.0f, 50.0f, 30.0f);
      self.binNumberLabel.frame = binNumberRect;
    }
        
    CGRect rect;
    if(_menuItem.isTopView){
      rect = [headerAS boundingRectWithSize:CGSizeMake(240.0f, 10000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
      CGRect headerRect=CGRectMake(30.0f,0.0f, 220.0f, rect.size.height);
      self.headerLabel.frame = headerRect;
    }

    if(self.priceLabel.frame.size.width > 20){
      NSLog(@"PRICELABEL is larger than %@", self.priceLabel.text);
      _headerWidth =  (self.headerLabel.frame.size.width - self.priceLabel.frame.size.width);
    }else{
      NSLog(@"PRICELABEL is less than 20 than %@", self.priceLabel.text);
    }
  

    self.miVHeight= self.miVHeight + self.headerLabel.frame.size.height;
    [self addSubview:self.headerLabel];

    if(self.headerLabel.frame.size.height>self.priceLabel.frame.size.height){
      self.miVHeight=self.headerLabel.frame.size.height;
    }

    if(![[menuItem detail] isEqualToString:@""]){
      [self renderDetail:menuItem];
    }
 
    _totalMenuItemViewHeight=self.headerLabel.frame.size.height;
    CGFloat halfie = (_totalMenuItemViewHeight - _priceLabel.frame.size.height)/2;

    NSString *whichItemLayout=MYWhichItemLayout();
    if([whichItemLayout isEqualToString:@"middle"]){
      _priceLabel.frame=CGRectMake(_priceLabel.frame.origin.x ,halfie, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
      if(!menuItem.isTopView){
       _spotView.frame=CGRectMake(_spotView.frame.origin.x ,halfie, _spotView.frame.size.width, _spotView.frame.size.height);
      }

    }else if ([whichItemLayout isEqualToString:@"top"]){
      _priceLabel.frame=CGRectMake(_priceLabel.frame.origin.x ,0.0f, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
      if(!menuItem.isTopView){
        _spotView.frame=CGRectMake(_spotView.frame.origin.x ,0.0f, _spotView.frame.size.width, _spotView.frame.size.height);
      }
    }else if([whichItemLayout isEqualToString:@"bottom"]) {
      CGFloat _bottomValPrice=_totalMenuItemViewHeight -_priceLabel.frame.size.height;
      CGFloat _bottomValSpot=(_totalMenuItemViewHeight -_spotView.frame.size.height) - 5.0f;
      _priceLabel.frame=CGRectMake(_priceLabel.frame.origin.x, _bottomValPrice, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
      if(!menuItem.isTopView){
        _spotView.frame=CGRectMake(_spotView.frame.origin.x ,_bottomValSpot, _spotView.frame.size.width, _spotView.frame.size.height);
      }

    }
  }
  return self;
}

-(UIView *)circleWithColor:(UIColor *)color radius:(int)radius {
  UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * radius, 2 * radius)];
  circle.backgroundColor = color;
  circle.layer.cornerRadius = radius;
  circle.layer.masksToBounds = YES;
  return circle;
}


- (id)initWithFrame:(CGRect)frame
{
    _mainFont = MYMainFont();
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)writeItem:(NSString *)myString
{
    _headerLabel.text=myString;
}


-(void)renderDetail:(MenuItem *)menuItem
{
  NSLog(@"within renderDetail here");
  _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _detailLabel.numberOfLines = 0;
  _detailLabel.text=menuItem.detail;

  if(EMBERSShowBorders()){
    _detailLabel.layer.borderColor = [UIColor greenColor].CGColor;
    _detailLabel.layer.borderWidth = 3.0;
  }
  
  _detailLabel.font= _mainFont; //     return [UIFont fontWithName:@"HelveticaNeue-Light" size:(22.0)];
  _detailLabel.textColor = MYMenuFontColor();
  [_detailLabel sizeToFit];
  [self addSubview:_detailLabel];
  _detailLabel.frame=CGRectMake(30.0f,20.0f, 220.0f, _detailLabel.frame.size.height);
  self.miVHeight+= _detailLabel.frame.size.height;
}


-(void)renderPrice:(MenuItem *)menuItem
{
  if(MYLog()){
    NSLog(@"NEW-NEW about to render price");
  }
  _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 90.0f, 1000.0f)];
  _priceLabel.text = menuItem.price;
  _priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _priceLabel.textAlignment = NSTextAlignmentRight;
  _priceLabel.numberOfLines = 0;
  _priceLabel.textColor = MYMenuFontColor();
  _priceLabel.font=_priceFont;
  
  if(EMBERSShowBorders()){
    _priceLabel.layer.borderColor = [UIColor blueColor].CGColor;
    _priceLabel.layer.borderWidth = 1.0f;
  }
  
  CGFloat newPriceY;
  newPriceY = 0.0f;

  [_priceLabel sizeToFit];
  CGFloat priceWidth=_priceLabel.frame.size.width;
  
  if(priceWidth > 20.0f){
    _priceLabel.font=_mainFont;
  }else{
  }
  _priceLabel.frame=CGRectMake(300.0f - priceWidth,newPriceY, _priceLabel.frame.size.width, _priceLabel.frame.size.height);
  self.miVHeight=_priceLabel.frame.size.height;
  [self addSubview:_priceLabel];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    myLabel.text=@"hjere is my text";
    [
    

}
*/

@end
