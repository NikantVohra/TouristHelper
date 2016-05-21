//
//  PlaceTypesViewControllerTableViewController.h
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/21/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlaceTypesTableViewController;

@protocol PlaceTypesTableViewContollerDelegate <NSObject>

-(void)placesTypeController:(PlaceTypesTableViewController *)controller didFilterPlaceTypes : (NSArray *)placeTypes;

@end

@interface PlaceTypesTableViewController : UITableViewController

@property(nonatomic, weak) id<PlaceTypesTableViewContollerDelegate> delegate;
@property(nonatomic, strong) NSMutableArray *selectedPlaceTypes;

@end
