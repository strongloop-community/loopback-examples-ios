//
//  MapAnnotation.h
//  mapview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString* title;
    NSString* subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)     NSString*               title;
@property (nonatomic, copy)     NSString*               subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (id)initWithLocationAndName:(CLLocationCoordinate2D)coord name:(NSString*)name;

@end
