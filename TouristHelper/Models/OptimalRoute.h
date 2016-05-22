//
//  OptimalRoute.h
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

@interface OptimalRoute : NSObject

/** The path for the optimal route consisting of the place coordinates. */

@property(nonatomic, strong) GMSPath *path;

/** Total Distance for the optimal path. */

@property(nonatomic) double totalDistance;

/**
 *  Initialises the optimal route for a given set of Google Places and starting location
 *
 *  @param googlePlaces
 *  @param origin
 *
 *  Sets the path and Distance properties for the route
 */
-(instancetype)initWithPlaces:(NSArray *)googlePlaces forStartingLocation:(CLLocationCoordinate2D)origin;

@end
