//
//  GooglePlace.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "GooglePlace.h"

@implementation GooglePlace


-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if(self = [super init]) {
        self.name = dictionary[@"name"];
        self.photoReference = dictionary[@"photos"][0][@"photo_reference"];
        CLLocationDegrees lat = [dictionary[@"geometry"][@"location"][@"lat"] doubleValue];
        CLLocationDegrees lng = [dictionary[@"geometry"][@"location"][@"lng"] doubleValue];
        self.locationCoordinate = CLLocationCoordinate2DMake(lat, lng);
        self.placeType = [dictionary[@"types"] firstObject];
        return self;
    }
    else {
        return nil;
    }
}

@end
