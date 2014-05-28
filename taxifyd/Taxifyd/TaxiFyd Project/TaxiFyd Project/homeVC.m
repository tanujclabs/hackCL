//
//  homeVC.m
//  Taxifyd
//
//  Created by Click Labs on 5/2/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "homeVC.h"
#import "Navigation.h"
#import "sidemenu.h"
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"
#import "AsyncImageView.h"
#import "ProfileDriverViewController.h"
@interface homeVC ()
{
    UIScrollView *main;
    BOOL flag;
    CLLocationManager * locationManager;
    NSMutableArray *InformationArray;
    int user_type;
    NSMutableArray *driverAnnotation;
    UITapGestureRecognizer *tap;
    UIView *infoView;
    UIView *pickupView;
    BOOL infoFlag;
    NSDictionary *driverInfo;
    UITextField *time_fld;
    UITextField *cost_fld;
    BOOL isKeyboardVisible;
    CLLocationCoordinate2D mycoords ;
}
@property (nonatomic, strong) MKMapView *mapView;
@end

@implementation homeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWasShown
{
    isKeyboardVisible=TRUE;
}
-(void)keyboardWillBeHidden
{
    isKeyboardVisible=FALSE;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor=[UIColor blackColor];
    driverAnnotation=[[NSMutableArray alloc]init];
    flag=TRUE;
    infoFlag=FALSE;
    isKeyboardVisible=FALSE;
    user_type=1;
    main=[[UIScrollView alloc]init];
    main.backgroundColor=[UIColor clearColor];
    main.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [main setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:main];
    
    Navigation *nav=[[Navigation alloc]init];
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    navBar=[nav addNavigation:[[NSUserDefaults standardUserDefaults] objectForKey:@"name"] withView:main];
    
    UIButton* homeButton = [[UIButton alloc] init ];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    homeButton.frame=CGRectMake(5 , 0, 50, 50);
    [navBar addSubview:homeButton];
    [main addSubview: navBar];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 50, main.frame.size.width,  main.frame.size.height-50)];
    self.mapView.delegate = self;
    
    [main addSubview:self.mapView];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    [self registerForKeyboardNotifications];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [main addGestureRecognizer:tap];
}
- (void)tapped
{
    if(isKeyboardVisible)
    {
        [self.view endEditing:YES];
        isKeyboardVisible=FALSE;
    }
    else{
        if(infoView!=nil)
        {
            if(infoView.tag==1)
            {
                [UIView animateWithDuration:0.7 animations:^{
                    infoView.frame = CGRectMake(infoView.frame.origin.x,
                                                self.view.frame.size.height,
                                                infoView.frame.size.width,
                                                infoView.frame.size.height);
                } completion:^ (BOOL finished){
                    if (finished) {
                        [infoView removeFromSuperview];
                        infoView=nil;
                        infoFlag=TRUE;
                        
                    }}];
                
            }
        }
        if(pickupView!=nil)
        {
            [UIView animateWithDuration:0.7 animations:^{
                [infoView setAlpha:0];
            } completion:^ (BOOL finished){
                if (finished) {
                    [pickupView removeFromSuperview];
                    pickupView=nil;
                    
                }}];
            
        }
        
    }

}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =[self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:touchMapCoordinate];
    annotation.title = @"Current Location";
    annotation.subtitle = @"Montréal, QC";
    annotation.PinType=@"destination";
    user_type=2;
    [self.mapView addAnnotation:annotation];
}

- (void)viewDidAppear:(BOOL)animated {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
    [locationManager startUpdatingLocation];
}
-(void) locationManager: (CLLocationManager *) manager didUpdateToLocation: (CLLocation *) newLocation fromLocation: (CLLocation *) oldLocation
{
    [locationManager stopUpdatingLocation];
    NSLog(@"latitude : %f",newLocation.coordinate.latitude);
    NSLog(@"longitude : %f",newLocation.coordinate.longitude);
    mycoords= CLLocationCoordinate2DMake (newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    user_type=1;
    [self showPoint:mycoords isUser:-1];
    [self showDriver:mycoords];
  
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[SVAnnotation class]]) {
        static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (pulsingView == nil)
//        {
//            pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//            
//            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(-30, -10, 30, 15)];
//            lbl.backgroundColor = [UIColor blackColor];
//            lbl.layer.cornerRadius=5;
//            lbl.textColor = [UIColor whiteColor];
//            lbl.alpha = 0.5;
//            lbl.tag = 42;
//            [pulsingView addSubview:lbl];
//            
//            //Following lets the callout still work if you tap on the label...
//            pulsingView.canShowCallout = YES;
//            pulsingView.frame = lbl.frame;
//            
//            if([((SVAnnotation *)annotation).PinType isEqualToString:@"user"])
//                pulsingView.image=[UIImage imageNamed:@"homemap.png"];
//            else if([((SVAnnotation *)annotation).PinType isEqualToString:@"driver"])
//                pulsingView.image=[UIImage imageNamed:@"car.png"];
//            else
//                pulsingView.image=[UIImage imageNamed:@"car.png"];
//
//        }
//        else
//        {
//            pulsingView.annotation = annotation;
//        }
//        
//        UILabel *lbl = (UILabel *)[pulsingView viewWithTag:42];
//        lbl.text = annotation.title;
        
		if(pulsingView == nil) {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            //pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            if([((SVAnnotation *)annotation).PinType isEqualToString:@"user"])
                pulsingView.image=[UIImage imageNamed:@"homemap.png"];
            else if([((SVAnnotation *)annotation).PinType isEqualToString:@"driver"])
                pulsingView.image=[UIImage imageNamed:@"car.png"];
            else
                pulsingView.image=[UIImage imageNamed:@"car.png"];
            pulsingView.canShowCallout = NO;
            pulsingView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
		
		return pulsingView;
    }
    
    return nil;
}
-(void)showPoint:(CLLocationCoordinate2D)coordinate isUser:(int)user
{
    if(user==-1)
    {
        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.06, 0.06));
        [self.mapView setRegion:region animated:NO];
    }
    
    SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:coordinate];
    if(user_type==1)
    {
        annotation.title = @"Current Location";
        annotation.subtitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
        annotation.PinType=@"user";
        annotation.pos=user;
        
    }
    else if(user_type==3)
    {
//        annotation.title = [[InformationArray valueForKey:@"username"] objectAtIndex:user];
//        annotation.subtitle =[NSString stringWithFormat:@"Per KM Cost :%@\n Distance :%@",[[InformationArray valueForKey:@"kmpercost"] objectAtIndex:user],[[InformationArray valueForKey:@"distance"] objectAtIndex:user]];
        annotation.PinType=@"driver";
        annotation.pos=user;
        [driverAnnotation addObject:annotation];
    }
    
    [self.mapView addAnnotation:annotation];
}
-(void)showDriver:(CLLocationCoordinate2D)coordinate
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        [self HideActivityIndicator];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getdriverlocation&lastLlat=%f&lastLlong=%f",coordinate.latitude,coordinate.longitude];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            if(json)
            {
                InformationArray=[json objectForKey:@"DriverList"] ;
                NSLog(@"%@",[[InformationArray valueForKey:@"username"] objectAtIndex:0]);
                for(int count=0;count<InformationArray.count;count++)
                {
                    CLLocationCoordinate2D coords= CLLocationCoordinate2DMake ([[[InformationArray valueForKey:@"lastLlat"] objectAtIndex:count]floatValue],[[[InformationArray valueForKey:@"lastLlong"] objectAtIndex:count]floatValue]);
                    user_type=3;
                    [self showPoint:coords isUser:count];
                }
                [self HideActivityIndicator];
                
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Error in login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Eroor in Data Fetch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
    }
    [self HideActivityIndicator];

}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    NSLog(@"Popup :%d",((SVAnnotation *)view.annotation).pos);
    if(infoView!=nil)
        infoFlag=TRUE;
    else
        infoFlag=FALSE;
    infoView=nil;
    int pos=((SVAnnotation *)view.annotation).pos;
    if(pos==-1)
    {
        infoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 60)];
        infoView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.8];
        infoView.tag=1;
        [main addSubview:infoView];
        
        UIButton* bargainButton = [[UIButton alloc] init ];
        [bargainButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
        [bargainButton addTarget:self action:@selector(broadcastbargain) forControlEvents:UIControlEventTouchUpInside];
        bargainButton.frame=CGRectMake(5 , 10, infoView.frame.size.width-10, infoView.frame.size.height-20);
        [bargainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bargainButton setTitle:@"Broadcast a bargain request" forState:UIControlStateNormal];
        [bargainButton.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:18]];
        
        [infoView addSubview: bargainButton];
        
    }
    else{
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        
        if (netStatus == NotReachable)
        {
            [self HideActivityIndicator];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getdriverpro&fbid=%@",[[InformationArray valueForKey:@"username"] objectAtIndex:pos]];
            
            NSLog(@"post %@",post);
            
            NSData *data = [self  getDataFrom:post];
            
            if (data)
            {
                driverInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
                NSLog(@"json %@",driverInfo);
                if(driverInfo)
                {
                    infoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 160)];
                    infoView.tag=1;
                    infoView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.8];
                    [main addSubview:infoView];
                    AsyncImageView *userImage  = [[AsyncImageView alloc] init];
                    userImage.backgroundColor = [UIColor whiteColor];
                    userImage.contentMode = UIViewContentModeScaleAspectFill;
                    userImage.frame=CGRectMake(5, 5, 50, 50);
                    userImage.clipsToBounds = YES;
                    NSURL *tempURL=[NSURL URLWithString:[driverInfo objectForKey:@"proimage"]];
                    userImage.imageURL = tempURL;
                    tempURL=nil;
                    [infoView addSubview:userImage];
                    
                    UILabel *namelbl=[[UILabel alloc]init];
                    namelbl.frame=CGRectMake(60, 0, infoView.frame.size.width-110, 30);
                    namelbl.numberOfLines=0;
                    namelbl.text=[driverInfo objectForKey:@"username"];
                    namelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                    namelbl.textAlignment=NSTextAlignmentLeft;
                    namelbl.textColor=[UIColor whiteColor];
                    namelbl.backgroundColor=[UIColor clearColor];
                    [infoView addSubview:namelbl];
                    
                    UILabel *kmlbl=[[UILabel alloc]init];
                    kmlbl.frame=CGRectMake(60, 30, 150, 30);
                    kmlbl.numberOfLines=0;
                    kmlbl.text=[NSString stringWithFormat:@"Cost/km:Rs.%@",[driverInfo objectForKey:@"kmpercost"]];
                    kmlbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                    kmlbl.textAlignment=NSTextAlignmentLeft;
                    kmlbl.textColor=[UIColor whiteColor];
                    kmlbl.backgroundColor=[UIColor clearColor];
                    [infoView addSubview:kmlbl];
                    
                    UILabel *ratelbl=[[UILabel alloc]init];
                    ratelbl.frame=CGRectMake(200, 30, 120, 30);
                    ratelbl.numberOfLines=0;
                    ratelbl.text=[NSString stringWithFormat:@"Rating:%@/10",[driverInfo objectForKey:@"rating"]];
                    ratelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                    ratelbl.textAlignment=NSTextAlignmentLeft;
                    ratelbl.textColor=[UIColor whiteColor];
                    ratelbl.backgroundColor=[UIColor clearColor];
                    [infoView addSubview:ratelbl];
                    [self HideActivityIndicator];
                    
                    UIButton* pickbtn = [[UIButton alloc] init ];
                    [pickbtn setBackgroundImage:[UIImage imageNamed:@"stats-button.png"] forState:UIControlStateNormal];
                    pickbtn.tag=1;
                    [pickbtn addTarget:self action:@selector(driverbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
                    pickbtn.frame=CGRectMake(5 , 65, infoView.frame.size.width/2-10, 40);
                    [pickbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [pickbtn setTitle:@"Ask for Pickup" forState:UIControlStateNormal];
                    [pickbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:18]];
                    
                    [infoView addSubview: pickbtn];
                    
                    UIButton* detailbtn = [[UIButton alloc] init ];
                    [detailbtn setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateNormal];
                    detailbtn.tag=2;
                    [detailbtn addTarget:self action:@selector(driverbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
                    detailbtn.frame=CGRectMake(infoView.frame.size.width/2, 65, infoView.frame.size.width/2-5, 40);
                    [detailbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [detailbtn setTitle:@"Driver Details" forState:UIControlStateNormal];
                    [detailbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:18]];
                    
                    [infoView addSubview: detailbtn];
                    
                    UIButton* bargainButton = [[UIButton alloc] init ];
                    [bargainButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
                    [bargainButton addTarget:self action:@selector(broadcastbargain) forControlEvents:UIControlEventTouchUpInside];
                    bargainButton.frame=CGRectMake(5 , 110, infoView.frame.size.width-10, 40);
                    [bargainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [bargainButton setTitle:@"Broadcast a bargain request" forState:UIControlStateNormal];
                    [bargainButton.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:18]];
                    
                    [infoView addSubview: bargainButton];
                    
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Error in login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                
            }
            else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Eroor in Data Fetch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            
        }
        [self HideActivityIndicator];
    }
    [UIView animateWithDuration:0.7 animations:^{
        infoView.frame = CGRectMake(infoView.frame.origin.x,
                                    self.view.frame.size.height-infoView.frame.size.height,
                                    infoView.frame.size.width,
                                    infoView.frame.size.height);
    }];
}
-(void)broadcastbargain
{
    [self tapped];
    pickupView=nil;
    pickupView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150)];
    pickupView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.8];
    [pickupView setAlpha:0];
    pickupView.tag=2;
    [main addSubview:pickupView];
    
    UIImage *textField=[UIImage imageNamed:@"challenge_friend_input_field.png"];
    UIImageView *timeback = [[UIImageView alloc] initWithImage:textField];
    [pickupView addSubview:timeback];
    timeback.userInteractionEnabled = YES;
    
    time_fld=nil;
    time_fld = [[UITextField alloc]init];
    time_fld.tag=1000;
    time_fld.borderStyle = UITextBorderStyleNone;
    time_fld.placeholder = @"Pickup within";
    [time_fld setValue:[UIColor colorWithRed:100.0/255 green:101.0/255 blue:101.0/255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    time_fld.font=[UIFont fontWithName:@"CenturyGothic" size:16];
    [time_fld setTextColor:[UIColor whiteColor]];
    time_fld.textAlignment = NSTextAlignmentLeft;
    time_fld.keyboardType=UIKeyboardTypeNumberPad;
    time_fld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    time_fld.backgroundColor = [UIColor clearColor];
    time_fld.returnKeyType = UIReturnKeyNext;
    time_fld.delegate=self;
    
    timeback.frame=CGRectMake(40, 10, timeback.image.size.width/2, timeback.image.size.height/2);
    time_fld.frame=CGRectMake(45, 10, timeback.image.size.width/2-40, timeback.image.size.height/2);
    [pickupView addSubview:timeback];
    [pickupView addSubview:time_fld];
    
    UILabel *minutelbl=[[UILabel alloc]init];
    minutelbl.frame=CGRectMake(timeback.image.size.width/2-40, 10, 80, timeback.image.size.height/2);
    minutelbl.numberOfLines=0;
    minutelbl.text=@"minutes";
    minutelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
    minutelbl.textAlignment=NSTextAlignmentCenter;
    minutelbl.contentMode=UIControlContentVerticalAlignmentCenter;
    minutelbl.textColor=[UIColor whiteColor];
    minutelbl.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.7];
    [pickupView addSubview:minutelbl];
    
    
    
    UIImageView *costback = [[UIImageView alloc] initWithImage:textField];
    [pickupView addSubview:costback];
    costback.userInteractionEnabled = YES;
    
    cost_fld=nil;
    cost_fld = [[UITextField alloc]init];
    cost_fld.tag=1000;
    cost_fld.borderStyle = UITextBorderStyleNone;
    cost_fld.placeholder = @"Max Price";
    [cost_fld setValue:[UIColor colorWithRed:100.0/255 green:101.0/255 blue:101.0/255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    cost_fld.font=[UIFont fontWithName:@"CenturyGothic" size:16];
    [cost_fld setTextColor:[UIColor whiteColor]];
    cost_fld.textAlignment = NSTextAlignmentLeft;
    cost_fld.keyboardType=UIKeyboardTypeNumberPad;
    cost_fld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cost_fld.backgroundColor = [UIColor clearColor];
    cost_fld.returnKeyType = UIReturnKeyNext;
    cost_fld.delegate=self;
    
    costback.frame=CGRectMake(40, 50, costback.image.size.width/2, costback.image.size.height/2);
    cost_fld.frame=CGRectMake(45, 50, costback.image.size.width/2-40, costback.image.size.height/2);
    [pickupView addSubview:costback];
    [pickupView addSubview:cost_fld];
    
    UILabel *costlbl=[[UILabel alloc]init];
    costlbl.frame=CGRectMake(costback.image.size.width/2-40, 50, 80, costback.image.size.height/2);
    costlbl.numberOfLines=0;
    costlbl.text=@"Rupies";
    costlbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
    costlbl.textAlignment=NSTextAlignmentCenter;
    costlbl.contentMode=UIControlContentVerticalAlignmentCenter;
    costlbl.textColor=[UIColor whiteColor];
    costlbl.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.7];
    [pickupView addSubview:costlbl];
    
    UIButton* pickbtn = [[UIButton alloc] init ];
    [pickbtn setBackgroundImage:[UIImage imageNamed:@"stats-button.png"] forState:UIControlStateNormal];
    pickbtn.tag=1;
    [pickbtn addTarget:self action:@selector(pickbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
    pickbtn.frame=CGRectMake(5 , 100, pickupView.frame.size.width/2-10, 30);
    [pickbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [pickbtn setTitle:@"Bargain" forState:UIControlStateNormal];
    [pickbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
    
    [pickupView addSubview: pickbtn];
    
    UIButton* closebtn = [[UIButton alloc] init ];
    [closebtn setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateNormal];
    closebtn.tag=2;
    [closebtn addTarget:self action:@selector(pickbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
    closebtn.frame=CGRectMake(infoView.frame.size.width/2, 100, pickupView.frame.size.width/2-5, 30);
    [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closebtn setTitle:@"Not Now" forState:UIControlStateNormal];
    [closebtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
    [pickupView addSubview:closebtn];
    
    
    
    [UIView animateWithDuration:0.7 animations:^{
        [pickupView setAlpha:1];
    }];
    
}
-(void)driverbuttonaction:(id)sender
{
    if(((UIButton *)sender).tag==1)
    {
        [self tapped];
        pickupView=nil;
        pickupView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 100)];
        pickupView.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.8];
        [pickupView setAlpha:0];
        pickupView.tag=1;
        [main addSubview:pickupView];
        
        UIImage *textField=[UIImage imageNamed:@"challenge_friend_input_field.png"];
        UIImageView *keyback = [[UIImageView alloc] initWithImage:textField];
        [self.view addSubview:keyback];
        keyback.userInteractionEnabled = YES;
        
        time_fld=nil;
        time_fld = [[UITextField alloc]init];
        time_fld.tag=1000;
        time_fld.borderStyle = UITextBorderStyleNone;
        time_fld.placeholder = @"Pickup within";
        [time_fld setValue:[UIColor colorWithRed:100.0/255 green:101.0/255 blue:101.0/255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        time_fld.font=[UIFont fontWithName:@"CenturyGothic" size:16];
        [time_fld setTextColor:[UIColor whiteColor]];
        time_fld.textAlignment = NSTextAlignmentLeft;
        time_fld.keyboardType=UIKeyboardTypeNumberPad;
        time_fld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        time_fld.backgroundColor = [UIColor clearColor];
        time_fld.returnKeyType = UIReturnKeyNext;
        time_fld.delegate=self;
        
        keyback.frame=CGRectMake(40, 10, keyback.image.size.width/2, keyback.image.size.height/2);
        time_fld.frame=CGRectMake(45, 10, keyback.image.size.width/2-40, keyback.image.size.height/2);
        
        UILabel *minutelbl=[[UILabel alloc]init];
        minutelbl.frame=CGRectMake(keyback.image.size.width/2-40, 10, 80, keyback.image.size.height/2);
        minutelbl.numberOfLines=0;
        minutelbl.text=@"minutes";
        minutelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
        minutelbl.textAlignment=NSTextAlignmentCenter;
        minutelbl.contentMode=UIControlContentVerticalAlignmentCenter;
        minutelbl.textColor=[UIColor whiteColor];
        minutelbl.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.7];
        [pickupView addSubview:minutelbl];
        
        UIButton* pickbtn = [[UIButton alloc] init ];
        [pickbtn setBackgroundImage:[UIImage imageNamed:@"stats-button.png"] forState:UIControlStateNormal];
        pickbtn.tag=1;
        [pickbtn addTarget:self action:@selector(pickbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
        pickbtn.frame=CGRectMake(5 , 60, pickupView.frame.size.width/2-10, 30);
        [pickbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pickbtn setTitle:@"Pick Me" forState:UIControlStateNormal];
        [pickbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
        
        [pickupView addSubview: pickbtn];
        
        UIButton* closebtn = [[UIButton alloc] init ];
        [closebtn setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateNormal];
        closebtn.tag=2;
        [closebtn addTarget:self action:@selector(pickbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
        closebtn.frame=CGRectMake(infoView.frame.size.width/2, 60, pickupView.frame.size.width/2-5, 30);
        [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closebtn setTitle:@"Not Now" forState:UIControlStateNormal];
        [closebtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
        [pickupView addSubview:closebtn];
        
        [pickupView addSubview:keyback];
        [pickupView addSubview:time_fld];
        
        [UIView animateWithDuration:0.7 animations:^{
            [pickupView setAlpha:1];
        }];
        
    }
    else
    {
        ProfileDriverViewController *profile=[[ProfileDriverViewController alloc]init];
        profile.driverInfo=driverInfo;
        profile.isCustomer=YES;
        profile.user_Coordinate=mycoords;
        [self.navigationController pushViewController:profile animated:YES];
        profile=nil;
    }
}

-(void)pickbuttonaction:(id)sender
{
    if(((UIButton *)sender).tag==1)
    {
        [[soundManager shared] buttonSound];
        UIAlertView *alert=[[UIAlertView alloc]init];
        if(pickupView.tag==1)
        {
            if([time_fld.text isEqualToString:@""]) {
                [alert setTitle:@"Warning"];
                [alert setMessage:@"No Pickup time specified"];
                [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
                [alert show];
                [time_fld becomeFirstResponder];
                return;
            }
            else{
                NSLog(@"Send Ask pickup api");
                Reachability *reach = [Reachability reachabilityForInternetConnection];
                
                NetworkStatus netStatus = [reach currentReachabilityStatus];
                
                if (netStatus == NotReachable)
                {
                    [self HideActivityIndicator];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                else
                {
                    NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeup&senderid=%@&receiverid=%@&uloclong=%f&uloclat=%f&expiretime=%@&starttime=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"],[driverInfo objectForKey:@"fbid"],mycoords.longitude,mycoords.latitude,@"",time_fld.text];
                    
                    NSLog(@"post %@",post);
                    
                    NSData *data = [self  getDataFrom:post];
                    
                    if (data)
                    {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
                        NSLog(@"json %@",json);
                        if(json)
                        {
                            NSLog(@"Data Send Successfully");
                            [self HideActivityIndicator];
                            
                        }
                        else
                        {
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Error in data fetch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                        }
                        
                    }
                    else{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Eroor in Data Fetch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
                [self HideActivityIndicator];
                isKeyboardVisible=FALSE;
                [self tapped];
            }
        }
        else{
            if([time_fld.text isEqualToString:@""])
            {
                [alert setTitle:@"Warning"];
                [alert setMessage:@"No pickup time specified"];
                [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
                [alert show];
                [time_fld becomeFirstResponder];
                return;
            }
            else if([cost_fld.text isEqualToString:@""])
            {
                [alert setTitle:@"Warning"];
                [alert setMessage:@"No maximum cost specified"];
                [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
                [alert show];
                [cost_fld becomeFirstResponder];
                return;
            }
            else{
                NSLog(@"Broadcast pickup api");
                NSLog(@"Send Ask pickup api");
                Reachability *reach = [Reachability reachabilityForInternetConnection];
                
                NetworkStatus netStatus = [reach currentReachabilityStatus];
                
                if (netStatus == NotReachable)
                {
                    [self HideActivityIndicator];
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"No internet connection available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                else
                {
                    NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=Bargain&senderid=%@&uloclong=%f&uloclat=%f&starttime=%@&maxprice=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"],mycoords.longitude,mycoords.latitude,time_fld.text,cost_fld.text];
                    
                    NSLog(@"post %@",post);
                    
                    NSData *data = [self  getDataFrom:post];
                    
                    if (data)
                    {
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
                        NSLog(@"json %@",json);
                        if(json)
                        {
                            NSLog(@"Data Send Successfully");
                            [self HideActivityIndicator];
                            
                        }
                        else
                        {
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Error in data fetch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [alert show];
                        }
                        
                    }
                    else{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failed" message:@"Eroor in Data Fetch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
                [self HideActivityIndicator];
                isKeyboardVisible=FALSE;
                [self tapped];
            }
        }
    }
    else
    {
        NSLog(@"Not now");
        isKeyboardVisible=FALSE;
        [self tapped];
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"Clicked");
    [self openAnnotation];
}
- (void)openAnnotation
{
    
}
- (NSData *) getDataFrom:(NSString *)url{
    
    NSString *properData = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"GET"];
    
    [request setURL:[NSURL URLWithString:properData]];
    
    NSError *error = [[NSError alloc] init];
    
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        return nil;
        
    }
    
    return oResponseData;
    
    
}


-(void)homeButtonAction {
    if(flag)
    {
        [[sidemenu shared]loadView:self withView:main];
        flag=FALSE;
    }
    else{
        [[sidemenu shared]removeView:main];
        flag=TRUE;
    }
}
- (void)ShowActivityIndicatorWithTitle:(NSString *)Title
{
    
    [SVProgressHUD showWithStatus:Title maskType:SVProgressHUDMaskTypeGradient];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    
}
- (void)HideActivityIndicator
{
    [SVProgressHUD dismiss];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
