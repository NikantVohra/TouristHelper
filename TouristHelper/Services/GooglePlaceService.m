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

NSString *const GooglePlacesAPIKey = @"AIzaSyCfKkqXD678HHpn11DCWwdYOoZ6M44B8M4";
NSString *const GooglePlacesAPIBaseURL = @"https://maps.googleapis.com/maps/api/place/";
NSString *const defaultPlaceTypes = @"food|museum|stadium|movie_theater";

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
    
    NSString *url = [NSString stringWithFormat:@"%@radarsearch/json?location=%f,%f&radius=%f&rankby=prominence&sensor=true&key=%@&types=%@",GooglePlacesAPIBaseURL, coordinate.latitude, coordinate.longitude, radius, GooglePlacesAPIKey, [self placesTypeString:types]];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if([self isDataTaskAlreadyRunning]) {
        [self.fetchNearbyPlacesTask cancel];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    __block NSError *storedError;
    self.fetchNearbyPlacesTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            NSMutableArray *googlePlaces = [[NSMutableArray alloc] init];
            NSError* conversionError;
            dispatch_group_t fetchPlacesGroup = dispatch_group_create();

            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&conversionError];
            if(!conversionError) {
                NSArray *fetchedPlaces = json[@"results"];
                for(NSDictionary *fetchedPlace in fetchedPlaces) {
                    GooglePlace *googlePlace = [[GooglePlace alloc] initWithDictionary:fetchedPlace];
                    [googlePlaces addObject:googlePlace];
//                    dispatch_group_enter(fetchPlacesGroup);
//                        // Do stuff on a global background queue here
//                    [self fetchPlaceInfoWithId:googlePlace.placeId onCompletion:^(GooglePlace *place, NSError *error) {
//                        if(error == nil) {
//                            [googlePlaces addObject:place];
//                        }
//                        else {
//                            storedError = error;
//                        }
//                        dispatch_group_leave(fetchPlacesGroup);
//                    }];
                }
                
            }
            dispatch_group_notify(fetchPlacesGroup, dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                completion(googlePlaces, storedError);
            });
            
            
        }
        
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                completion(nil, error);
            });
        }
    }];
    
    [self.fetchNearbyPlacesTask resume];
    
}

-(void)fetchPlaceInfoWithId:(NSString *)placeId onCompletion:(void(^)(GooglePlace *place, NSError *error))completion{
    NSString *url = [NSString stringWithFormat:@"%@details/json?placeid=%@&key=%@", GooglePlacesAPIBaseURL, placeId, GooglePlacesAPIKey];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            NSError* conversionError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                error:&conversionError];
            GooglePlace *place;
            if(!conversionError) {
                NSDictionary *fetchedPlace = json[@"result"];
                place = [[GooglePlace alloc] initWithDictionary:fetchedPlace];
//                [self fetchPhotoForPlace:place withCompletion:^(UIImage *image, NSError *error) {
//                    if(error == nil) {
//                        place.photo = image;
                        completion(place, nil);
                       
//                    }
//                    else {
//                        completion(nil, error);
//                        
//                    }
//                }];
            }
            
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });

        }
    }] resume];
}

-(void)fetchPhotoForPlace:(GooglePlace *)place withCompletion:(void(^)(UIImage *image, NSError *error)) completion {
    if(place.photoReference) {
        UIImage *cachedImage = [self.photoCache objectForKey:place.photoReference];
        if(cachedImage) {
            place.photo = cachedImage;
            completion(cachedImage, nil);
        }
        else {
            NSString *url = [NSString stringWithFormat:@"%@photo?maxwidth=200&photoreference=%@&key=%@", GooglePlacesAPIBaseURL, place.photoReference, GooglePlacesAPIKey];
            [[[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error == nil) {
                    UIImage *googlePlacePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    [self.photoCache setObject:googlePlacePhoto forKey:place.photoReference];
                    completion(googlePlacePhoto, nil);
                }
                else {
                    completion(nil, error);
                }
            }] resume];
        }
    }
    else {
        place.photo = nil;
        completion([UIImage imageNamed:@"placeholder"], nil);
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
