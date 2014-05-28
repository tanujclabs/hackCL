//
//  ProfileDriverViewController.h
//  TaxiFyd Project
//
//  Created by Click Labs on 5/3/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ProfileDriverViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic,readwrite) NSDictionary *driverInfo;
@property(nonatomic,readwrite) BOOL isCustomer;
@property(nonatomic,readwrite)CLLocationCoordinate2D user_Coordinate;
@property(nonatomic,readwrite)int isLog;
@end
