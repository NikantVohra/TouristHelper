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
#import "OptimalRoute.h"
#import "PlaceTypesTableViewController.h"
#import "Reachability.h"

@import GoogleMaps;

@interface MapViewController() <CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, PlaceTypesTableViewContollerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markerImageVerticalBottomConstraint;
@property (nonatomic, strong) GooglePlaceService *googlePlaceService;
@property (nonatomic, strong) NSArray *placeSearchTypes;
@property (nonatomic) Reachability *internetReachability;

@end



@implementation MapViewController

double nearbyRadius = 1000;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationManager];
    [self testInternetConnection];
    self.mapView.delegate = self;
    self.googlePlaceService = [[GooglePlaceService alloc] init];
    self.placeSearchTypes = @[@"restaurant", @"bakery", @"cafe", @"museum", @"movie_theater", @"bar", @"grocery_or_supermarket"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
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
    [self.mapView clear];
    [self.googlePlaceService fetchNearbyPlacesFromLocation:coordinate withinRadius:nearbyRadius types:self.placeSearchTypes onCompletion:^(NSArray *googlePlaces, NSError *error) {
        if(error == nil) {
            for(GooglePlace *place in googlePlaces) {
                GooglePlaceMarker *marker = [[GooglePlaceMarker alloc] initWithPlace:place];
                marker.map = self.mapView;
            }
        }
        OptimalRoute *optimalRoute = [[OptimalRoute alloc] initWithPlaces:googlePlaces forStartingLocation:coordinate];
        [self drawPathOnMap:optimalRoute.path];
    }];
}

-(void)drawPathOnMap:(GMSPath *)path {
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 2;
    polyline.map = self.mapView;
}


- (IBAction)refeshBarButtonPressed:(id)sender {
    [self fetchNearbyPlaces:self.mapView.camera.target];
}

- (IBAction)searchLocation:(id)sender {
    GMSAutocompleteViewController *autocompleteController = [[GMSAutocompleteViewController alloc] init];
    autocompleteController.delegate = self;
    [self presentViewController:autocompleteController animated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"PlaceTypeSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        PlaceTypesTableViewController *viewController = (PlaceTypesTableViewController *)navController.topViewController;
        viewController.selectedPlaceTypes = [self.placeSearchTypes mutableCopy];
        viewController.delegate = self;
    }
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
    NSLog(@"marker %@", placeMarker.place.placeType);

    if(markerDetailView) {
        
        markerDetailView.placeNameLabel.text = placeMarker.place.name;
        if(placeMarker.place.photo) {
            markerDetailView.placeImageView.image = placeMarker.place.photo;
        }
        else {
            markerDetailView.placeImageView.image = [UIImage imageNamed:@"placeholder"];
        }
        
    }

    return markerDetailView;
}

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    if(gesture) {
        mapView.selectedMarker = nil;
    }
}

#pragma mark : GMSAutocompleteViewControllerDelegate Methods

-(void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.mapView.camera =[GMSCameraPosition cameraWithTarget:place.coordinate zoom:15 bearing:0 viewingAngle:0];
    [self fetchNearbyPlaces:self.mapView.camera.target];

}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark : PlaceTypesTableViewContollerDelegate methods

-(void)placesTypeController:(PlaceTypesTableViewController *)controller didFilterPlaceTypes:(NSArray *)placeTypes {
    [self dismissViewControllerAnimated:true completion:nil];
    self.placeSearchTypes = controller.selectedPlaceTypes;
    [self fetchNearbyPlaces:self.mapView.camera.target];
}

#pragma mark: Reachability Methods


- (void)testInternetConnection
{
    self.internetReachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    __weak typeof(self) weakSelf = self;

    // Internet is reachable
    self.internetReachability.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
        });
    };
    
    // Internet is not reachable
    self.internetReachability.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showNoInternetConnectionAlert];
            NSLog(@"Someone broke the internet :(");
        });
    };
    
    [self.internetReachability startNotifier];
}

-(void)showNoInternetConnectionAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Internet Connection", nil)  message:NSLocalizedString(@"Please check your connection and try again...", nil)  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
