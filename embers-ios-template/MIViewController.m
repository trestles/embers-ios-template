//
//  MIViewController.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/19/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MIViewController.h"
#import "EMBERSConfig.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "TastingNote.h"
#import "MenuItemView.h"
#import "CacheController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MIViewController (){
@private
  CGFloat _realHeight;
  CGFloat _runningYPosition;
  CGFloat _moveUpPosition;
  CGFloat _noteViewY;  // if there is an image will set to 800px or will set to 30
  CGFloat _noteViewYSlideUpValue;
  CGFloat _borderWidthFloat;
  CGFloat _cornerRadius;
  CGFloat _scrollViewStart;
  CGFloat _miTopViewHeight;
  CGFloat _topMiViewOffset;
  CGFloat _bottomMiViewOffset;

  BOOL _isFirstTime;
  BOOL _hasInstoreImage;
  BOOL _isFirstReferencedTastingNote;

  UIView *_tastingNoteV;
  UIScrollView *_tastingNoteScrollView;
  UIFont *_boldedFont;
  UIFont *_mainFont;
  UIButton *_scrollButton;
  UIButton *_scrollTopViewButton;
  UIView *_miTopView;

  
  
}

@end

@implementation MIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
  if(self = [super initWithCoder:aDecoder]) {
    _topMiViewOffset = 5.0f;
    _bottomMiViewOffset = 0.0f;
    _noteViewYSlideUpValue=100.0f;
    //[self.navigationController setNavigationBarHidden:YES];
    _mainFont = MYMainFont();
    _boldedFont = MYBoldedFont();
    _isFirstTime=YES;
    _hasInstoreImage=NO;
    _isFirstReferencedTastingNote=YES;
    _borderWidthFloat = MYBorderWidth();
    _cornerRadius = MYCornerRadius();
    _scrollViewStart=300.0f;
  }
  return self;
}

- (void)viewDidLoad
{
  if(IS_IPHONE_5){
    _realHeight=504.0f;
  }else{
    _realHeight=416.0f;
  }

  //[self.navigationController.navigationBar]
  /*
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:[UIImage new]];
  [self.navigationController.navigationBar setTranslucent:YES];
  */
  [super viewDidLoad];
  
  
  //NSLog(@"here is from menuItem %lu", (long)self.menuItem.menuItemID);
  //NSLog(@"here is from menuItem header %@", self.menuItem.header);
  //NSLog(@"ABOUT TO START MENUITEMVIEWCONTROLLER 1");
  //NSLog(@"-------------------------------------");
  //NSLog(@"ABOUT TO START MENUITEMVIEWCONTROLLER 2");
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  
  if(![_menuItem.instoreImageURL isEqualToString:@"nothing"]){
    _hasInstoreImage=YES;
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.backgroundImage setBackgroundColor: [UIColor whiteColor]];
    self.bgSV=[[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, screenHeight)];
    //self.bgSV.delegate=self;
    [self.bgSV addSubview:self.backgroundImage];
    [self.bgSV setBackgroundColor:[UIColor whiteColor]];

    self.bgSV.minimumZoomScale=1.0;
    self.bgSV.maximumZoomScale=1.5;
    self.bgSV.scrollEnabled=NO;
    self.bgSV.delegate=self;
    [self.view addSubview:self.bgSV];
    
    NSURL *imageURL = [NSURL URLWithString:[EMBERSImageHost() stringByAppendingString:_menuItem.instoreImageURL]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageURL
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)

      {
       NSLog(@"this downloaded");
      }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
       if (image){

         [MBProgressHUD hideHUDForView:self.view animated:YES];
         self.backgroundImage.image = image;
         CGFloat factor=320 / self.backgroundImage.image.size.width;
         CGFloat height=self.backgroundImage.image.size.height;
         //NSLog(@"here is height %f and screenHeight %f and _realHeight %f", height*factor, screenHeight, _realHeight);

         //NSLog(@"here is %f %f and my factor: %f", self.backgroundImage.image.size.width, self.backgroundImage.image.size.height, factor);
         self.bgSV.contentSize=CGSizeMake(320, height*factor);

         //NSLog(@"here is image width: %f and image height: %f and factor will be: %f", self.backgroundImage.image.size.width, self.backgroundImage.image.size.height, factor);
         //backgroundImage.image.
         
         // y offset
         CGFloat _yImgOffset=64.0f;
         
         if(self.backgroundImage.image.size.height < _realHeight){
           // lets calculate some offset
           CGFloat diff=(_realHeight-self.backgroundImage.image.size.height) / 2;
           _yImgOffset+=diff;
           
         }
         self.backgroundImage.frame= CGRectMake(0.0f, _yImgOffset, (self.backgroundImage.image.size.width * factor), (self.backgroundImage.image.size.height * factor));
         if(height*factor < screenHeight){
           CGFloat heightDifference=screenHeight - (height*factor);
           //NSLog(@"here is %f", heightDifference);
           // lets put it halfway
           self.backgroundImage.frame=CGRectMake(0.0f, (heightDifference / 3), 320.0f, (height*factor));
           
         }
       }
     }];

    if(IS_IPHONE_5){
      _noteViewY=500.0f; // <- what does this do?
    }else{
      _noteViewY=400.0f; // <- what does this do?
    }
  }else{
    NSDictionary *bgImg = [[CacheController sharedInstance] getCacheForKey:@"mobileMenuItemDetailBackground"];
    //NSLog(@"WILL CHECK TO SEE if we have a location menu_item_background_detail %@", bgImg);
    
    CGRect r = self.noteView.frame;
    r.origin.x=0.0f;
    r.origin.y=0.0f;
    self.noteView.frame=r;
    _noteViewY=_miTopView.frame.size.height + 100.0f;  // <- should be calculated from miTopViewHeight!!! plus a value

    UIImageView *backgroundImage = [[UIImageView alloc] init]; //]WithImage:[UIImage imageNamed:@"mi-bg.jpg"]];

    if(bgImg!=nil){
      //NSLog(@"WILL CHECK TO SEE menu_item_background_detail %@", bgImg[@"url"]);
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EMBERSHost(), bgImg[@"url"]]];
      [manager downloadWithURL:imageURL
                       options:0
                      progress:^(NSInteger receivedSize, NSInteger expectedSize)
       {}
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
       {
         if (image)
         {
           backgroundImage.image=image;
         }
       }];
    }else{
      NSLog(@"WILL CHECK TO SEE menu_item_background_detail %@", bgImg);
      backgroundImage.image=[UIImage imageNamed:@"mi-bg.jpg"];
    }
  
    backgroundImage.frame= CGRectMake(0.0, 0.0, MYFullWidth(), MYFullHeight());
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
  }
  
  self.noteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
  
  [self renderMenuItemTopView: self.menuItem];
  
  
  if([self.menuItem.tastingNotes count] > 0 || [self.menuItem.referencedTastingNotes count] > 0){
    if(!_hasInstoreImage){
      _noteViewY=_noteViewY + _miTopView.frame.size.height;
    }
    _tastingNoteV = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _noteViewY, MYFullWidth(), MYFullHeight())];
    _tastingNoteV.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    
    // lets create a
    if(_hasInstoreImage){
      _tastingNoteScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 55.0f, 300.0f, 800.0f)];  // <- should evaluate this later
    }else{
      _tastingNoteScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 800.0f)];  // <- should evaluate this later
    }
    _tastingNoteScrollView.contentSize = CGSizeMake(280.0f,2000.0f);
    _tastingNoteScrollView.scrollEnabled = YES;
    _tastingNoteScrollView.showsVerticalScrollIndicator=YES;
    _tastingNoteScrollView.userInteractionEnabled=YES;
    if(EMBERSShowBorders()){
      _tastingNoteScrollView.layer.borderColor =[UIColor blackColor].CGColor;
      _tastingNoteScrollView.layer.borderWidth = 3.0f;
    }
    [_tastingNoteV addSubview:_tastingNoteScrollView];
    
    
    [self.view addSubview:_tastingNoteV];
    [self.view bringSubviewToFront:_miTopView];
    
    if(_hasInstoreImage){
      UIView *pairingNoteTopView=[[UIView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 320.0f, 50.0f)];
      UIImageView  *glassForkIV =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glass-fork.png"]];
      glassForkIV.frame=CGRectMake(10.0f,8.0f, 37.0f, 37.0f);
      //[_tastingNoteV addSubview:glassForkIV];
      UILabel *pairingNotesLabel=[[UILabel alloc] initWithFrame:CGRectMake(56.0f, 18.0f, 150.0f, 25.0f)];
      pairingNotesLabel.text=@"Pairing Notes";
      pairingNotesLabel.textColor=MYMenuFontColor();
      _scrollButton = [[UIButton alloc] initWithFrame:CGRectMake(174.0f,20.0f, 20.0f, 20.0f)];
      [_scrollButton setBackgroundImage:[UIImage imageNamed:@"image-up1.png"] forState:UIControlStateNormal];
      [_scrollButton setBackgroundImage:[UIImage imageNamed:@"image-down1.png"] forState:UIControlStateSelected];
      [pairingNoteTopView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)]];
      [_scrollButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)]];
      [pairingNoteTopView addSubview:glassForkIV];
      [pairingNoteTopView addSubview:pairingNotesLabel];
      [pairingNoteTopView addSubview:_scrollButton];
      [_tastingNoteV addSubview:pairingNoteTopView];
    }else{
      if(MYLog()){
        NSLog(@"_hasInstoreImage is false");
      }
    }
    
    _runningYPosition = 10.f; // Y position of first text view
    if(MYLog()){
      NSLog(@"JTJT here is a count: %lu", (long)[self.menuItem.tastingNotes count]);
    }

    for (TastingNote *tn in self.menuItem.tastingNotes) {
      [self renderTastingNote:tn];
    }

    if(MYLog()){
      NSLog(@"here is the runningYPosition %f", _runningYPosition);
    }
    [self renderReferencedTastingNotes:self.menuItem];
  }

  if(_runningYPosition < 360){
    _tastingNoteScrollView.scrollEnabled = NO;
  }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
  NSLog(@"you called me");
  return self.backgroundImage;
}

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"you are scrolling");
}
 */

-(void)renderTastingNote:(TastingNote *)tn
{
  NSLog(@"running within renderTastingNote");
  NSLog(@"about to renderTastingNote %lu", (unsigned long)tn.tastingNoteID);
  UITextView *textview= [[UITextView alloc]initWithFrame:CGRectZero];
  textview.layer.cornerRadius = _cornerRadius;
  textview.selectable = NO;
  [textview  setTextContainerInset:UIEdgeInsetsMake(7, 7, 7, 7)];
    //NSString *myString=[NSString stringWithFormat:@"%@ \n %@", tn.processedInstore.header, tn.processedInstore.body];
  NSString *myString=[NSString stringWithFormat:@"%@",tn.processedInstore.body];
    
  NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:myString attributes:@ {
    NSFontAttributeName : _mainFont, NSForegroundColorAttributeName: MYMenuFontColor() }];

  for (NSString *val in tn.processedInstore.frags){
    NSRange r = [myString rangeOfString:val];
    [atString addAttributes:@ {NSFontAttributeName : _boldedFont} range:r ];
  }
  textview.attributedText=atString;
  CGSize textViewSize = [textview sizeThatFits:CGSizeMake(300.f, CGFLOAT_MAX)];
  textview.frame = CGRectMake(0.0f, _runningYPosition, 300.0f, textViewSize.height);
  [_tastingNoteScrollView addSubview:textview];
  _runningYPosition = CGRectGetMaxY(textview.frame) + 20.f;
}

-(void)renderReferencedTastingNotes:(MenuItem *) menu_item
{
  NSUInteger prev_menu_item_id=0;
  if(menu_item.referencedTastingNotes>0){
    for (TastingNote *tn in menu_item.referencedTastingNotes) {
      //for (int i = 0; i < [refs count]; i++) {
      if(MYRefTN1()){
        if(_isFirstReferencedTastingNote){
          _isFirstReferencedTastingNote=NO;
        }
      }
      
      MenuItem *tmp_mi=tn.menuItem;
      NSUInteger current_menu_item_id=tmp_mi.menuItemID;
      //NSLog(MYRefTN1() ? @"Yes it is MyRefTN!" : @"No it is MyRefTN!");
      if(MYRefTN1()){
        //if([prev_menu_item_id isEqual:current_menu_item_id]){
        if(prev_menu_item_id==current_menu_item_id){
          NSLog(@"those are the same");
        }else{
          //[self renderMenuItem:tn.menuItem];
        }
      }
      
      [self renderTastingNoteTwo:tn];
      
      _runningYPosition+=100.f;
      prev_menu_item_id=tn.menuItem.menuItemID;
    }
  }
}

-(void)renderTastingNoteTwo:(TastingNote *)note
{
  MenuItem *refMenuItem = note.menuItem;
  UIView *referencedTastingNote = [[UIView alloc] initWithFrame:CGRectMake(0.0f, _runningYPosition, 668.0f, 100.0f)];
  referencedTastingNote.backgroundColor = [UIColor whiteColor];
  
  if(EMBERSShowBorders()){
    referencedTastingNote.layer.borderWidth = 2.0f;
    referencedTastingNote.layer.borderColor = [[UIColor redColor] CGColor];
  }
  
  UILabel *refLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0f, 300.0F, 30.0f)];
  refLabel.textAlignment = NSTextAlignmentCenter;
  if(EMBERSShowBorders()){
    refLabel.layer.borderWidth = 2.0f;
    refLabel.layer.borderColor = [[UIColor blueColor] CGColor];
  }
  refLabel.text = @"goes with...";
  refLabel.font = _mainFont;
  
  // width of
  UILabel *refHeader = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 60.0f, 250.0f, 30.0f)];
  refHeader.lineBreakMode = NSLineBreakByWordWrapping;
  refHeader.numberOfLines = 0;
  refHeader.font = _mainFont;
  if(EMBERSShowBorders()){
    refHeader.layer.borderColor= [[UIColor blackColor] CGColor];
    refHeader.layer.borderWidth= 3.0f;
  }
  refHeader.text = refMenuItem.header;
  [refHeader sizeToFit];
  
  UILabel *refPrice = [[UILabel alloc] initWithFrame:CGRectMake(270.0f, 60.0f, 100.0f, 30.0f)];
  refPrice.lineBreakMode = NSLineBreakByWordWrapping;
  refPrice.font=_mainFont;
  refPrice.numberOfLines = 0;
  if(EMBERSShowBorders()){
    refPrice.layer.borderColor= [[UIColor blackColor] CGColor];
    refPrice.layer.borderWidth= 3.0f;
  }
  refPrice.text = refMenuItem.processedPrice;
  [refPrice sizeToFit];
  
  if(![refMenuItem.detail isEqualToString:@""]){
    UILabel *refDetail = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 60.0f, 668.0f, 30.0f)];
    refDetail.text = refMenuItem.detail;
  }
  
  NSLog(@"about to renderTastingNote");
  UITextView *textview= [[UITextView alloc]initWithFrame:CGRectZero];
  
  
  if(EMBERSShowBorders()){
    textview.layer.borderWidth = _borderWidthFloat;
    textview.layer.borderColor = [[UIColor greenColor] CGColor];
  }
  textview.selectable = NO;
  [textview  setTextContainerInset:UIEdgeInsetsMake(7, 7, 7, 7)];

  NSString *myString=[NSString stringWithFormat:@"%@ \n %@", note.processedInstore.header, note.processedInstore.body];
  NSMutableAttributedString *atString = [[NSMutableAttributedString alloc] initWithString:myString attributes:@ {
    NSFontAttributeName : _mainFont }];
  for (NSString *val in note.processedInstore.frags){
    NSLog(@"here is %@", val);
    NSRange r = [myString rangeOfString:val];
    [atString addAttributes:@ {
      NSFontAttributeName : _boldedFont} range:r ];
  }
  textview.scrollEnabled=NO;
  textview.attributedText=atString;
  
  // Set the text view frame
  CGSize textViewSize = [textview sizeThatFits:CGSizeMake(280.0f, CGFLOAT_MAX)];
  textview.frame = CGRectMake(0.0f, 110.0f, 280.0f, textViewSize.height);
  
  referencedTastingNote.frame = CGRectMake(0.0f, _runningYPosition, 668.0f, textViewSize.height + 200.0f);
  [referencedTastingNote addSubview:textview];
  [referencedTastingNote addSubview:refLabel];
  [referencedTastingNote addSubview:refHeader];
  [referencedTastingNote addSubview:refPrice];
  
  [_tastingNoteScrollView addSubview:referencedTastingNote];
  _runningYPosition = CGRectGetMaxY(textview.frame) + 20.f;
}


-(void)renderMenuItemTopView:(MenuItem *)menu_item
{
  if(MYLog()){
    NSLog(@"here is _menuItem top view with id: %li", (long)menu_item.menuItemID);
    NSLog(@"current _runningYPosition: %f", _runningYPosition);
  }
  
  _miTopView = [[UIView alloc] initWithFrame:CGRectZero];
  _menuItem.isTopView = YES;
  MenuItemView *miView = [[MenuItemView alloc] initWithFrame:CGRectZero menuItem:self.menuItem];
  [_miTopView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5f]];

  [_miTopView addSubview:miView];
  miView.frame = CGRectMake(0.0f, _topMiViewOffset, MYFullWidth(), miView.miVHeight);

  _runningYPosition = _runningYPosition + 64.0f;
  _miTopView.frame = CGRectMake(0.0f, 64.0f, MYFullWidth(), miView.headerLabel.frame.size.height + _topMiViewOffset + 10.0f + _bottomMiViewOffset + miView.detailLabel.frame.size.height);
  
  if(_hasInstoreImage){
    [_miTopView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeViewFadeAway:)]];
  }

  [self.view addSubview:_miTopView];
}


-(void)makeViewFadeAway:(id)sender{
  [UIView animateWithDuration:0.5
    animations:^{
      _miTopView.alpha=0.0f;
    }
    completion:^(BOOL finished){
      NSLog(@"Done! with going down");
    }];
}

- (IBAction)expand:(id)sender {
  if([_scrollButton isSelected]) {
    NSLog(@"sender is selected");
  }else{
    NSLog(@"sender is not selected");
  }
  
  CGFloat currentY=self.noteView.frame.origin.y;
  NSLog(@"currentY is: %f", currentY);
  
  if([_scrollButton isSelected]){
    _scrollButton.selected=NO;
    //NSLog(@"these are going to update");
    [UIView animateWithDuration:0.5
                     animations:^{
                       CGRect tmpRect=_tastingNoteV.frame;
                       tmpRect.origin.y=_noteViewY;
                       _tastingNoteV.frame=tmpRect;
                       
                     }
                     completion:^(BOOL finished){
                       NSLog(@"Done! with going down");
                       //[_scrollButton setTitle:@"up" forState:UIControlStateSelected];  "up";
                     }
     ];
  }else{
    _moveUpPosition=300;
    _scrollButton.selected=YES;
    //self.expandButton.selected=NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                       CGRect tmpRect=_tastingNoteV.frame;
                       tmpRect.origin.y=_noteViewYSlideUpValue;
                       _tastingNoteV.frame=tmpRect;
                       _miTopView.alpha=0.0f;
                       
                     }
                     completion:^(BOOL finished){
                       NSLog(@"Done! with going up currentT: %f", currentY);
                     }];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
