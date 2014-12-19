//
//  MapViewController.m
//  AOC
//
//  Created by jonathan twaddell on 12/3/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "MapViewController.h"
#import "EMBERSConfig.h"
//#import <QuartzCore/QuartzCore.h>

@interface MapViewController (){
  
  NSMutableArray *_yourAnnotationArray;
  MKPointAnnotation *_locationPoint;
  BOOL _firstTime;
  UIView *_locationView;
  UIButton *_directionsButton;
  UIButton *_launchInGoogleMapsButton;
  BOOL _showingDirections;
  MKRoute *_route;
}
@end

@implementation MapViewController 

- (void) viewWillAppear:(BOOL)animated
{
  _showingDirections=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSLog(@"here is latitude: %f and longitude: %f", self.location.latitude, self.location.longitude);
  
     _firstTime=YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  
  if(IS_OS_8_OR_LATER) {
    //[self.locationManager requestWhenInUseAuthorization];
    //[self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
  }
  [self.locationManager startUpdatingLocation];
  [self.mapView setShowsUserLocation:YES];
  [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
  self.mapView.delegate=self;
  UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 30.0f, 46.0f, 46.0f)];
  [closeButton setBackgroundImage:[UIImage imageNamed:@"close-icon.png"] forState:UIControlStateNormal];
  [self.view addSubview:closeButton];
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(dismissVC:)];

  [closeButton addGestureRecognizer:tapRecognizer];
  
  
  _directionsButton = [[UIButton alloc] initWithFrame:CGRectMake(74.0f, 38.0f, 100.0f, 32.0f)];
  //[_directionsButton setBackgroundImage:[UIImage imageNamed:@"close-icon.png"] forState:UIControlStateNormal];
  [_directionsButton setTitle:@"directions" forState:UIControlStateNormal];
  //[_directionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  //[_directionsButton setBackgroundColor:[UIColor whiteColor]];
  _directionsButton.layer.borderWidth=1.0f;
  _directionsButton.layer.borderColor=[UIColor grayColor].CGColor;
  [self setDirectionsDefault];

  //_directionsButton.layer.cornerRadius = 10;
  //_directionsButton.clipsToBounds = YES;
  [self.view addSubview:_directionsButton];
  UITapGestureRecognizer *tapDirectionsRecognizer = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(showDirections:)];
  [_directionsButton addGestureRecognizer:tapDirectionsRecognizer];

  // launchInGoogleMaps Button
  _launchInGoogleMapsButton = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 100.0f, 100.0f, 30.0f)];
  [_launchInGoogleMapsButton setTitle:@"launch in Google Maps" forState:UIControlStateNormal];
  [_launchInGoogleMapsButton setBackgroundColor:[UIColor blueColor]];
  //[self.view addSubview:_launchInGoogleMapsButton];
  UITapGestureRecognizer *tapGoogleMapsRecognizer = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(launchInGoogleMaps:)];
  [_launchInGoogleMapsButton addGestureRecognizer:tapGoogleMapsRecognizer];

  
  
  // ----------------
  
  _locationView=[[UIView alloc] initWithFrame:CGRectMake(40.0f, 40.0f, 200.0f, 100.0f)];
  [_locationView setBackgroundColor:[UIColor whiteColor]];
  _locationView.layer.borderWidth=1.0f;
  _locationView.layer.borderColor=[UIColor grayColor].CGColor;
  UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 180.0f, 0.0f)];

  locationLabel.numberOfLines=0;
  NSString *nameString=[NSString stringWithFormat:@"%@ \n%@ \n%@",EMBERSlocationName(), EMBERSlocationAddressShort(), EMBERSlocationAddressCity()];
  locationLabel.text=nameString;
  [locationLabel sizeToFit];
  [_locationView addSubview:locationLabel];
  
  NSLog(@"height of locationLabel of this is: %f", locationLabel.frame.size.height);
  
  CGFloat _phoneOffset=locationLabel.frame.size.height + 10.0f;
  
  UITextView *locationTextView=[[UITextView alloc] initWithFrame:CGRectMake(10.0f, _phoneOffset, 180.0f, 0.0f)];
  locationTextView.font=EMBERSMapMiniViewFont();
  locationTextView.text=@"(310) 859-9859";
  locationTextView.editable = NO;
  [locationTextView sizeToFit];
  //locationTextView.backgroundColor=[UIColor greenColor];
  locationTextView.dataDetectorTypes = UIDataDetectorTypeAll;
  [_locationView addSubview:locationTextView];
  NSLog(@"height of locationTextView of this is: %f", locationTextView.frame.size.height);
  [self.mapView addSubview:_locationView];
  
  CGFloat totalHeight=locationTextView.frame.size.height + _phoneOffset;
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  
  NSLog(@"SCREEN HEIGHT is: %f and SCREEN WIDTH is: %f", screenHeight, screenWidth);
  _locationView.frame=CGRectMake(100.0f, (screenHeight - totalHeight - 20.0f) , 200.0f, totalHeight);
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];

  // -----------------
  
  CGFloat latitude=self.location.latitude;
  CGFloat longitude=self.location.longitude;

  _locationPoint = [[MKPointAnnotation alloc] init];
  _locationPoint.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
  _locationPoint.title = self.location.name;
  _locationPoint.subtitle = self.location.street;
  [self.mapView addAnnotation:_locationPoint];

  //[self setMapAOCCenter];

  //[self setMapStart];

}

-(void)dismissVC:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)launchInGoogleMaps:(id)sender
{
  NSLog(@"launching in Google Maps");
  if ([[UIApplication sharedApplication] canOpenURL:
       [NSURL URLWithString:@"comgooglemaps://"]]) {
//    NSString *googleString=[NSString stringWithFormat:@"comgooglemaps://?center=%f,%fzoom=14&views=traffic", MYLocationLatitude(), MYLocationLongitude()];
    NSString *googleString=[NSString stringWithFormat:@"comgooglemaps://?center=%f,%fzoom=14&views=traffic", self.location.latitude, self.location.longitude];

    // NSString *googleString=[NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%fzoom=14&directionsmode=driving",  MYLocationLatitude(), MYLocationLongitude()];

    [[UIApplication sharedApplication] openURL:
     
     [NSURL URLWithString:googleString]];
  } else {
    NSLog(@"Can't use comgooglemaps://");
  }
}


-(void)setDirectionsDefault
{
  [_directionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_directionsButton setBackgroundColor:[UIColor whiteColor]];
}

-(void)setDirectionsSelected
{
  [_directionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_directionsButton setBackgroundColor:[UIColor blackColor]];
}


-(void)showDirections:(id)sender
{
  if(_showingDirections==NO){
  NSLog(@"sending directions here");
  CGFloat latitude=self.location.latitude;
  CGFloat longitude=self.location.longitude;
  
  MKPlacemark *destinationPlacemark=[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
  MKMapItem *destinationMapItem=[[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
  
  MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
  [request setSource:[MKMapItem mapItemForCurrentLocation]];
  [request setDestination:destinationMapItem];
  [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
  [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
  MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
  [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
    if (!error) {
      //for (MKRoute *_route in [response routes]) {
      for (_route in [response routes]) {
        [self.mapView addOverlay:[_route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
        // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
      }
    }
  }];
    _showingDirections=YES;
    [self setDirectionsSelected];
  }else{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self setDirectionsDefault];
    _showingDirections=NO;
  }
  
}



-(void)setMapAOCCenter
{
  NSLog(@"set AOC at center");
}

// to allow overlays!!!

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
  if ([overlay isKindOfClass:[MKPolyline class]]) {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    [renderer setStrokeColor:[UIColor blueColor]];
    [renderer setLineWidth:5.0];
    return renderer;
  }
  return nil;
}

/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  //[self setMapStart];
  NSLog(@"USER LOCATION %@", userLocation);

}
*/
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  if (!self.initialLocation)
  {
    self.initialLocation = userLocation.location;
    /*
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.1, 0.1);
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
     */
    // NSLog(@"DIDUPDATEUSERLOCATION: in didUpdateUserLocation: %@", userLocation.location);
    MKPointAnnotation *ann=[[MKPointAnnotation alloc] init];
    ann.coordinate=CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    NSArray *myAnnotationArray=[[NSArray alloc]initWithObjects:_locationPoint,ann, nil];
    [self.mapView showAnnotations:myAnnotationArray animated:YES];  // <- determine when this has run
    [self.mapView removeAnnotation:ann];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  //if(_firstTime){
  NSLog(@"here is my thinking %@", [locations lastObject]);
  [self setMapStart];
}

-(void)setMapStart
{
//if(_firstTime){
  /*
  NSLog(@"at top of _firstTime being true");
  MKPointAnnotation *myPoint = [[MKPointAnnotation alloc] init];
  myPoint.coordinate = CLLocationCoordinate2DMake(34.035645, -118.233434);
  MKMapPoint annotationPoint = MKMapPointForCoordinate(self.mapView.userLocation.coordinate);
  //[_yourAnnotationArray addObject:annotationPoint];
  //_yourAnnotationArray=[[NSMutableArray alloc] initWithObjects:_locationPoint,annotationPoint, nil];
  //NSLog(@"here is my count: %i",(unsigned long)[_yourAnnotationArray count]);
  [self.mapView showAnnotations:self.mapView.annotations animated:YES];  // <- determine when this has run
  _firstTime=NO;
   */
//}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated{
  NSLog(@"THIS CHANGED");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
