//
//  HQAnnotation.m
//  mapview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "HQAnnotation.h"

@implementation HQAnnotation

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 37.567004;
    theCoordinate.longitude = -122.324021;
    return theCoordinate;
}

- (NSString *)title
{
    return @"S8P HQ";
}

// optional
- (NSString *)subtitle
{
    return @"San Mateo";
}

@end
