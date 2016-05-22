//
//  GooglePlaceMarker.h
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlace.h"

@interface GooglePlaceMarker : GMSMarker

/** The google place for the marker. */

@property(nonatomic, strong) GooglePlace *place;

/**
 *  Initialises the marker with a google place
 *
 *  @param place
 *
 *  Sets the different properties for the marker
 */
-(instancetype)initWithPlace:(GooglePlace *)place;

@end
