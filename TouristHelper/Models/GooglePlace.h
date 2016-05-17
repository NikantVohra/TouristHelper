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

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *photoReference; //photoreference is a reference id returned by google places api that can be        used to retrieve the place image
@property(nonatomic, strong) NSString *placeType;
@property(nonatomic) CLLocationCoordinate2D locationCoordinate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
