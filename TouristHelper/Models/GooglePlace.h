//
//  GooglePlace.h
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;


@interface GooglePlace : NSObject

/** The placeId for the google place. */

@property(nonatomic, strong) NSString *placeId;

/** The name for the google place. */

@property(nonatomic, strong) NSString *name;

/** photoreference is a reference id returned by google places api that can be used to retrieve the place image */

@property(nonatomic, strong) NSString *photoReference;

/** The photo for a google place */

@property(nonatomic, strong) UIImage *photo;

/** The place type example restaurant, bar, cafe, museum etc */

@property(nonatomic, strong) NSString *placeType;

/** The location coordinate for the place */

@property(nonatomic) CLLocationCoordinate2D locationCoordinate;

/**
 *  Initialises the place with a dictionary(json)
 *
 *  @param dictionary
 *
 *  Sets the different properties for the place
 */
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Gets the distance of the place from another place
 *
 *  @param place
 *
 *  returns the distance of the place from another place
 */
-(double)distanceFromPlace:(GooglePlace *)place;


@end
