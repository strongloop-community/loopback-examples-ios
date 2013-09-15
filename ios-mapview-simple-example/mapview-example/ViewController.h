//
//  ViewController.h
//  mapview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <LoopBack/LoopBack.h>

#import "MapAnnotation.h"
#import "HQAnnotation.h"


@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@end
