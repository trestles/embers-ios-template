//
//  MapViewController.h
//  AOC
//
//  Created by jonathan twaddell on 12/3/14.
//  Copyright (c) 2014 Embers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView* mapView;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* initialLocation;
@property (strong, nonatomic) Location* location;

@end
