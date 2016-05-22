//
//  GooglePlaceMarker.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "GooglePlaceMarker.h"

@implementation GooglePlaceMarker

-(instancetype)initWithPlace:(GooglePlace *)place {
    if(self = [super init]) {
        self.place = place;
        self.position = place.locationCoordinate;
        if(place.placeType) {
            UIImage *image = [UIImage imageNamed:place.placeType];
            if(image) {
                self.icon = image;
            }
        }
        self.groundAnchor = CGPointMake(0.5, 1);
        self.appearAnimation = kGMSMarkerAnimationPop;
        return self;
    }
    else {
        return nil;
    }
}

@end
