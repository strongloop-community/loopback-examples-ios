//
//  MapAnnotation.m
//  mapview-example
//
//  Created by Matt Schmulen on 9/15/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = @"unknown";
        subtitle = @" - unknown -";
    }
    return self;
}

- (id)initWithLocationAndName:(CLLocationCoordinate2D)coord name:(NSString*)name {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = name;
    }
    return self;
}


@end
