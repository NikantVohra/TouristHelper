//
//  GooglePlaceService.h
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlace.h"
#import <CoreLocation/CoreLocation.h>


@interface GooglePlaceService : NSObject

-(void)fetchNearbyPlacesFromLocation:(CLLocationCoordinate2D)coordinate withinRadius:(double)radius types:(NSArray *)types onCompletion:(void(^)(NSArray *googlePlaces, NSError *error))completion;
-(void)fetchPlaceInfoWithId:(NSString *)placeId onCompletion:(void(^)(GooglePlace *place, NSError *error))completion;

@end
