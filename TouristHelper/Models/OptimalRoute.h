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

@property(nonatomic, strong) GMSPath *path;

-(instancetype)initWithPlaces:(NSArray *)googlePlaces forStartingLocation:(CLLocationCoordinate2D)origin;

@end
