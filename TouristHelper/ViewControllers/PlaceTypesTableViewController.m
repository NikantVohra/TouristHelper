//
//  PlaceTypesViewControllerTableViewController.m
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import "PlaceTypesTableViewController.h"

@interface PlaceTypesTableViewController ()

@property(nonatomic, strong) NSDictionary *placeTypesDict;
@property(nonatomic, strong) NSArray *placeTypes;

@end

@implementation PlaceTypesTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeTypesDict =  @{@"restaurant" : @"Restaurant", @"movie_theater" : @"Movie Theater", @"bar" : @"Bar", @"cafe" : @"Cafe", @"grocery_or_supermarket" : @"Grocery Store", @"museum" : @"Museum" , @"bakery" : @"Bakery"};
    self.placeTypes = [self.placeTypesDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate placesTypeController:self didFilterPlaceTypes:self.selectedPlaceTypes];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeTypesDict.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceTypeCell"];
    NSString *placeType = self.placeTypes[indexPath.row];
    cell.textLabel.text = self.placeTypesDict[placeType];
    cell.imageView.image = [UIImage imageNamed:placeType];
    cell.accessoryType = [self.selectedPlaceTypes containsObject:placeType] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - Table view Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSString *placeType = self.placeTypes[indexPath.row];
    if([self.selectedPlaceTypes containsObject:placeType]) {
        [self.selectedPlaceTypes removeObject:placeType];
    }
    else {
        [self.selectedPlaceTypes addObject:placeType];
    }
    [self.tableView reloadData];

}


@end
