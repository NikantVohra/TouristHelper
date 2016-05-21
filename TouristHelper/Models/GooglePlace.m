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
        self.placeId = dictionary[@"place_id"];
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

-(double)distanceFromPlace:(GooglePlace *)place {
    CLLocation *place1Location = [[CLLocation alloc] initWithLatitude:self.locationCoordinate.latitude longitude:self.locationCoordinate.longitude];
    CLLocation *place2Location = [[CLLocation alloc] initWithLatitude: place.locationCoordinate.latitude longitude:place.locationCoordinate.longitude];
    return [place1Location distanceFromLocation: place2Location];

}
@end
