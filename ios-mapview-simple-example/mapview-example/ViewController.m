//
//  ViewController.m
//  mapview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

#define prototypeName @"ships"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@property (nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *mapAnnotations;


//StrongLoop HQ
@property (nonatomic, strong) HQAnnotation *hqAnnotation;
//San Francisco City
@property (nonatomic, strong) MapAnnotation *sfAnnotation;

@end

@implementation ViewController


/*
 [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/location/nearby" verb:@"GET"] forMethod:@"locations.getNearestFew"];
 [LocationProto invokeStaticMethod:@"getNearestFew" parameters:@{
 @"here": @{
 @"lat": 37.587409,
 @"lng": -122.338225
 }
 } success:staticMethodSuccessBlock failure:staticMethodErrorBlock];
 */

- (NSArray *) mapAnnotations
{
    if ( !_mapAnnotations) _mapAnnotations = [[NSMutableArray alloc] init];
    return _mapAnnotations;
};

- (HQAnnotation *) hqAnnotation
{
    if ( !_hqAnnotation) _hqAnnotation = [[HQAnnotation alloc] init];
    return _hqAnnotation;
};

- (MapAnnotation *) sfAnnotation
{
    if ( !_sfAnnotation)
    {
        CLLocationCoordinate2D cityCoord;
        cityCoord.latitude = 37.786996;
        cityCoord.longitude = -122.419281;
        _sfAnnotation = [[MapAnnotation alloc] initWithLocation:cityCoord];
        _sfAnnotation.title = @"SF";
        _sfAnnotation.subtitle = @"city";
    }//end if
    return _sfAnnotation;
};


- ( void ) getAll
{
    // ++++++++++++++++++++++++++++++++++++
    //
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        
        NSLog( @"Success %d", [models count]);
        [self.mapAnnotations removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            LBModel *geoInstance  = [modelInstance objectForKeyedSubscript:@"geo"];
            
            CLLocationCoordinate2D locCord;
            locCord.latitude = [[geoInstance objectForKeyedSubscript:@"lat"] doubleValue];
            locCord.longitude = [[geoInstance objectForKeyedSubscript:@"lng"] doubleValue];
            
            MapAnnotation *annot = [[MapAnnotation alloc] initWithLocation:locCord];
            annot.title = [modelInstance objectForKeyedSubscript:@"name"];
            annot.subtitle = [modelInstance objectForKeyedSubscript:@"SHIPTYPE"];
            
            [self.mapAnnotations addObject:annot ];
            
        }//end for
        
        [self.mapAnnotations addObject: [self sfAnnotation]];
        [self.mapAnnotations addObject: [self hqAnnotation]];
        
        [self.myMapView removeAnnotations:self.myMapView.annotations];  // remove any annotations that exist
        [self.myMapView addAnnotations:self.mapAnnotations]; //add the new Annotation list
        
        [self gotoLocation];
        
    };//end selfSuccessBlock
    
    //Get a local representation of the 'ships' model type
    LBModelPrototype *objectB = [ [AppDelegate adapter] prototypeWithName:prototypeName];
    
    // Invoke the allWithSuccess message for the 'ships' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/ships
    
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
}


- ( void ) getNearestHQ
{
    // ++++++++++++++++++++++++++++++++++++
    
    // Get Nearest Ship
    // http://localhost:3000/ships?filter%5Blimit%5D=1
    // curl http://localhost:3000/location/nearby?here%5Blat%5D=37.587409&here%5Blng%5D=-122.338225
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        
        NSLog( @"Success %d", [models count]);
        
        [self.mapAnnotations removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            LBModel *geoInstance  = [modelInstance objectForKeyedSubscript:@"geo"];
            
            CLLocationCoordinate2D locCord;
            locCord.latitude = [[geoInstance objectForKeyedSubscript:@"lat"] doubleValue];
            locCord.longitude = [[geoInstance objectForKeyedSubscript:@"lng"] doubleValue];
            
            MapAnnotation *annot = [[MapAnnotation alloc] initWithLocation:locCord];
            annot.title = [modelInstance objectForKeyedSubscript:@"name"];
            annot.subtitle = [modelInstance objectForKeyedSubscript:@"SHIPTYPE"];
            
            [self.mapAnnotations addObject:annot ];
            
        }//end for
        
        [self.mapAnnotations addObject: [self sfAnnotation]];
        [self.mapAnnotations addObject: [self hqAnnotation]];
        
        [self.myMapView removeAnnotations:self.myMapView.annotations];  // remove any annotations that exist
        [self.myMapView addAnnotations:self.mapAnnotations]; //add the new Annotation list
        
        [self gotoLocation];
        
    };//end selfSuccessBlock
    
    //Get a local representation of the 'ships' model type
    LBModelPrototype *objectProto = [ [AppDelegate adapter] prototypeWithName:prototypeName];
    
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/ships" verb:@"GET"] forMethod:@"ships.filter"];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/ships/nearby" verb:@"GET"] forMethod:@"ships.nearby"];
    
    // http://localhost:3000/ships/nearby?here%5Blat%5D=37.587409&here%5Blng%5D=-122.338225
    
    NSString *latitude = [[NSString alloc] initWithFormat:@"%g°", self.hqAnnotation.coordinate.latitude];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%g°", self.hqAnnotation.coordinate.longitude];
    
    //get Nearest with ships.nearby
    //[objectProto invokeStaticMethod:@"nearby" parameters:@{ @"here[lat]":latitude, @"here[lng]":longitude} success:loadSuccessBlock failure:loadErrorBlock];
    //get 1
    [objectProto invokeStaticMethod:@"filter" parameters:@{ @"filter[limit]":@1} success:loadSuccessBlock failure:loadErrorBlock];
    
}

- ( void ) getNearest2
{
    
    // ++++++++++++++++++++++++++++++++++++
    
    // Get 2 Ships
    // http://localhost:3000/ships?filter%5Blimit%5D=2
    
    //
    // curl http://localhost:3000/location/nearby?here%5Blat%5D=37.587409&here%5Blng%5D=-122.338225
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        
        NSLog( @"Success %d", [models count]);
        
        [self.mapAnnotations removeAllObjects ];
        
        for (int i = 0; i < models.count; i++) {
            
            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            LBModel *geoInstance  = [modelInstance objectForKeyedSubscript:@"geo"];
            
            CLLocationCoordinate2D locCord;
            locCord.latitude = [[geoInstance objectForKeyedSubscript:@"lat"] doubleValue];
            locCord.longitude = [[geoInstance objectForKeyedSubscript:@"lng"] doubleValue];
            
            MapAnnotation *annot = [[MapAnnotation alloc] initWithLocation:locCord];
            annot.title = [modelInstance objectForKeyedSubscript:@"name"];
            annot.subtitle = [modelInstance objectForKeyedSubscript:@"SHIPTYPE"];
            
            [self.mapAnnotations addObject:annot ];
            
        }//end for
        
        [self.mapAnnotations addObject: [self sfAnnotation]];
        [self.mapAnnotations addObject: [self hqAnnotation]];
        
        [self.myMapView removeAnnotations:self.myMapView.annotations];  // remove any annotations that exist
        [self.myMapView addAnnotations:self.mapAnnotations]; //add the new Annotation list
        
        [self gotoLocation];
        
    };//end selfSuccessBlock
    
    //Get a local representation of the 'ships' model type
    LBModelPrototype *objectProto = [ [AppDelegate adapter] prototypeWithName:prototypeName];
    //[[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/ships?filter%5Blimit%5D=2" verb:@"GET"] forMethod:@"ships.custommethod2"];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/ships" verb:@"GET"] forMethod:@"ships.filter"];
    
    //get 2 
    [objectProto invokeStaticMethod:@"filter" parameters:@{ @"filter[limit]":@2} success:loadSuccessBlock failure:loadErrorBlock];

    
    //[[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/location/nearby" verb:@"GET"] forMethod:@"locations.getNearestFew"];

    /*
    // Ships with lowest inventory
    // http://localhost:3000/products?filter[order]=inventory%20ASC&filter[limit]=1': The highest inventory products
    [objectProto invokeStaticMethod:@"filter" parameters:@{ @"filter[order]":@"inventory ASC",@"filter[limit]":@1} success:staticMethodSuccessBlock failure:staticMethodErrorBlock];
    
    [objectProto invokeStaticMethod:@"getNearestFew" parameters:@{
     @"here": @{
     @"lat": 37.587409,
     @"lng": -122.338225
     }
     } success:staticMethodSuccessBlock failure:staticMethodErrorBlock];
    */
    
    
    
    
    
    // Invoke the allWithSuccess message for the 'ships' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/ships
    //[objectProto allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    //[objectB all:@"custommethod2" parameters:@{@"arg1":@"yack" , @"arg2":@123} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    
    
    //'/locations?filter[where][geo][near]=153.536,-28.1&filter[limit]=3': The 3 closest locations to a given
    
    // curl http://localhost:3000/locations/findOne?filter%5Bwhere%5D%5Bcity%5D=Scottsdale
    
    //LBModelPrototype *LocationProto = [ [AppDelegate adapter] prototypeWithName:prototypeName];
    //[[ [AppDelegate adapter]  contract] addItem:[SLRESTContractItem itemWithPattern:@"findOne" verb:@"GET"] forMethod:@"locations.getNearestFew"];
    //[LocationProto invokeStaticMethod:@"getNearestFew" parameters:@{} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    //[LocationProto invokeStaticMethod:@"getNearestFew" parameters:@{@"filter":@"yack" , @"limit":@2 } success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Configure the Location Manager - your location
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    manager.delegate = self;
    [manager startUpdatingLocation];
    
    // In the event the location services are disabled, start with a default location:
    self.location = [[CLLocation alloc] initWithLatitude:37.587409 longitude:-122.338225];
    
    //Add SF City and S8P HQ
    [self.mapAnnotations addObject: [self sfAnnotation]];
    [self.mapAnnotations addObject: [self hqAnnotation]];
    
    [self gotoLocation];
}

- (void)gotoLocation
{
    NSLog(@"gotoLocation ");
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996; //S8P HQ
    newRegion.center.longitude = -122.419281;
    newRegion.span.latitudeDelta = 0.423872;
    newRegion.span.longitudeDelta = 0.420863;
    
    [self.myMapView setRegion:newRegion animated:YES];
}//end gotoLocation


#pragma mark - MKMapViewDelegate

// user tapped the disclosure button in the callout
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped ");
    
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        NSLog(@"clicked MapAnnotation Annotation  ");
    }
    
    if ( [annotation isKindOfClass:[HQAnnotation class]])
    {
        NSLog(@"clicked HQAnnotation Annotation ");
    }
    
    //Hook for detail info
    
    //showdetail
    
    //[self.navigationController pushViewController:self.detailViewController animated:YES];
    
    [self performSegueWithIdentifier:@"showdetail" sender:self];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    NSLog(@"viewForAnnotation ");
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        NSLog(@"clicked MKUserLocation ");
        return nil;
    }
    
    if ([annotation isKindOfClass:[HQAnnotation class]]) // for HQ Annotation
    {
        MKAnnotationView *aView = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"HQAnnotationIdentifier"];
        if ( aView == nil)
        {
            aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"HQAnnotationIdentifier"];
            ((MKPinAnnotationView *)aView).pinColor = MKPinAnnotationColorGreen;
            ((MKPinAnnotationView *)aView).animatesDrop = YES;
            ((MKPinAnnotationView *)aView).canShowCallout = YES;
            
            /*
             // Add a detail disclosure button to the callout.
             UIButton* rightButton = [UIButton buttonWithType:
             UIButtonTypeDetailDisclosure];
             [rightButton addTarget:self action:@selector(myShowDetailsMethod:)
             forControlEvents:UIControlEventTouchUpInside];
             ((MKPinAnnotationView *)aView).rightCalloutAccessoryView = rightButton;
             */
        }
        return aView;
    }
    else if ([annotation isKindOfClass:[MapAnnotation class]])   // for Map Annotation
    {
        MKAnnotationView *aView = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"MapAnnotationIdentifier"];
        if ( aView == nil)
        {
            aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapAnnotationIdentifier"];
            ((MKPinAnnotationView *)aView).pinColor = MKPinAnnotationColorPurple;
            ((MKPinAnnotationView *)aView).animatesDrop = YES;
            ((MKPinAnnotationView *)aView).canShowCallout = YES;
        }
        return aView;
    }//end else if Map Annotation
    
    //fall through
    MKAnnotationView *aView = (MKPinAnnotationView *)[self.myMapView dequeueReusableAnnotationViewWithIdentifier:@"MapAnnotationIdentifier"];
    if ( aView == nil)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapAnnotationIdentifier"];
    }
    return aView;
}//end viewForAnnotation


- (IBAction)actionGetAll:(id)sender {
    [self getAll];
}

- (IBAction)actionGetNearest:(id)sender {
    [self getNearestHQ];
}
- (IBAction)actionGetNearest5:(id)sender {
    [self getNearest2];
}

- (IBAction)actionInject:(id)sender {
    
    LBModelPrototype *ObjectPrototype = [ [AppDelegate adapter]  prototypeWithName:prototypeName];
    
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"initializeServerWithData: Error on Save %@", error.description);
    };
    void (^saveNewSuccessBlock)() = ^() {
        //[self gotoLocation];
    };
    
    //Persist the newly created Model to the LoopBack node server
    [ [ObjectPrototype modelWithDictionary:@{
       @"name": [[NSString alloc] initWithFormat:@"Location %@",[NSNumber numberWithInteger:(arc4random() % 33 + 1)] ] ,
       @"geo" : [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:37.796996f + (arc4random()% 33 / 200.0f)] ,@"lat",
                 [NSNumber numberWithFloat:-122.429281f + (arc4random()% 33 / 200.0f)],@"lng",nil],
       @"SHIPTYPE" : @"Cargo",
       @"FLAG": @"US"
       }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    
    [ [ObjectPrototype modelWithDictionary:@{
       @"name": [[NSString alloc] initWithFormat:@"Location %@",[NSNumber numberWithInteger:(arc4random() % 33 + 1)] ] ,
     @"geo" : [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:37.796996f + (arc4random()% 33 / 200.0f)] ,@"lat",
     [NSNumber numberWithFloat:-122.429281f + (arc4random()% 33 / 200.0f)],@"lng",nil],
       @"SHIPTYPE" : @"Cargo",
       @"FLAG": @"US"
       }]  saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    
}//end actionInject

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
