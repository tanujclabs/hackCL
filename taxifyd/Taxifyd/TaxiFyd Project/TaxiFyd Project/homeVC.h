//
//  homeVC.h
//  Taxifyd
//
//  Created by Click Labs on 5/2/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface homeVC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>

@end
