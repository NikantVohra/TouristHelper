//
//  OptimalRouteTests.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OptimalRoute.h"
#import "GooglePlace.h"
@interface OptimalRouteTests : XCTestCase

@end

@implementation OptimalRouteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOptimalRoutes {
    double lat = 37.376;
    double lng = -121.957;
    NSMutableArray *places = [NSMutableArray new];
    for(int i = 0;i < 50;i++) {
        lat += 0.01;
        lng += 0.01;
        GooglePlace *place = [[GooglePlace alloc] init];
        place.locationCoordinate = CLLocationCoordinate2DMake(lat, lng);
        [places addObject:place];
    }
    OptimalRoute *route = [[OptimalRoute alloc] initWithPlaces:places forStartingLocation:CLLocationCoordinate2DMake(37.376, -121.957)];
    XCTAssertEqual(route.path.count, 52);
}


@end
