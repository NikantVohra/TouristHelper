//
//  GooglePlaceTests.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GooglePlace.h"
@interface GooglePlaceTests : XCTestCase

@end

@implementation GooglePlaceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testGooglePlaceInitialisation {
    NSDictionary *googlePlaceDict = @{@"place_id" : @"ChIJN1t_tDeuEmsRUsoyG83frY4", @"name" : @"Google Sydney", @"geometry" : @{@"location" : @{@"lat" : @-33.8669710, @"lng" : @151.1958750}}, @"types" : @[@"establishment"], @"photos" : @[@{@"photo_reference" : @"CnRnAAAAF-LjFR1ZV93eawe1cU_3QNMCNmaGkowY7CnOf-kcNmPhNnPEG9W979jOuJJ1sGr75rhD5hqKzjD8vbMbSsRnq_Ni3ZIGfY6hKWmsOf3qHKJInkm4h55lzvLAXJVc"}] };
    GooglePlace *place = [[GooglePlace alloc] initWithDictionary:googlePlaceDict];
    XCTAssertEqualObjects(place.placeId, @"ChIJN1t_tDeuEmsRUsoyG83frY4");
    XCTAssertEqualObjects(place.name, @"Google Sydney");
    XCTAssertEqual(place.locationCoordinate.latitude,-33.8669710);
    XCTAssertEqual(place.locationCoordinate.longitude, 151.1958750);
    XCTAssertEqualObjects(place.placeType, @"establishment");
    XCTAssertEqualObjects(place.photoReference, @"CnRnAAAAF-LjFR1ZV93eawe1cU_3QNMCNmaGkowY7CnOf-kcNmPhNnPEG9W979jOuJJ1sGr75rhD5hqKzjD8vbMbSsRnq_Ni3ZIGfY6hKWmsOf3qHKJInkm4h55lzvLAXJVc");


}

@end
