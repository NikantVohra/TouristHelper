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
@property(nonatomic, strong) NSMutableArray *places;
@end

@implementation OptimalRouteTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    double lat = 37.376;
    double lng = -121.957;
    self.places = [NSMutableArray new];
    for(int i = 0;i < 100;i++) {
        lat += 0.01;
        lng += 0.01;
        GooglePlace *place = [[GooglePlace alloc] init];
        place.locationCoordinate = CLLocationCoordinate2DMake(lat, lng);
        [self.places addObject:place];
    }

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testOptimalRoutes {
    OptimalRoute *route = [[OptimalRoute alloc] initWithPlaces:self.places forStartingLocation:CLLocationCoordinate2DMake(37.376, -121.957)];
    XCTAssertEqual(route.path.count, 102);
}

-(void)testOptimalRouteAlgorithmPerformance {
    [self measureBlock:^{
        NSLog(@"%@",[[OptimalRoute alloc] initWithPlaces:self.places forStartingLocation:CLLocationCoordinate2DMake(37.376, -121.957)]);

    }];
}

@end
