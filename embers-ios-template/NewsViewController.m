//
//  NewsViewController.m
//  lucques-ios
//
//  Created by jonathan twaddell on 8/12/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import "NewsViewController.h"
#import "MBProgressHUD.h"
#import "MYUtility.h"


@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)dismissCurrentController:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)web
{
  MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  HUD.labelText = @"loading";
}

- (void)webViewDidFinishLoad:(UIWebView *)web
{
  [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",EMBERSHost(), EMBERSnewsURL()]]]];
  self.myWebView.frame=CGRectMake(0.0f, 60.0f, 320.0f, 600.0f);
  [self.view addSubview:self.myWebView];
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
