//
//  ViewController.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/10/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "ViewController.h"
//#import "BouncePresentAnimationController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MenuListViewController.h"
#import "EMBERSConfig.h"
#import "ButtonView.h"
#import "CacheController.h"
#import "MenuTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDictionary+Additions.h"
#import "Location.h"
#import "MapViewController.h"

@interface ViewController (){
  //BouncePresentAnimationController *_bounceAnimationController;
  NSMutableArray *_menus;
  NSUInteger _menuID;
  CGFloat _runningY;
  CGFloat _runningYButton;
  CGFloat _menuLeftOffset;
  CGFloat _bottomOfScreen;
  UIView *_buttonsView;
  UIView *_helpView;
  UIImageView *_backgroundView;
  NSMutableDictionary *_cacheTimestamps;
  Location *_location;
}

@end

@implementation ViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
      //  _bounceAnimationController = [BouncePresentAnimationController new];
        _menus=[[NSMutableArray alloc] init];

    }
    return self;
}

-(NSUInteger)supportedInterfaceOrientations
{
  return  UIInterfaceOrientationMaskPortrait;
}

- (void)defaults
{
  _menuLeftOffset=10;
  if(IS_IPHONE_5){
    _runningY = 380.0f;
    _bottomOfScreen=568.0f;
  }else{
    _runningY = 280.0f;
    _bottomOfScreen=480.0f;
  }
}

-(void)processMenuItemBackgroundImage:(NSString *)mobileMenuItemDetail
{
  NSLog(@"here i am");
  if([mobileMenuItemDetail isEqual:[NSNull null]]){
    NSLog(@"no mobileMenuItemDetail");
  }else{
    //NSLog(@"ah yes mobileMenuItemDetail: %@",mobileMenuItemDetail);
    NSDictionary *myInfo=@{@"url":mobileMenuItemDetail};
    [[CacheController sharedInstance] setCache:myInfo forKey:@"mobileMenuItemDetailBackground"];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", EMBERSImageHost(),  mobileMenuItemDetail]];
    [manager downloadWithURL:imageURL
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
       // progression tracking code
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
       if (image)
       {
       }
     }];
  }
}

-(void)processMobileBackgroundImage:(NSString *)mobileBackgroundImage
{
  if([mobileBackgroundImage isEqual:[NSNull null]]){
    _backgroundView.image=[UIImage imageNamed:@"main-bg"];
  }else{
    NSLog(@"about to get image");
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", EMBERSImageHost(), mobileBackgroundImage]];
    [manager downloadWithURL:imageURL
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
       // progression tracking code
       //NSLog(@"this downloaded");
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
       if (image)
       {
         _backgroundView.image=image;
         _backgroundView.frame=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
         [UIView animateWithDuration:1.0
                               delay:0.0
                             options:UIViewAnimationOptionTransitionCrossDissolve
                          animations:^{
                            //yourAnimation
                            _backgroundView.alpha=100.0f;
                            self.helpButton.alpha=60.0f;
                          } completion:^(BOOL finished){
                            NSLog(@"Animation is finished");
                          }];
       }
     }];
  }
}

-(void)processMobileMenus:(NSArray *)menus
{
  for(NSDictionary *m in menus){
    NSMutableDictionary *objMenu=[[NSMutableDictionary alloc] init];
    [objMenu setObject:[m objectForKey:@"id"] forKey:@"id"];
    [objMenu setObject:[m objectForKey:@"name"] forKey:@"name"];
    [objMenu setObject:[m objectForKey:@"mobile_background"] forKey:@"mobile_background"];
    
    
    if([[objMenu objectForKey:@"mobile_background"] isEqual:[NSNull null]]){
      NSLog(@"there is NOT a mobile background image");
      //smlShader.image = [UIImage imageNamed:@"my.jpg"];
    }else{
      //NSLog(@"there is a mobile background image %@", mobileBackgroundImage);
      //smlShader.image = [UIImage imageNamed:@"my.jpg"];
      NSURL *imageURL=[[NSURL alloc] initWithString:[objMenu objectForKey:@"mobile_background"]];
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [manager downloadWithURL:imageURL
                       options:0
                      progress:^(NSInteger receivedSize, NSInteger expectedSize)
       {
         // progression tracking code
         //NSLog(@"this downloaded");
       }
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
       {
         if (image)
         {
           NSLog(@"this image exits %@", image);
           // do something with image
         }
       }];
    }
    [_menus addObject:objMenu];
    [self getEachMenu:[m objectForKey:@"id"]];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self defaults];
  [self.view setBackgroundColor:[UIColor blackColor]];
  _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main-bg-clear"]];
  _backgroundView.frame=CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height);
  _backgroundView.alpha=0.0f;
  [self.view addSubview:_backgroundView];
  self.helpButton.alpha=0.0f;
  
  [self.view bringSubviewToFront:self.helpButton];

  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/locations/%@/mobile_home",EMBERSHost(),EMBERSLocationID()]];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
    NSString *tmpCacheKey= [NSString stringWithFormat:@"locations/%@/mobile_home",EMBERSLocationID()];
    [[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
    NSData *cachedObject = [[CacheController sharedInstance] getCacheForKey:tmpCacheKey];
    if (cachedObject != nil) {
      //NSLog(@"GOT FROM CACHE with %@", cachedObject);
    }else{
      //NSLog(@"NOTHING IN CACHE");
      //[[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
    }
    NSDictionary *result=[responseObject objectForKey:@"data"];
    
    _location=[[Location alloc]initWithAttributes:result];
    
    NSLog(@"HERE is the _location name: %@", _location.name);
    NSLog(@"HERE is the _location latitude: %f", _location.latitude);
    NSLog(@"HERE is the _location longitude: %f", _location.longitude);
    
    
    [[CacheController sharedInstance] setCache:responseObject forKey:@"menuItemDetailBackground"];
    _buttonsView=[[UIView alloc] initWithFrame:CGRectMake(20.0f, _runningY, 280.0f, 200.0f)];
    _buttonsView.alpha=0.2f;
    [self.view addSubview:_buttonsView];
    [self showButtonsViewInSeconds];
    [self renderMenuButton];
    
    NSLog(@"here is this value: :%@",[result objectForKey:@"show_news"]);
    if([result objectForKey:@"show_news"]){
      [self renderNewsButton];
    }
    [self renderMapButton];

    // lets put this in a function
    NSString *mobileMenuItemDetail=[result objectForKey:@"mobile_menu_item_detail_background"];

    [self processMenuItemBackgroundImage:mobileMenuItemDetail];
    NSString *mobileBackgroundImage=[result objectForKey:@"mobile_background_image"];
    [self processMobileBackgroundImage:mobileBackgroundImage];
    
    _cacheTimestamps=[[NSMutableDictionary alloc] init];
    NSArray *tmpMenus=[result objectForKey:@"mobile_menus"];
    [self processMobileMenus:tmpMenus];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
  }];
  [[NSOperationQueue mainQueue] addOperation:op];
}

- (IBAction)showHelpOverlay:(id)sender {
  NSLog(@"about to show help overlay");
  _helpView=[[UIView alloc] initWithFrame:CGRectMake(25.0f, _bottomOfScreen, 270.0f, 368.0f)];
  UIImageView *helpIV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"help-bg"]];
  [_helpView addSubview:helpIV];
  UILabel *copyLabel=[[UILabel alloc] initWithFrame:CGRectMake(15.0f, 35.0f, 250.0f, 100.0f)];
  copyLabel.text=@"When you see either a red or black dot on a menu, we provide pictures or tasting notes respectively.";
  copyLabel.numberOfLines=0;
  [_helpView addSubview:copyLabel];

  UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 40.0f, 40.0f)];
  UIImage *buttonImage = [UIImage imageNamed:@"close-icon"];
  [dismissButton setImage:buttonImage forState:UIControlStateNormal];
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHelpView:)];
  [dismissButton addGestureRecognizer:singleTap];
  [_helpView addSubview:dismissButton];
  [self.view bringSubviewToFront:dismissButton];

  UILabel *tastingNotesLabel=[[UILabel alloc] initWithFrame:CGRectMake(-100.0f, 250.0f, 70.0f, 50.0f)];
  tastingNotesLabel.textAlignment=NSTextAlignmentRight;
  tastingNotesLabel.text=@"tasting notes";
  tastingNotesLabel.numberOfLines=0;
  [_helpView addSubview:tastingNotesLabel];
  [tastingNotesLabel.superview setClipsToBounds:YES];

  UILabel *pixLabel=[[UILabel alloc] initWithFrame:CGRectMake(-100.0f, 170.0f, 100.0f, 20.0f)];
  pixLabel.text=@"pictures";
  [_helpView addSubview:pixLabel];
  [UIView animateWithDuration:0.5f
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^(void) {
                     pixLabel.frame=CGRectMake(30.0f, 170.0f, pixLabel.frame.size.width, pixLabel.frame.size.height);
                     tastingNotesLabel.frame=CGRectMake(30.0f, 250.0f, tastingNotesLabel.frame.size.width, tastingNotesLabel.frame.size.height);
                   }
                   completion:^(BOOL finished){}];

  [self.view addSubview:_helpView];
  [UIView animateWithDuration:0.25
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^(void) {
                     _helpView.frame=CGRectMake(25.0f, 100.0f, 270.0f, 368.0f);
                     self.helpButton.alpha=0.0f;;

                   }
                   completion:^(BOOL finished){}];
}

-(void)dismissHelpView:(id)sender
{
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^(void) {
                     self.helpButton.alpha=1.0f;;
                   }
                   completion:^(BOOL finished){}];

  
  
  [self dismissViewControllerAnimated:YES completion:nil];
  [_helpView removeFromSuperview];
}


-(void)showButtonsViewInSeconds
{
  [UIView animateWithDuration:0.5
                        delay:0.25
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     _buttonsView.alpha=1.0;
                   }
                   completion:^(BOOL finished){
                     NSLog(@"Done!");
                   }];
}


/*
-(void)renderSundaySupperButton:(NSDictionary *)result
{
  NSLog(@"here is renderSundaySupperButton");
  NSDictionary *currentMec=[result objectForKey:@"current_mec"];
  NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:@"sunday supper", @"name", [currentMec objectForKey:@"id"], @"id", nil];
  [self getEachMenu:[currentMec objectForKey:@"id"]];
  [self getImages:[currentMec objectForKey:@"id"]];
  ButtonView *menuV=[self renderButton:tmp];
  //menuV.frame=CGRectMake(10.0f, 10.0f, 300.0f, menuV.frame.size.height);
  menuV.frame=CGRectMake(_menuLeftOffset, _runningYButton, 260.0f, 43.0f);
  menuV.layer.borderColor=[UIColor whiteColor].CGColor;
  menuV.layer.borderWidth=1.0f;
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(pushMenu:)];
  tapRecognizer.numberOfTapsRequired = 1;
  [menuV addGestureRecognizer:tapRecognizer];
  [self.view addSubview:menuV];
  [_buttonsView addSubview:menuV];
  
}
*/ 


-(void)renderMenuButton
{
  _runningYButton=10.0f;
  NSDictionary *menus = [[NSDictionary alloc] initWithObjectsAndKeys:@"menus", @"name", @"some", @"id", nil];
  UIView *menusV=[self renderButton:menus];
  menusV.frame=CGRectMake(_menuLeftOffset, _runningYButton, 260.0f, 43.0f);

  menusV.layer.borderColor=[UIColor whiteColor].CGColor;
  menusV.layer.borderWidth=1.0f;
  UITapGestureRecognizer *tapRecognizerModal = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(modalMenuList:)];
  tapRecognizerModal.numberOfTapsRequired = 1;
  [menusV addGestureRecognizer:tapRecognizerModal];
  [_buttonsView addSubview:menusV];
  _runningYButton +=  + menusV.frame.size.height + 7.0f;
}

-(void)renderNewsButton
{
  NSDictionary *news = [[NSDictionary alloc] initWithObjectsAndKeys:@"info - news", @"name", @"some", @"id", nil];
  UIView *newsV=[self renderButton:news];
  
  newsV.frame=CGRectMake(_menuLeftOffset, _runningYButton, 260.0f, 43.0f);
  if((newsV.frame.size.height + 10.0f) < 85){
    NSLog(@"that is less %f", newsV.frame.size.height);
  }
  _runningYButton +=  + newsV.frame.size.height + 7.0f;
  
  newsV.layer.borderColor=[UIColor whiteColor].CGColor;
  newsV.layer.borderWidth=1.0f;
  UITapGestureRecognizer *tapRecognizerNews = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(modalNews:)];
  tapRecognizerNews.numberOfTapsRequired = 1;
  [newsV addGestureRecognizer:tapRecognizerNews];
  [_buttonsView addSubview:newsV];
}

-(void)renderMapButton
{
  NSDictionary *map = [[NSDictionary alloc] initWithObjectsAndKeys:@"map", @"name", @"some", @"id", nil];
  UIView *mapV=[self renderButton:map];
  
  mapV.frame=CGRectMake(_menuLeftOffset, _runningYButton, 260.0f, 43.0f);
  if((mapV.frame.size.height + 10.0f) < 85){
    //NSLog(@"that is less %f", newsV.frame.size.height);
  }
  _runningYButton +=  + mapV.frame.size.height + 7.0f;
  
  mapV.layer.borderColor=[UIColor whiteColor].CGColor;
  mapV.layer.borderWidth=1.0f;
  UITapGestureRecognizer *tapRecognizerNews = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(modalMap:)];
  tapRecognizerNews.numberOfTapsRequired = 1;
  [mapV addGestureRecognizer:tapRecognizerNews];
  [_buttonsView addSubview:mapV];
}

-(void)getImages:(NSString *) menuID
{
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/menus/%@/images",EMBERSHost(), menuID]];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSDictionary *tmpResult=[responseObject objectForKey:@"data"];
    NSLog(@"here are images %@", tmpResult);
    for(NSDictionary *mi in tmpResult){
      NSURL *imageURL=[[NSURL alloc] initWithString:[mi objectForKey:@"instore_image_url"]];
      SDWebImageManager *manager = [SDWebImageManager sharedManager];
      [manager downloadWithURL:imageURL
                       options:0
                      progress:^(NSInteger receivedSize, NSInteger expectedSize)
       {
         // progression tracking code
       }
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
       {
         if (image)
         {
            // image downloaded - just writing to cache
         }
       }];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
  }];
  [[NSOperationQueue mainQueue] addOperation:op];
}

-(void)getMenuItemImages:(NSArray *) menuItemImages
{
  for(NSDictionary *mii in menuItemImages){
    NSLog(@"here i am %@",[mii objectForKey:@"instore_image_url"]);
    NSURL *imageURL=[[NSURL alloc] initWithString:[mii objectForKey:@"instore_image_url"]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:imageURL
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
       // manage download
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
       if (image)
       {
         // this image is in our cache!!!
       }
     }];
  }
}


-(void)getEachMenu:(NSString *) menuID
{
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/menus/%@/mobile",EMBERSHost(), menuID]];
  //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op2 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op2.responseSerializer = [AFJSONResponseSerializer serializer];
  [op2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSDictionary *tmpResult=[responseObject objectForKey:@"menu"];
    [self getMenuItemImages:[tmpResult objectForKey:@"menu_item_images"]];
    
    NSString *tmpCacheKey=[NSString stringWithFormat:@"menu/%li",(long)[[tmpResult objectForKey:@"id"] integerValue]];
    NSData *cachedObject = [[CacheController sharedInstance] getCacheForKey:tmpCacheKey];
    
    if (cachedObject != nil) {
      NSLog(@"got from cache with %@", cachedObject);
    }else{
      NSLog(@"nothing in cache");
      [[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];
      NSLog(@"here are the keys: %@",[[[CacheController sharedInstance] cache] allKeys]);
      NSLog(@"write to cache with %@",tmpCacheKey);

      //NSLog(@"HERE IS TMPRESULT %@",tmpResult);
      NSString *cacheKeyTimestamp=[NSString stringWithFormat:@"menu/%li/timestamp",(long)[[tmpResult objectForKey:@"id"] integerValue]];
      
      //NSData *cachedObject = [[CacheController sharedInstance] getCacheForKey:cacheKeyTimestamp];
      //[[CacheController sharedInstance] setCache:[responseObject objectForKey:@"timestamp"] forKey:cacheKeyTimestamp];
      NSLog(@"here is cacheKeyTimestamp: %@", cacheKeyTimestamp);
      if([tmpResult objectForKey:@"timestamp"]){
      NSLog(@"here is the value: %@", @{@"timestamp":[tmpResult objectForKey:@"timestamp"]});
      }else{
        NSLog(@"nothing there");
      }
      //[[CacheController sharedInstance] setCache:@{@"timestamp":[tmpResult objectForKey:@"timestamp"]} forKey:cacheKeyTimestamp];
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
  }];
  [[NSOperationQueue mainQueue] addOperation:op2];
}


-(ButtonView *)renderButton:(NSDictionary *)item
{
  UILabel *mecButton = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f,180.0f, 0.0f)];
  mecButton.textAlignment=NSTextAlignmentCenter;
  mecButton.numberOfLines=0;
  mecButton.text=[[item objectForKey:@"name"] uppercaseString];
  mecButton.font=MYMainSlightlyLargerFont();
  mecButton.textColor=[UIColor whiteColor];
  //mecButton.font =[UIFont fontWithName:@"Courier-Bold" size:18.0];
  mecButton.font=MYSplashMenuFont();
  [mecButton sizeToFit];
  mecButton.frame=CGRectMake(((260.0f - mecButton.frame.size.width)/2), 11.0f, mecButton.frame.size.width, mecButton.frame.size.height);
  UIImageView *arrowUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow-up"]];
  arrowUp.frame=CGRectMake(220.0f, 18.0f, arrowUp.frame.size.width, arrowUp.frame.size.height);
  
  ButtonView *menuV=[[ButtonView alloc] initWithFrame:CGRectZero];
  menuV.labelHeight=mecButton.frame.size.height;
  menuV.tag=[[item objectForKey:@"id"] integerValue];

  [menuV addSubview:mecButton];
  [menuV addSubview:arrowUp];
  return menuV;
}

-(IBAction)modalMenuList:(id)sender{
  [self performSegueWithIdentifier:@"modalMenuList" sender:nil];
}

-(IBAction)modalNews:(UITapGestureRecognizer *)sender{
  //_menuID=sender.view.tag;
  [self performSegueWithIdentifier:@"modalNewsSegue" sender:sender];
}

-(void)modalMap:(UITapGestureRecognizer *)sender{
  //_menuID=sender.view.tag;
  [self performSegueWithIdentifier:@"modalMapSegue" sender:sender];
}



-(IBAction)pushMenu:(UITapGestureRecognizer *)sender{
  _menuID=sender.view.tag;
  [self performSegueWithIdentifier:@"modalMenuSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITapGestureRecognizer *)sender{
  if([segue.identifier isEqual:@"modalMenuSegue"]){
    
    MenuTableViewController *destinationVC=segue.destinationViewController;
    NSDictionary *myDict = [[CacheController sharedInstance] getCacheForKey:[NSString stringWithFormat:@"menu/%lu", (unsigned long)_menuID]];
    if(myDict!=nil){
    }else{
      NSLog(@"myDict is nil");
    }
    NSDictionary *rTmpMenu=[myDict objectForKey:@"menu"];
    Menu *menu=[[Menu alloc] initWithAttributes:rTmpMenu];
    
    destinationVC.menu=menu;
    destinationVC.menuID=_menuID;

    if(MYLog()){
      NSLog(@"prepareForSegue was called after setting menuID with %li", (long)menu.menuID);
      NSLog(@"prepareForSegue was called after setting menuID with %lu", (unsigned long)_menuID);
    }
    destinationVC.presentedAsModal=YES;
  }else if ([segue.identifier isEqualToString:@"modalMenuList"]){
    
    UINavigationController *navigationController = segue.destinationViewController;
    MenuListViewController *menuListTVC = (MenuListViewController * )navigationController.topViewController;
    menuListTVC.menus = _menus;
  }else if ([segue.identifier isEqualToString:@"modalMapSegue"]){
    MapViewController *destinationVC=segue.destinationViewController;
    destinationVC.location=_location;
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
