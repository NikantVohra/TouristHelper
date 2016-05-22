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

/**
 *  Fetches the nearby places
 *
 *  @param coordinate : coordinate of the current place
 *  @param radius : the radius within which places must be fetched
 *  @param tyes : types array for place types to be fetched
 *
 *  async call calls the completion block with the fetched places
 */
-(void)fetchNearbyPlacesFromLocation:(CLLocationCoordinate2D)coordinate withinRadius:(double)radius types:(NSArray *)types onCompletion:(void(^)(NSArray *googlePlaces, NSError *error))completion;


/**
 *  Fetches info for a particular place
 *
 *  @param placeId : placeId of place
 *
 *  async call calls the completion block with the fetched place
 */
-(void)fetchPlaceInfoWithId:(NSString *)placeId onCompletion:(void(^)(GooglePlace *place, NSError *error))completion;

/**
 *  Fetches photo for a particular place
 *
 *  @param place
 *
 *  async call calls the completion block with the fetched place image
 */
-(void)fetchPhotoForPlace:(GooglePlace *)place withCompletion:(void(^)(UIImage *image, NSError *error)) completion;

@end
