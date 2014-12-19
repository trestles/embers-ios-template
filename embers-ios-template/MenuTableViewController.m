//
//  MenuTableViewController.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/18/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuHeader.h"
#import "MenuItem.h"
#import "MenuHeaderCell.h"
#import "MenuItemCell.h"
#import "MenuItem.h"
#import "MenuItemView.h"
#import "MenuHeaderView.h"
#import "MIViewController.h"
#import "MYUtility.h"
#import "CacheController.h"
#import "AFNetworking.h"
#import "MHBottomDecoratorCell.h"
#import "MHBottomDecoratorCell.h"

@interface MenuTableViewController (){
  NSUInteger _menuItemID;
  MenuItem *_menuItem;
}

@end

@implementation MenuTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if(self){
    //self.tableView.backgroundColor=[UIColor blueColor];
    NSLog(@"within initWithCoder in MenuTableViewController");
  }
  return self;
}
- (void)viewWillAppear:(BOOL)animated
{
  [self getTimestamp:self.menu.menuID];
}


- (void)viewDidLoad
{
  
  CGFloat _headerViewStart=0.0f;
  if(self.presentedAsModal){
    //_headerViewStart=350.0f;
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 40.0f, 40.0f)];
    UIImage *buttonImage = [UIImage imageNamed:@"arrow-down-circle"];
    [dismissButton setImage:buttonImage forState:UIControlStateNormal];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCurrentController:)];
    [dismissButton addGestureRecognizer:singleTap];
    [self.view addSubview:dismissButton];
  }
  
  
  //if(MYLog()){
    NSLog(@"calling viewDidLoad");
    NSLog(@"calling viewDidLoad %lu", (long)self.menu.menuID);
    NSLog(@"calling viewDidLoad %lu", (long)self.menu.timestamp);
    NSLog(@"calling viewDidLoad %@", self.menu.listItems);
    // lets get timestamp from site
    [self getTimestamp:self.menu.menuID];

    for(id mi in self.menu.listItems){
      if([mi isKindOfClass:[MenuItem class]]){
        //MenuItem *tmpMi=(MenuItem *)mi;
        //NSLog(@"here is %@", tmpMi.header);
      }
    }
  //}
  
  [super viewDidLoad];

  
  self.menuTV.tableHeaderView = [self showImageTastingNoteHelp];


  self.menuTV.scrollEnabled=YES;
  self.menuTV.delegate=self;
  self.menuTV.dataSource=self;
  self.menuTV.showsVerticalScrollIndicator = YES;
  [self.menuTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
  if(MYLog()){
    NSLog(@"before self.menuTV contentSize.height: %f", self.menuTV.contentSize.height);
    NSLog(@"before self.menuTV frame.size.height: %f", self.menuTV.frame.size.height);
    NSLog(@" self.menuTV contentSize.height: %f", self.menuTV.contentSize.height);
    NSLog(@" self.menuTV frame.size.height: %f", self.menuTV.frame.size.height);
  }
}

-(UIView *)showImageTastingNoteHelp
{
  if(MYLog()){
    NSLog(@"about to show showImageTastingNoteHelp");
  }
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
  if(!self.presentedAsModal){
    CGFloat _rad=8.0f;
    CGFloat _runningHeaderY;
    _runningHeaderY=5.0f;
  
    UILabel *tnHeaderLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    tnHeaderLabel.text=@"click item for info:";
    tnHeaderLabel.font=MYMainSmallerFont();
    [tnHeaderLabel sizeToFit];
    CGFloat _left=18.0f;
    tnHeaderLabel.frame=CGRectMake(_left, _runningHeaderY, tnHeaderLabel.frame.size.width, tnHeaderLabel.frame.size.height);
  
    UIView *instoreImageDot=[self circleWithColor:[UIColor redColor] radius:4];
  
    _left+=tnHeaderLabel.frame.size.width + 10.0f;
    instoreImageDot.frame=CGRectMake(_left, _runningHeaderY + 5.0f, _rad, _rad);
    [headerView addSubview:instoreImageDot];
  
    [tnHeaderLabel sizeToFit];
    [headerView addSubview:tnHeaderLabel];
  
    _left+=9.0f;
    UILabel *imgDotLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    imgDotLabel.text=@" images";
    imgDotLabel.font=MYMainSmallerFont();
    [imgDotLabel sizeToFit];
    imgDotLabel.frame=CGRectMake(_left, _runningHeaderY, imgDotLabel.frame.size.width, imgDotLabel.frame.size.height);
    [headerView addSubview:imgDotLabel];
  
    UIView *tastingNoteDot=[self circleWithColor:[UIColor blackColor] radius:4];
    [headerView addSubview:tastingNoteDot];
    _left+=imgDotLabel.frame.size.width + 5.0f;
    tastingNoteDot.frame=CGRectMake(_left, _runningHeaderY + 5.0f, _rad, _rad);
    [headerView addSubview:tastingNoteDot];
    _left+=tastingNoteDot.frame.size.width + 5.0f;
  
    UILabel *tnDotLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    tnDotLabel.text=@"tasting notes";
    tnDotLabel.font=MYMainSmallerFont();
  
    [tnDotLabel sizeToFit];
    tnDotLabel.frame=CGRectMake(_left, _runningHeaderY, tnDotLabel.frame.size.width, tnDotLabel.frame.size.height);
    [headerView addSubview:tnDotLabel];
  }
  return headerView;
}

-(void)getTimestamp:(NSInteger)menuID
{
  if(self.presentedAsModal){
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/menu_categories/37/sunday-supper",EMBERSHost()]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSDictionary *menuDict=[responseObject objectForKey:@"menu"];

      Menu *menu=[[Menu alloc] initWithAttributes:menuDict];
      self.menu=menu;
      [self.menuTV reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
      [alert show];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
  }else{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/menus/%lu/timestamp",EMBERSHost(), (long)menuID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSString *currentTimestamp=[responseObject objectForKey:@"timestamp"];
      if([currentTimestamp isEqualToString:self.menu.timestamp]){
        NSLog(@"THOSE ARE EQUAL with %@ and %@!!!", currentTimestamp, self.menu.timestamp);
      }else{
        NSLog(@"THOSE ARE DIFFERENT with %@ and %@!!!", currentTimestamp, self.menu.timestamp);
        [self getEachMenu:[NSString stringWithFormat:@"%lu", (long)self.menu.menuID]];
      }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
      [alert show];
    }];
    [[NSOperationQueue mainQueue] addOperation:op];
  }
}

-(void)getEachMenu:(NSString *) menuID
{
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/arc/v1/api/menus/%@/mobile",EMBERSHost(), menuID]];
  NSURLRequest *request = [NSURLRequest requestWithURL:URL];
  AFHTTPRequestOperation *op2 = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  op2.responseSerializer = [AFJSONResponseSerializer serializer];
  [op2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSDictionary *tmpResult=[responseObject objectForKey:@"menu"];
    
    NSString *tmpCacheKey=[NSString stringWithFormat:@"menu/%li",(long)[[tmpResult objectForKey:@"id"] integerValue]];
    [[CacheController sharedInstance] setCache:responseObject forKey:tmpCacheKey];

    Menu *menu=[[Menu alloc] initWithAttributes:tmpResult];

    self.menu=menu;
    [self.menuTV reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Problem accessing internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
  }];
  [[NSOperationQueue mainQueue] addOperation:op2];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if(MYLog()){
    NSLog(@"from within numberOfRowsInSection");
  }
  return [self.menu.listItems count];
}

- (CGFloat)   tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
  if(MYLog()){
    NSLog(@"at top for heightForRowAtIndexIPath");
    NSLog(@"calling heightForRowAtIndexPath for %li", (long)indexPath.row);
  }
  id dic=self.menu.listItems[indexPath.row];
  if([dic isKindOfClass:[MenuHeader class]]){
    MenuHeaderCell *mhCell=(MenuHeaderCell *)cell;
    if(MYLog()){
      NSLog(@"here i am with MenuHeaderCell.nameLabel height:  %f", mhCell.nameLabel.frame.size.height);
      NSLog(@"the mhCell height is %f", mhCell.height);
    }
    return mhCell.height;
  }else if([dic isKindOfClass:[MenuItem class]]){
    MenuItemCell *miCell=(MenuItemCell *)cell;
    return miCell.height;
  }else if([dic isKindOfClass:[NSDictionary class]]){
    MHBottomDecoratorCell *mhbCell=(MHBottomDecoratorCell *)cell;
    return mhbCell.height;
  }
  if(MYLog()){
    NSLog(@"at bottom for heightForRowAtIndexIPath");
  }
  return 20.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if(MYLog()){
    NSLog(@"calling cellForRowAtIndexPath for %lu", (long)indexPath.row);
  }

  static NSString *MenuHeaderCellIdentifier=@"MenuHeaderCell";
  static NSString *MenuItemCellIdentifier=@"MenuItemCell";
  static NSString *MHBottomDecoratorCellIdentifier=@"MHBottomDecoratorCell";

  id dic=self.menu.listItems[indexPath.row];
  if([dic isKindOfClass:[MenuHeader class]]){
    MenuHeaderCell *cell = (MenuHeaderCell *)[self.menuTV dequeueReusableCellWithIdentifier:MenuHeaderCellIdentifier];
    MenuHeader *menuHeader=(MenuHeader *)dic;
    if(MYLog()){
      NSLog(@"calling MenuHeader with %@", menuHeader.name);
    }
    [cell updateCell:menuHeader];
    
    return cell;
  }else if([dic isKindOfClass:[MenuItem class]]){
    MenuItemCell *cell = [self.menuTV dequeueReusableCellWithIdentifier:MenuItemCellIdentifier];
    MenuItem *menuItem=(MenuItem *)dic;
    cell.menuItem=menuItem;
    [cell updateCell:menuItem];
    
    if([menuItem hasInstoreImage] || [menuItem hasTastingNotes]){
      UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMenuItem:)];
      cell.tag =menuItem.menuItemID;
      [cell addGestureRecognizer: tapRecognizer2];
    }else{
      if(MYLog()){
        NSLog(@"YOU HAVE NEITHER INSTORE_IMAGE or TASTING_NOTES %@", menuItem.header);
      }
    }
    NSLog(@"MenuItemCell is a %@", NSStringFromClass([cell class]));
    return cell;
  } else if([dic isKindOfClass:[NSDictionary class]]){
    MHBottomDecoratorCell *cell = [self.menuTV dequeueReusableCellWithIdentifier:MHBottomDecoratorCellIdentifier];
    [cell updateCell:dic];
    return cell;
  }
  return nil;
}

-(UIView *)circleWithColor:(UIColor *)color radius:(int)radius {
  UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * radius, 2 * radius)];
  circle.backgroundColor = color;
  circle.layer.cornerRadius = radius;
  circle.layer.masksToBounds = YES;
  return circle;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITapGestureRecognizer *)sender{
  MIViewController *destinationVC=segue.destinationViewController;
  [destinationVC setMenuItem:_menuItem];
  [destinationVC setMenuItemID:_menuItemID];

}

-(IBAction)pushMenuItem:(UITapGestureRecognizer *)sender{
  MenuItemCell *myCell=(MenuItemCell *)sender.view;
  _menuItemID=myCell.tag;
  _menuItem=myCell.menuItem;
  if(MYLog()){
    //NSLog(@"here is your menuItemID: %i", _menuItemID);
  }
  [self performSegueWithIdentifier:@"pushMISegue" sender:nil];
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  return nil;
}

-(void)dismissCurrentController:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"here you are");
  
}
 */



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
