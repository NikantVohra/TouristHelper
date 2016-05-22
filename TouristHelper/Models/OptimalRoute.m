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
