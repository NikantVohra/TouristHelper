//
//  MarkerDetailView.h
//  TouristHelper
//
//  Created by Vohra, Nikant on 5/17/16.
//  Copyright © 2016 Vohra, Nikant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkerDetailView : UIView

/** The image view for the marker detail view. */

@property (weak, nonatomic) IBOutlet UIImageView *placeImageView;

/** The placen label for the marker detail view. */

@property (weak, nonatomic) IBOutlet UILabel *placeNameLabel;

@end
