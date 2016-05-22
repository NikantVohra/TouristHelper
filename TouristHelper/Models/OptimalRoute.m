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
        
        double minDistance = DBL_MAX;
        for(int i = 0;i < googlePlaces.count;i++) {
            self.totalDistance = 0.0;
            GMSMutablePath *currentPath= [[self findOptimalRoute: googlePlaces forStartingPlace:[googlePlaces objectAtIndex:i]] mutableCopy];
            double startingLocDistance = [startingPlace distanceFromPlace:[googlePlaces objectAtIndex:i]];
            GooglePlace *endPlace = [[GooglePlace alloc] init];
            endPlace.locationCoordinate = [currentPath coordinateAtIndex:googlePlaces.count];
            double endLocDistance = [startingPlace distanceFromPlace:endPlace];
            [currentPath insertCoordinate:origin atIndex:0];
            [currentPath addCoordinate:origin];
            self.totalDistance += startingLocDistance + endLocDistance;
            if(self.totalDistance < minDistance) {
                minDistance = self.totalDistance;
                self.path = currentPath;
            }
        }
        self.totalDistance = minDistance;
        
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
    NSInteger startingLocationIndex = [googlePlaces indexOfObject:origin];
    visitedPlaces[startingLocationIndex] = true;
    GooglePlace *currentPlace = origin;
    
    for(int i = 0;i < numPlaces - 1;i++) {
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
        self.totalDistance += currentMinDistance;
        [optimalRoute addCoordinate:currentPlace.locationCoordinate];
        visitedPlaces[currentMinPlaceIndex] = true;
    }
    return optimalRoute;
}

                               

@end
