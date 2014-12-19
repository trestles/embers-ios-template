//
//  MenuListViewController.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/10/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MenuListViewController.h"
#import "MenuTableViewController.h"
#import "MenuListItemView.h"
#import "Menu.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MYUtility.h"
#import "CacheController.h"
#import "MYUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface MenuListViewController (){
  NSUInteger _menuID;
  //CGFloat _xRunningValue;
  CGFloat _yRunningValue;

  //CGFloat _y;
  CGFloat _x;
  UIScrollView *_mainScrollView;
}

@end

@implementation MenuListViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

-(id)initWithCoder:(NSCoder *)aDecoder{
  if(self = [super initWithCoder:aDecoder]) {
    // Do something
    self.menus=[[NSMutableArray alloc] init];
  }
  return self;
  
}

-(void)showNewEventViewController:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _mainScrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
  _mainScrollView.delegate=self;
  _mainScrollView.scrollEnabled=YES;
  _yRunningValue=0.0f;
  _x=0.0f;
  
  UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow-down-circle"] style:UIBarButtonItemStyleBordered target:self action:@selector(showNewEventViewController:)];
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  self.navigationItem.leftBarButtonItem = leftBarButtonItem;

  if(self.menus){
    NSLog(@"here :%@", self.menus);
    for(Menu *m in self.menus){
      [self renderMenuItem:m];
    }
    _mainScrollView.contentSize = CGSizeMake(320.0f,_yRunningValue  + 150.0f);
    _mainScrollView.frame=CGRectMake(0.0f, 0.0f, 320.0, _yRunningValue + 150.0f);
    NSLog(@"here is _yRunningValue %f", _yRunningValue);
    [self.view addSubview:_mainScrollView];
  }else{

  
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/locations/%@/mobile_home",EMBERSHost(),MYLocationID()]];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op.responseSerializer = [AFJSONResponseSerializer serializer];
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      NSDictionary *result=[responseObject objectForKey:@"data"];

    _menus=[result objectForKey:@"mobile_menus"];
      for(Menu *m in _menus){
        [self renderMenuItem:m];
        _mainScrollView.frame=CGRectMake(0.0f, 64.0f, 320.0, _yRunningValue + 150.0f);
        [self.view addSubview:_mainScrollView];
      }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"Error: %@", error);
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
  }
}

-(void)viewWillAppear:(BOOL)animated
{
  
  
}

-(void)renderMenuItem:menu{
  CGFloat _miLVHeight;
  _miLVHeight=124.0f;
  MenuListItemView *menuView=[[MenuListItemView alloc] initWithFrame:CGRectMake(_x, _yRunningValue, 320.0f, _miLVHeight)];
  _yRunningValue = _yRunningValue + _miLVHeight;
  UIImageView *smlShader =[[UIImageView alloc] init];
  
  NSString *mobileBackgroundImage=[menu objectForKey:@"mobile_background"];
  if([[menu objectForKey:@"mobile_background"] isEqual:[NSNull null]]){
    NSLog(@"there is NOT a mobile background image");
    smlShader.image = [UIImage imageNamed:@"my.jpg"];
  }else{
    NSLog(@"there is a mobile background image %@", mobileBackgroundImage);
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EMBERSImageHost(), mobileBackgroundImage]];

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
         // do something with image
         smlShader.image=image;

       }else{
         NSLog(@"THIS FAILED");
       }
     }];
  }
  
  smlShader.frame = CGRectMake(0,0,320,_miLVHeight); //Change the value of the frame
  [menuView addSubview:smlShader];

  menuView.nameLabel.text=[menu objectForKey:@"name"];
  menuView.nameLabel.textAlignment = NSTextAlignmentCenter; // <- should probably be in the MenuListItemView
  menuView.nameLabel.textColor = [UIColor whiteColor];
  //menuView.nameLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:(48.0)];
  
  menuView.nameLabel.font=MYMenuListFont();
  /*
  menuView.nameLabel.layer.borderColor=[UIColor blueColor].CGColor;
  menuView.nameLabel.layer.borderWidth=2.0f;
   */
  [menuView.nameLabel setNumberOfLines:0];
  [menuView.nameLabel sizeToFit];
  

  
  [menuView bringSubviewToFront:menuView.nameLabel];
  //[menuView.nameLabel sizeToFit];
  if(MYLog()){
    NSLog(@"width: %f and height: %f", menuView.nameLabel.frame.size.width,menuView.nameLabel.frame.size.height);
  }
  CGFloat _leftX=(320.0f - menuView.nameLabel.frame.size.width)/2;
  
  CGFloat topOffset=(124 - menuView.nameLabel.frame.size.height)/2;
  
  
  menuView.nameLabel.frame=CGRectMake(_leftX, /* 25.0f */ topOffset, menuView.nameLabel.frame.size.width, menuView.nameLabel.frame.size.height);

  menuView.tag=[[menu objectForKey:@"id"] integerValue];
  
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.frame = CGRectMake(0.0f, (menuView.frame.size.height - 1.0f), menuView.frame.size.width, 1.0f);
  bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                   alpha:1.0f].CGColor;
  [menuView.layer addSublayer:bottomBorder];
  
  // Create and initialize a tap gesture
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(pushMenu:)];
  
  // Specify that the gesture must be a single tap
  tapRecognizer.numberOfTapsRequired = 1;
  [menuView addGestureRecognizer:tapRecognizer];
  [_mainScrollView addSubview:menuView];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITapGestureRecognizer *)sender{
  if(MYLog()){
    NSLog(@"prepareForSegue was called at the top");
  }
  MenuTableViewController *destinationVC=segue.destinationViewController;
  [destinationVC setMenuID:_menuID];
  NSDictionary *myDict = [[CacheController sharedInstance] getCacheForKey:[NSString stringWithFormat:@"menu/%lu", (unsigned long)_menuID]];
  if(myDict!=nil){
  }else{
    NSLog(@"myDict is nil");
  }
  NSDictionary *rTmpMenu=[myDict objectForKey:@"menu"];
  Menu *menu=[[Menu alloc] initWithAttributes:rTmpMenu];
  [destinationVC setMenu:menu];
  if(MYLog()){
    //NSLog(@"prepareForSegue was called after setting menuID with %i", tmpMenu.menuID);
    NSLog(@"prepareForSegue was called after setting menuID with %lu", (unsigned long)_menuID);
  }


  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:nil];

}



-(IBAction)pushMenu:(UITapGestureRecognizer *)sender{
  NSLog(@"content.offset: %f", _mainScrollView.contentOffset.y);
  if(MYLog()){
    NSLog(@"%@", sender);
  }
  _menuID=sender.view.tag;
  [self performSegueWithIdentifier:@"pushMenuTableSegue" sender:sender];
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
