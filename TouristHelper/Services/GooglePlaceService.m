//
//  GooglePlaceService.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "GooglePlaceService.h"


@interface GooglePlaceService()

@property(nonatomic, strong) NSDictionary *photosCache;
@property(nonatomic, strong) NSURLSessionDataTask *fetchNearbyPlacesTask;
@property(nonatomic, strong) NSMutableDictionary *photoCache;

@end

@implementation GooglePlaceService

NSString *const GooglePlacesAPIKey = @"AIzaSyD_1wjarbzsxkpAYz_RoKX0CIzS0Ba7USs";
NSString *const GooglePlacesAPIBaseURL = @"https://maps.googleapis.com/maps/api/place/";
NSString *const defaultPlaceTypes = @"food";

-(instancetype)init {
    if(self = [super init]) {
        self.photoCache = [[NSMutableDictionary alloc] init];
        return self;
    }
    else {
        return nil;
    }
}

-(void)fetchNearbyPlacesFromLocation:(CLLocationCoordinate2D)coordinate withinRadius:(double)radius types:(NSArray *)types onCompletion:(void(^)(NSArray *googlePlaces, NSError *error))completion {
    
    NSString *url = [NSString stringWithFormat:@"%@nearbysearch/json?location=%f,%f&radius=%f&rankby=prominence&sensor=true&key=%@&types=%@",GooglePlacesAPIBaseURL, coordinate.latitude, coordinate.longitude, radius, GooglePlacesAPIKey, [self placesTypeString:types]];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if([self isDataTaskAlreadyRunning]) {
        [self.fetchNearbyPlacesTask cancel];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    self.fetchNearbyPlacesTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if(!error) {
            NSMutableArray *googlePlaces = [[NSMutableArray alloc] init];
            NSError* conversionError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&conversionError];
            if(!conversionError) {
                NSArray *fetchedPlaces = json[@"results"];
                for(NSDictionary *fetchedPlace in fetchedPlaces) {
                    GooglePlace *place = [[GooglePlace alloc] initWithDictionary:fetchedPlace];
                    [googlePlaces addObject:place];
                    [self fetchPhotoForPlace:place];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(googlePlaces, nil);
            });
        }
        
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }];
    
    [self.fetchNearbyPlacesTask resume];
    
}

-(void)fetchPhotoForPlace:(GooglePlace *)place {
    if(place.photoReference) {
        UIImage *cachedImage = [self.photoCache objectForKey:place.photoReference];
        if(cachedImage) {
            place.photo = cachedImage;
        }
        else {
            NSString *url = [NSString stringWithFormat:@"%@photo?maxwidth=200&photoreference=%@&key=%@", GooglePlacesAPIBaseURL, place.photoReference, GooglePlacesAPIKey];
            [[[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error == nil) {
                    UIImage *googlePlacePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    [self.photoCache setObject:googlePlacePhoto forKey:place.photoReference];
                    place.photo = googlePlacePhoto;
                }
            }] resume];
        }
    }
    else {
        place.photo = nil;
    }
}



-(BOOL)isDataTaskAlreadyRunning {
    return (self.fetchNearbyPlacesTask && self.fetchNearbyPlacesTask.taskIdentifier > 0 && self.fetchNearbyPlacesTask.state == NSURLSessionTaskStateRunning);
}

-(NSString *)placesTypeString:(NSArray *)types {
    if(types.count > 0) {
        return [types componentsJoinedByString:@"|"];
    }
    else {
        return defaultPlaceTypes;
    }
}

@end
