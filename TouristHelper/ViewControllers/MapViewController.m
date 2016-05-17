//
//  ViewController.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "MapViewController.h"
@import GoogleMaps;

@interface MapViewController() <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markerImageVerticalBottomConstraint;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationManager];
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark : Location Manager Methods

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
    }
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
                self.markerImageVerticalBottomConstraint.constant = -((addressLabelHeight - [self.topLayoutGuide length]) * 0.5);
                [self.view layoutIfNeeded];
            }];
        }
        
    }];
}


#pragma mark : GMSMapViewDelegate Methods

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [self getAddressFromLocationCoordinate:position.target];
}



@end
