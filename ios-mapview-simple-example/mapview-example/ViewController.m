//
//  ViewController.m
//  mapview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@property (weak, nonatomic) LBRESTAdapter *adapter;
@property (nonatomic) CLLocation *location;

@property (nonatomic, strong) NSMutableArray *mapAnnotations;
    
@end

@implementation ViewController
- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    return _adapter;
}


- (NSArray *) mapAnnotations
{
    if ( !_mapAnnotations) _mapAnnotations = [[NSMutableArray alloc] init];
    return _mapAnnotations;
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
        
        [self.myMapView removeAnnotations:self.myMapView.annotations];  // remove any annotations that exist
        [self.myMapView addAnnotations:self.mapAnnotations]; //add the new Annotation list
        
        [self gotoLocation];
        
    };//end selfSuccessBlock
    
    //Get a local representation of the 'ships' model type
    LBModelPrototype *objectB = [self.adapter prototypeWithName:@"ships"];
    
    // Invoke the allWithSuccess message for the 'ships' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/ships
    
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
}


- ( void ) getNearest
{
    
}

- ( void ) getNearestFew
{
    
    // ++++++++++++++++++++++++++++++++++++
    // http://localhost:3000/ships?filter%5Blimit%5D=2
    // curl http://localhost:3000/ships/nearby?here%5Blat%5D=37.587409&here%5Blng%5D=-122.338225
    // ++++++++++++++++++++++++++++++++++++
    
    // Define the load error functional block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);
    };//end selfFailblock
    
    // Define the load success block for the LBModelPrototype allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %d", models.count);
        
        NSLog( @"Success %d", [models count]);
        
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
        
        [self.myMapView removeAnnotations:self.myMapView.annotations];  // remove any annotations that exist
        [self.myMapView addAnnotations:self.mapAnnotations]; //add the new Annotation list
        
        [self gotoLocation];
        
    };//end selfSuccessBlock
    
    //Get a local representation of the 'ships' model type
    LBModelPrototype *objectB = [self.adapter prototypeWithName:@"ships"];
    [[self.adapter contract] addItem:[SLRESTContractItem itemWithPattern:@"/ships?filter%5Blimit%5D=2" verb:@"GET"] forMethod:@"ships.custommethod2"];
    
    // Invoke the allWithSuccess message for the 'ships' LBModelPrototype
    // Equivalent http JSON endpoint request : http://localhost:3000/ships
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
    //[objectB all:@"custommethod2" parameters:@{@"arg1":@"yack" , @"arg2":@123} success:staticMethodSuccessBlock failure:staticMethodErrorBlock ];
    
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
    
    // Add SF City
    CLLocationCoordinate2D cityCoord;
    cityCoord.latitude = 37.786996;
    cityCoord.longitude = -122.419281;
    MapAnnotation *cityAnnotation = [[MapAnnotation alloc] initWithLocation:cityCoord];
    cityAnnotation.title = @"SF";
    cityAnnotation.subtitle = @"city";
    [self.mapAnnotations addObject:cityAnnotation ];
    
    // annotation for S8P HQ
    HQAnnotation *hqAnnotation = [[HQAnnotation alloc] init];
    [self.mapAnnotations addObject:hqAnnotation];
    
    [self gotoLocation];
}

- (void)gotoLocation
{
    NSLog(@"gotoLocation ");
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.786996; //S8P HQ
    newRegion.center.longitude = -122.419281;
    newRegion.span.latitudeDelta = 0.123872;
    newRegion.span.longitudeDelta = 0.120863;
    
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
    [self getNearest];
}
- (IBAction)actionGetNearest5:(id)sender {
    [self getNearestFew];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
