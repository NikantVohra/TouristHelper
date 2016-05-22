//
//  OptimalRoute.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "OptimalRoute.h"
#import "GooglePlace.h"


@interface OptimalRoute()

@property(nonatomic, strong) NSArray *places;
@property(nonatomic) CLLocationCoordinate2D origin;


@end

@implementation OptimalRoute

-(instancetype)initWithPlaces:(NSArray *)googlePlaces forStartingLocation:(CLLocationCoordinate2D)origin {
    self = [super init];
    if(self) {
        self.origin = origin;
        self.places = googlePlaces;
        [self findOptimalRoute];
    }
    return self;
}

/**
 *  Finds the optimal route and populates path and total distance properties
 *  This problem is a classic TSP problem https://simple.wikipedia.org/wiki/Travelling_salesman_problem
 *  TSP is a NP hard problem and for 100 places finding the optimal solution will take
    an insane amountof time
 *  The solution presented here is an approximate algorithm called the Greedy Nearest Neighbour for all starting places which gives a solution usually within 10 or 20% of the shortest possible and can handle thousands of cities (https://web.archive.org/web/20131202232743/http://nbviewer.ipython.org/url/norvig.com/ipython/TSPv3.ipynb)
 */

-(void)findOptimalRoute {
    GooglePlace *startingPlace = [[GooglePlace alloc] init];
    startingPlace.locationCoordinate = self.origin;
    
    double minDistance = DBL_MAX;
    for(int i = 0;i < self.places.count;i++) {
        self.totalDistance = 0.0;
        GMSMutablePath *currentPath= [[self findOptimalRouteWithStartingPlace:[self.places objectAtIndex:i]] mutableCopy];
        double startingLocDistance = [startingPlace distanceFromPlace:[self.places objectAtIndex:i]];
        GooglePlace *endPlace = [[GooglePlace alloc] init];
        endPlace.locationCoordinate = [currentPath coordinateAtIndex:self.places.count];
        double endLocDistance = [startingPlace distanceFromPlace:endPlace];
        [currentPath insertCoordinate:self.origin atIndex:0];
        [currentPath addCoordinate:self.origin];
        self.totalDistance += startingLocDistance + endLocDistance;
        if(self.totalDistance < minDistance) {
            minDistance = self.totalDistance;
            self.path = currentPath;
        }
    }
    self.totalDistance = minDistance;
}

/**
 *  Finds the optimal path for a given starting place using Greedy Nearest Neighbor
 *  @param origin
 *  returns the optimal path
 */

-(GMSPath *)findOptimalRouteWithStartingPlace:(GooglePlace *)origin {
    GMSMutablePath *optimalRoute = [[GMSMutablePath alloc] init];
    [optimalRoute addCoordinate:origin.locationCoordinate];
    NSInteger numPlaces = self.places.count;
    BOOL visitedPlaces[numPlaces];
    for(int i = 0;i < numPlaces;i++) {
        visitedPlaces[i] = false;
    }
    NSInteger startingLocationIndex = [self.places indexOfObject:origin];
    visitedPlaces[startingLocationIndex] = true;
    GooglePlace *currentPlace = origin;
    
    for(int i = 0;i < numPlaces - 1;i++) {
        NSDictionary *nearestNeighbour = [self findNearestNeighbourforPlace:currentPlace visitedPlaces:visitedPlaces];
        NSInteger currentMinPlaceIndex = [nearestNeighbour[@"index"] integerValue];
        double currentMinDistance =  [nearestNeighbour[@"distance"] doubleValue];
        currentPlace = self.places[currentMinPlaceIndex];
        self.totalDistance += currentMinDistance;
        [optimalRoute addCoordinate:currentPlace.locationCoordinate];
        visitedPlaces[currentMinPlaceIndex] = true;
    }
    return optimalRoute;
}

/**
 *  Finds the nearest neighbour for a place
 *  @param googlePlace
 *  @param an array for already visited places
 *  returns a NSDictionary with structure @{"distance" : distance of nearest neighbour, "index" : index for nearest neighbour}
 */

-(NSDictionary *)findNearestNeighbourforPlace:(GooglePlace *)place visitedPlaces:(BOOL[]) visitedPlaces
{
    NSInteger currentMinPlaceIndex = -1;
    double currentMinDistance = DBL_MAX;
    
    for(int j = 0; j < self.places.count;j++){
        if(visitedPlaces[j]) {
            continue;
        }
        double distance = [place distanceFromPlace:self.places[j]];
        if(distance < currentMinDistance) {
            currentMinDistance = distance;
            currentMinPlaceIndex = j;
        }
    }
    return @{@"distance" : @(currentMinDistance), @"index" : @(currentMinPlaceIndex)};
}


@end
