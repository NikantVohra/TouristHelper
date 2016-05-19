//
//  ViewController.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "MapViewController.h"
#import "GooglePlaceService.h"
#import "GooglePlaceMarker.h"
#import "MarkerDetailView.h"
@import GoogleMaps;

@interface MapViewController() <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markerImageVerticalBottomConstraint;
@property (nonatomic, strong) GooglePlaceService *googlePlaceService;
@end



@implementation MapViewController

double nearbyRadius = 5000;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationManager];
    self.mapView.delegate = self;
    self.googlePlaceService = [[GooglePlaceService alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getAddressFromLocationCoordinate:(CLLocationCoordinate2D) coordinate {
    GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
    [geocoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable result, NSError * _Nullable error) {
        GMSAddress *address = result.firstResult;
        if(address) {
            self.addressLabel.text = [address.lines componentsJoinedByString:@"\n"];
            CGFloat addressLabelHeight = self.addressLabel.intrinsicContentSize.height;
            self.mapView.padding = UIEdgeInsetsMake([self.topLayoutGuide length], 0, addressLabelHeight, 0);
            [UIView animateWithDuration:0.25 animations:^{
                self.markerImageVerticalBottomConstraint.constant = -((addressLabelHeight - [self.topLayoutGuide length]) * 0.5); //adjust the marker image constraint to accomodate tha address label height
                [self.view layoutIfNeeded];
            }];
        }
        
    }];
}

-(void)fetchNearbyPlaces:(CLLocationCoordinate2D) coordinate {
    [self.googlePlaceService fetchNearbyPlacesFromLocation:coordinate withinRadius:nearbyRadius types:nil onCompletion:^(NSArray *googlePlaces, NSError *error) {
        if(error == nil) {
            for(GooglePlace *place in googlePlaces) {
                GooglePlaceMarker *marker = [[GooglePlaceMarker alloc] initWithPlace:place];
                marker.map = self.mapView;
            }
        }
    }];
}
- (IBAction)refeshBarButtonPressed:(id)sender {
    [self fetchNearbyPlaces:self.mapView.camera.target];
}

#pragma mark : CLLocationManager Methods

-(void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLocation = [locations objectAtIndex:0];
    if(currentLocation) {
        self.mapView.camera =[GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:15 bearing:0 viewingAngle:0];
        [self.locationManager stopUpdatingLocation];
        [self fetchNearbyPlaces:currentLocation.coordinate];
    }
}



#pragma mark : GMSMapViewDelegate Methods

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [self getAddressFromLocationCoordinate:position.target];
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(nonnull GMSMarker *)marker {
    MarkerDetailView *markerDetailView = [[[NSBundle mainBundle]loadNibNamed:@"MarkerDetailView" owner:self options:nil] firstObject];
    GooglePlaceMarker *placeMarker = (GooglePlaceMarker *)marker;
    if(markerDetailView) {
        [self.googlePlaceService fetchPlaceInfoWithId:placeMarker.place.placeId onCompletion:^(GooglePlace *place, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                placeMarker.place = place;
                markerDetailView.placeNameLabel.text = placeMarker.place.name;
                if(placeMarker.place.photo) {
                    markerDetailView.placeImageView.image = placeMarker.place.photo;
                }
                else {
                    markerDetailView.placeImageView.image = [UIImage imageNamed:@"placeholder"];
                }
            });

        }];
        
    }
    return markerDetailView;
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    if(gesture) {
        mapView.selectedMarker = nil;
    }
}

@end
