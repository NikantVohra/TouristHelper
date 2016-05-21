//
//  OptimalRoute.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "OptimalRoute.h"
#import "GooglePlace.h"

@implementation OptimalRoute

-(instancetype)initWithPlaces:(NSArray *)googlePlaces forStartingLocation:(CLLocationCoordinate2D)origin {
    self = [super init];
    if(self) {
        GooglePlace *startingPlace = [[GooglePlace alloc] init];
        startingPlace.locationCoordinate = origin;
        self.path = [self findOptimalRoute: googlePlaces forStartingPlace:startingPlace];
    }
    return self;
}


-(GMSPath *)findOptimalRoute:(NSArray *)googlePlaces forStartingPlace:(GooglePlace *)origin {
    GMSMutablePath *optimalRoute = [[GMSMutablePath alloc] init];
    [optimalRoute addCoordinate:origin.locationCoordinate];
    NSInteger numPlaces = googlePlaces.count;
    BOOL visitedPlaces[numPlaces];
    for(int i = 0;i < numPlaces;i++) {
        visitedPlaces[i] = false;
    }
    GooglePlace *currentPlace = origin;
    
    for(int i =0;i < numPlaces;i++) {
        NSInteger currentMinPlaceIndex = -1;
        double currentMinDistance = DBL_MAX;
        
        for(int j = 0; j < numPlaces;j++){
            if(visitedPlaces[j]) {
                continue;
            }
            double distance = [currentPlace distanceFromPlace:googlePlaces[j]];
            if(distance < currentMinDistance) {
                currentMinDistance = distance;
                currentMinPlaceIndex = j;
            }
        }
        currentPlace = googlePlaces[currentMinPlaceIndex];
        [optimalRoute addCoordinate:currentPlace.locationCoordinate];
        visitedPlaces[currentMinPlaceIndex] = true;
    }
    [optimalRoute addCoordinate:origin.locationCoordinate];
    return optimalRoute;
}

                               

@end
