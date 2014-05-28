//
//  DriverVC.h
//  TaxiFyd Project
//
//  Created by Click Labs on 5/3/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DriverVC : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end
