//
//  MenuHeaderView.m
//  instore
//
//  Created by jonathan twaddell on 3/11/14.
//  Copyright (c) 2014 Trestles. All rights reserved.
//

#import "MenuHeaderView.h"
#import "MenuHeader.h"
#import "EMBERSConfig.h"

@interface MenuHeaderView ()
{
@private
  MenuHeader *_menuHeader;
  UIFont *_boldedFont;
  CGFloat _leftMenuHeaderOffset;
  CGFloat _labelWidth;
    
  /*
    CGFloat _headerWidth;
    CGFloat _detailWidth;
    CGFloat _leftPosition;
  */
    
}
@end


@implementation MenuHeaderView

-(id) initWithFrame:(CGRect)frame menuHeader:(MenuHeader *)menuHeader
{
  //_boldedFont = MYBoldedFont();
  _boldedFont = MYMenuHeaderFont();

  self = [self initWithFrame:frame];
  if (self) {
    _menuHeader = menuHeader;
    if([_menuHeader.layout isEqualToString:@"two-col-wine-dotted"]){
      _leftMenuHeaderOffset=40.0f;
      if(menuHeader.depth==1){
        _leftMenuHeaderOffset = _leftMenuHeaderOffset + 40.0f;
      }
      _labelWidth=500.0f;
    }else{
      _leftMenuHeaderOffset=0.0f;
      _labelWidth=320.0f;
    }
        
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftMenuHeaderOffset, 0.0f, 220.0f, 30.0f)];
    self.nameLabel.numberOfLines=0;

    if([_menuHeader.layout isEqualToString:@"two-col-wine-dotted"]){
      // some tmp stuff here
    }else{
      self.nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    if(MYLog()){
      NSLog(@"here is nameExt: %@", _menuHeader.nameExt);
    }
    self.nameLabel.text=_menuHeader.nameExt;

    if(MYShowBorders()){
      self.layer.borderColor =[UIColor blackColor].CGColor;
      self.layer.borderWidth = 3.0f;
      self.nameLabel.layer.borderColor = [UIColor redColor].CGColor;
      self.nameLabel.layer.borderWidth = 3.0;
    }
    [self.nameLabel sizeToFit];
    self.nameLabel.font= _boldedFont;
    self.nameLabel.textColor=MYMenuFontColor();
    
    if([_menuHeader.layout isEqualToString:@"two-col-wine-dotted"]){
      /*
      _leftMenuHeaderOffset=40.0f;
      if(menuHeader.depth==1){
        _leftMenuHeaderOffset = _leftMenuHeaderOffset + 40.0f;
      }
      
      _labelWidth=500.0f;
      */
    }else{
      //_leftMenuHeaderOffset=0.0f;
      //_labelWidth=320.0f;
      self.nameLabel.frame=CGRectMake((320.0f-self.nameLabel.frame.size.width)/2, 0.0f, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);

    }

    
    [self addSubview:self.nameLabel];
    self.height=self.nameLabel.frame.size.height;
    if(MYLog()){
      NSLog(@"height within nameLabel :%f", self.nameLabel.frame.size.height);
    }
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
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
