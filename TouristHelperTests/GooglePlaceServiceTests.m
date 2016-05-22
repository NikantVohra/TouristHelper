//
//  GooglePlaceServiceTests.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/18/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GooglePlaceService.h"

@interface GooglePlaceServiceTests : XCTestCase

@end

@implementation GooglePlaceServiceTests {
    GooglePlaceService *googlePlaceService;
    
}

- (void)setUp {
    [super setUp];
    googlePlaceService = [[GooglePlaceService alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testFetchNearbyPlacesFromLocationForDefaultTypes{
    XCTestExpectation *fetchNearbyPlacesExpectation = [self expectationWithDescription:@"fetchNearbyPlacesExpectation"];
    CLLocationCoordinate2D loc;
    loc.latitude = 37.376;
    loc.longitude = -121.957;
    [googlePlaceService fetchNearbyPlacesFromLocation:loc withinRadius:2000 types:nil onCompletion:^(NSArray *googlePlaces, NSError *error) {
        XCTAssertEqual(googlePlaces.count, 90);
        [fetchNearbyPlacesExpectation fulfill];

    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
    }];
}

-(void)testFetchNearbyPlacesFromLocationForCustomTypes {
    XCTestExpectation *fetchNearbyPlacesExpectation = [self expectationWithDescription:@"fetchNearbyPlacesExpectation"];
    CLLocationCoordinate2D loc;
    loc.latitude = 37.376;
    loc.longitude = -121.957;
    [googlePlaceService fetchNearbyPlacesFromLocation:loc withinRadius:2000 types:@[@"bar", @"food", @"museum", @"night_club", @"gas_station", @"airport"] onCompletion:^(NSArray *googlePlaces, NSError *error) {
        XCTAssertEqual(googlePlaces.count, 99);
        [fetchNearbyPlacesExpectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
    }];
}

-(void)testFetchPlaceInfo {
    XCTestExpectation *fetchPlaceInfoExpectation = [self expectationWithDescription:@"fetchPlaceInfoExpectation"];
    [googlePlaceService fetchPlaceInfoWithId:@"ChIJN1t_tDeuEmsRUsoyG83frY4" onCompletion:^(GooglePlace*place, NSError *error) {
        XCTAssertEqualObjects(@"Google", place.name);
        [fetchPlaceInfoExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        
    }];
}



@end
