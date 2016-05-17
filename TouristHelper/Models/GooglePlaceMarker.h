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

@property(nonatomic, strong) GooglePlace *place;

-(instancetype)initWithPlace:(GooglePlace *)place;

@end
