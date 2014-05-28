//
//  driverThreadDetails.m
//  TaxiFyd Project
//
//  Created by Click Labs on 5/3/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "driverThreadDetails.h"
#import "DriverVC.h"
#import "Navigation.h"
#import "sidemenu.h"
#import "AsyncImageView.h"
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"
NSString *userImage;

@interface driverThreadDetails ()
{
    UIScrollView *main;
    NSMutableArray *InformationArray;
    int user_type;
    UIImageView *pup;
    UITextField *uNametextField;
    UITextField *uBid;
    UITextField *uprice;
    BOOL flag;
    UITextField *activeField;
    
}
@property (nonatomic, strong) MKMapView *mapView;
@end

@implementation driverThreadDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    flag=TRUE;
    main=[[UIScrollView alloc]init];
    main.backgroundColor=[UIColor blackColor];
    main.scrollEnabled=YES;
    main.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [main setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:main];
    
    Navigation *nav=[[Navigation alloc]init];
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    navBar=[nav addNavigation:@"PICKUP REQUEST" withView:main];
    
    UIButton* homeButton = [[UIButton alloc] init ];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    homeButton.frame=CGRectMake(5 , 0, 50, 50);
    [navBar addSubview:homeButton];
    [main addSubview: navBar];
    
   
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
    
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
        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeupone&id=%d",_id];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            InformationArray=[json objectForKey:@"DriverList"] ;
            if(json)
            {
                NSLog(@"Login Successful");
                [self HideActivityIndicator];
                
                
                    NSString *postsprofile =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBuserID"]];
                    
                    NSData *datasprofile = [self  getDataFrom:postsprofile];
                    
                        NSDictionary *jsonsprofile = [NSJSONSerialization JSONObjectWithData:datasprofile options:NSJSONReadingMutableLeaves error:Nil];
                        
                
                    
                    {
                        NSString *posts =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[json valueForKey:@"senderid"]];
                        
                        NSData *datas = [self  getDataFrom:posts];
                        
                        if (datas)
                        {
                            NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:Nil];
                            NSLog(@"json %@",jsons);
                            if(json)
                            {
                                CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[json valueForKey:@"uloclat"] floatValue] longitude:[[json valueForKey:@"uloclong"] floatValue]];
                                
                                CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[jsonsprofile objectForKey:@"lastLlat"] floatValue] longitude:[[jsonsprofile objectForKey:@"lastLlong"] floatValue]];
                                
                                CLLocationDistance distance = [locA distanceFromLocation:locB]/1000;
                                
                                
                                
                                
                                UIView *popup=[[UIView alloc]initWithFrame:CGRectMake(0, 55, 320, 430)];
                                popup.backgroundColor=[UIColor blackColor];
                                
                                
                                [main addSubview:popup];
                                
                                
                                
                                
                                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, popup.frame.size.width,  430)];
                                [self showPoint:CLLocationCoordinate2DMake([[json valueForKey:@"uloclat"] floatValue],[[json valueForKey:@"uloclong"] floatValue]) withType:1];
                                
                                [self showPoint:CLLocationCoordinate2DMake([[jsonsprofile objectForKey:@"lastLlat"] floatValue], [[jsonsprofile objectForKey:@"lastLlong"] floatValue]) withType:3];
                                self.mapView.delegate = self;
                                
                                UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                [signupButton addTarget:self
                                                 action:@selector(confirmClick)
                                       forControlEvents:UIControlEventTouchUpInside];
                                [signupButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
                                [signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                signupButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                                
                                [signupButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
                                [signupButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];

                                
                                signupButton.frame = CGRectMake(10, 380, 145, 41);
                                [_mapView addSubview:signupButton];
                                
                                if([[json objectForKey:@"type"] isEqualToString:@"Bargain"]){

                                UIButton *specifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                [specifyButton addTarget:self
                                                  action:@selector(specifyClick:)
                                       forControlEvents:UIControlEventTouchUpInside];
                                [specifyButton setTitle:@"SPECIFY YOUR BID" forState:UIControlStateNormal];
                                [specifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                specifyButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                                
                                [specifyButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
                                [specifyButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
                                specifyButton.frame = CGRectMake(10, 335, 300, 41);
                                [_mapView addSubview:specifyButton];
                                }
                                
                                
                                UIButton *rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                [rejectButton addTarget:self
                                                 action:@selector(rejectClick)
                                       forControlEvents:UIControlEventTouchUpInside];
                                [rejectButton setTitle:@"REJECT" forState:UIControlStateNormal];
                                [rejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                rejectButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                                
                                [rejectButton setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateNormal];
                                [rejectButton setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateHighlighted];
                                
                                rejectButton.frame = CGRectMake(165, 380, 145, 41);
                                [_mapView addSubview:rejectButton];
                                
                                
                                
                                UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 00, 320, 105)];
                                v.backgroundColor=[UIColor clearColor];
                                
                                UIImageView *backview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 105)];
                                backview.image=[UIImage imageNamed:@"white-rectangle-base.png"];
                                [v addSubview:backview];

                                
                                
                                AsyncImageView *userImage  = [[AsyncImageView alloc] initWithFrame:CGRectMake(320-80, 10, 70, 70)];
                                userImage.backgroundColor = [UIColor whiteColor];
                                userImage.contentMode = UIViewContentModeScaleAspectFill;
                                userImage.clipsToBounds = YES;
                                userImage.layer.cornerRadius=2;
                                NSURL *tempURL=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"image_url"]];
                                userImage.imageURL = tempURL;
                                tempURL=nil;
                                
                                //shadow part
                                userImage.layer.shadowColor = [UIColor redColor].CGColor;
                                userImage.layer.shadowOffset = CGSizeMake(0, 10);
                                userImage.layer.shadowOpacity = 1;
                                userImage.layer.shadowRadius = 5.0;
                                //white border part
                                [userImage.layer setBorderColor: [[UIColor blackColor] CGColor]];
                                [userImage.layer setBorderWidth: 1.0];
                                [v addSubview:userImage];

                                
                                [_mapView addSubview:v];
                                
                                
                                {
                                    UILabel *titlelbl=[[UILabel alloc]init];
                                    //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                                    titlelbl.numberOfLines = 0;
                                    titlelbl.text=[NSString stringWithFormat:@"%@",[jsons objectForKey:@"username"]];
                                    //                            titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
                                    titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                                    
                                    titlelbl.textColor=[UIColor blackColor];
                                    titlelbl.backgroundColor=[UIColor clearColor];
                                    titlelbl.frame=CGRectMake(10, 1, 200, 30);
                                    [v addSubview:titlelbl];
                                }
                                
                                {
                                    UILabel *titlelbl=[[UILabel alloc]init];
                                    //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                                    titlelbl.numberOfLines = 0;
                                    if([[json objectForKey:@"type"] isEqualToString:@"Bargain"]){
                                       titlelbl.text=[NSString stringWithFormat:@"%@ Rs/km",[json valueForKey:@"maxprice"]];
                                    }else{
                                    titlelbl.text=[NSString stringWithFormat:@"Within %@ minute",[json valueForKey:@"starttime"]];
                                    }
                                    
                                    //                            titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
                                    titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:14];
                                    
                                    titlelbl.textColor=[UIColor blackColor];
                                    titlelbl.backgroundColor=[UIColor clearColor];
                                    titlelbl.frame=CGRectMake(10, 28, 200, 30);
                                    [v addSubview:titlelbl];
                                }
                                {
                                    UIImageView *umv=[[UIImageView alloc]initWithFrame:CGRectMake(10, 64, 15, 15)];
                                    umv.image=[UIImage imageNamed:@"location-icon.png"];
                                    [v addSubview:umv];
                                    UILabel *titlelbl=[[UILabel alloc]init];
                                    //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                                    titlelbl.numberOfLines = 0;
                                    titlelbl.text=[NSString stringWithFormat:@"%.2f from Here",distance];
                                    //                            titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
                                    titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:14];
                                    
                                    titlelbl.textColor=[UIColor blackColor];
                                    titlelbl.backgroundColor=[UIColor clearColor];
                                    titlelbl.frame=CGRectMake(30, 56, 200, 30);
                                    [v addSubview:titlelbl];
                                }

                                
                                
//                                UILabel *titlelbl=[[UILabel alloc]init];
//                                
//                                titlelbl.numberOfLines = 0;
//                                 titlelbl.text=[NSString stringWithFormat:@"%@",[jsons objectForKey:@"username"]] ;
////                                titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
//                                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:15];
//                                
//                                titlelbl.textColor=[UIColor blackColor];
//                                titlelbl.backgroundColor=[UIColor clearColor];
//                                titlelbl.frame=CGRectMake(90, -20, 220, 80);
//                                [v addSubview:titlelbl];
//                                
//                                UILabel *leftlbl=[[UILabel alloc]init];
//                                
//                                leftlbl.numberOfLines = 0;
//                                leftlbl.text=[NSString stringWithFormat:@"%.2f KM from you",distance] ;
//                                //                                titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
//                                leftlbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:10];
//                                
//                                leftlbl.textColor=[UIColor blackColor];
//                                leftlbl.backgroundColor=[UIColor clearColor];
//                                leftlbl.frame=CGRectMake(90, 5, 220, 80);
//                                [v addSubview:leftlbl];
//                                
//                                UILabel *timeleftlbl=[[UILabel alloc]init];
//                                
//                                timeleftlbl.numberOfLines = 0;
//                                timeleftlbl.text=[NSString stringWithFormat:@"%@ mnt Left",[json objectForKey:@"expiretime"]] ;
//                                //                                titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
//                                timeleftlbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:10];
//                                
//                                timeleftlbl.textColor=[UIColor blackColor];
//                                timeleftlbl.backgroundColor=[UIColor clearColor];
//                                timeleftlbl.frame=CGRectMake(190, 30, 220, 80);
//                                [v addSubview:timeleftlbl];
//                                
//                                UILabel *priceperhrlbl=[[UILabel alloc]init];
//                                
//                                priceperhrlbl.numberOfLines = 0;
//                                priceperhrlbl.text=[NSString stringWithFormat:@"%@/hr",[json objectForKey:@"maxprice"]] ;
//                                //                                titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
//                                priceperhrlbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:10];
//                                
//                                priceperhrlbl.textColor=[UIColor blackColor];
//                                priceperhrlbl.backgroundColor=[UIColor clearColor];
//                                priceperhrlbl.frame=CGRectMake(90, 30, 220, 80);
//                                [v addSubview:priceperhrlbl];

                                
                                pup=[[UIImageView alloc]initWithFrame:CGRectMake(20, 165, 280, 170)];
                                pup.image=[UIImage imageNamed:@"registration_square.png"];                                pup.hidden=YES;
                                pup.userInteractionEnabled=YES;
                                [main addSubview:pup];
                                
                                UILabel *backbl=[[UILabel alloc]init];
                                
                                backbl.numberOfLines = 0;
                                backbl.text=[NSString stringWithFormat:@"I WILL BE THERE IN"] ;
                                //                                titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
                                backbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:15];
                                
                                backbl.textColor=[UIColor blackColor];
                                backbl.backgroundColor=[UIColor clearColor];
                                backbl.frame=CGRectMake(20, 10, 220, 20);
                                [pup addSubview:backbl];
                                
                                UILabel *mntsbl=[[UILabel alloc]init];
                                
                                mntsbl.numberOfLines = 0;
                                mntsbl.text=[NSString stringWithFormat:@"MINUTES"] ;
                                //                                titlelbl.text=[NSString stringWithFormat:@"%@ asked for pick up. He is %.2f KM from here",[jsons objectForKey:@"username"], distance] ;
                                mntsbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:15];
                                
                                mntsbl.textColor=[UIColor blackColor];
                                mntsbl.backgroundColor=[UIColor clearColor];
                                mntsbl.frame=CGRectMake(20, 75, 220, 20);
                                [pup addSubview:mntsbl];
                                
                                
                                
                                UIImageView *nameBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 35, 220, 30)];
                                nameBackGroundView.image = [UIImage imageNamed:@"input-text-square.png"];
                                nameBackGroundView.userInteractionEnabled = YES;
                                [pup addSubview:nameBackGroundView];
                                
                                uNametextField = [[UITextField alloc] initWithFrame:CGRectMake(22, 37, 200, 30)];
                                uNametextField.delegate=self;
                                uNametextField.placeholder = @"MINUTE FORMAT";
                                [uNametextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                                uNametextField.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
                                uNametextField.borderStyle = UITextBorderStyleNone;
                                uNametextField.textAlignment = NSTextAlignmentLeft;
                                uNametextField.backgroundColor = [UIColor clearColor];
                                [uNametextField setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
                                uNametextField.returnKeyType = UIReturnKeyNext;
                                uNametextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                               
                                [pup addSubview:uNametextField];


                                
                                UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                [loginButton addTarget:self
                                                action:@selector(aceptClick)
                                      forControlEvents:UIControlEventTouchUpInside];
                                
                                [loginButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
                                [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                loginButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
                                
                                [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
                                [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
                                loginButton.frame = CGRectMake(15, 120, 120, 35);
                                loginButton.backgroundColor=[UIColor whiteColor];
                                [pup addSubview:loginButton];
                                
                                
                                UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                [closeButton addTarget:self
                                                action:@selector(closeClick)
                                      forControlEvents:UIControlEventTouchUpInside];
                                
                                [closeButton setTitle:@"CANCEL" forState:UIControlStateNormal];
                                [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                closeButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
                                
                                [closeButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
                                [closeButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
                                closeButton.frame = CGRectMake(140, 120, 120, 35);
                                closeButton.backgroundColor=[UIColor whiteColor];
                                [pup addSubview:closeButton];
                                
                                UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
                                
                                [main addGestureRecognizer:tapScroll];
                                
                                
                                [popup addSubview:self.mapView];
                            }
                        }
                    }
                
                // }
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
-(void)closeClick{
    pup.hidden=YES;
}
-(void)confirmClick{
    pup.hidden=NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[SVAnnotation class]]) {
        static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(pulsingView == nil) {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            //pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            if([((SVAnnotation *)annotation).PinType isEqualToString:@"user"])
                pulsingView.image=[UIImage imageNamed:@"homemap.png"];
            else if([((SVAnnotation *)annotation).PinType isEqualToString:@"driver"])
                pulsingView.image=[UIImage imageNamed:@"car.png"];
            else
                pulsingView.image=[UIImage imageNamed:@"car.png"];
            pulsingView.canShowCallout = YES;
            pulsingView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
		
		return pulsingView;
    }
    
    return nil;
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
-(void)showPoint:(CLLocationCoordinate2D)coordinate withType:(int)type
{
    
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.2, 0.2));
    [self.mapView setRegion:region animated:NO];
    
    
    SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:coordinate];
    annotation.title = @"Current Location";
    annotation.subtitle = @"Montréal, QC";
    if(type==1)
        annotation.PinType=@"user";
    else
        annotation.PinType=@"driver";
    
    [self.mapView addAnnotation:annotation];
}
-(void)aceptClick{
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
        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeupedit&id=%d&status=Accept&mback=%@",_id,uNametextField.text];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            InformationArray=[json objectForKey:@"DriverList"] ;
            if(json)
            {
                NSLog(@"Login Successful");
                [self HideActivityIndicator];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Be on Time" message:@"Thank you for Accepting." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                pup.hidden=YES;
            
            }
        }
    
    
    // }
}


[self HideActivityIndicator];


}

-(void)rejectClick{
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
        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeupedit&id=%d&status=Reject&mback=Reject",_id];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            InformationArray=[json objectForKey:@"DriverList"] ;
            if(json)
            {
                NSLog(@"Login Successful");
                [self HideActivityIndicator];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success!" message:@"Reject Successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                pup.hidden=YES;
                
            }
        }
        
        
        // }
    }
    
    
    [self HideActivityIndicator];
    
    
}
-(void)specifyClick:(id)sender{
    UIButton *vc=(UIButton*)sender;
     UIView *v=[[UIView alloc]init];
    v.alpha=0.0;
    
    UILabel *titlelbl=[[UILabel alloc]init];
    
    //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
    titlelbl.numberOfLines = 0;
    titlelbl.text=[NSString stringWithFormat:@"Specify"] ;
    titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
    
    titlelbl.textColor=[UIColor whiteColor];
    titlelbl.backgroundColor=[UIColor clearColor];
    titlelbl.frame=CGRectMake(5, 1, 70, 30);
    [v addSubview:titlelbl];
    
    
    
    uBid = [[UITextField alloc] initWithFrame:CGRectMake(65, 00, 84, 40)];
    uBid.delegate=self;
    uBid.placeholder = @"Bid/km";
    [uBid setValue:[UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    uBid.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
    uBid.textAlignment = NSTextAlignmentLeft;
    uBid.backgroundColor = [UIColor whiteColor];
    [uBid setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
    uBid.returnKeyType = UIReturnKeyNext;
    uBid.keyboardType=UIKeyboardTypeNumberPad;
    uBid.textAlignment=NSTextAlignmentCenter;;

    uBid.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    [v addSubview:uBid];
 
    uprice = [[UITextField alloc] initWithFrame:CGRectMake(150, 00, 120, 40)];
    uprice.delegate=self;
    uprice.placeholder = @"Arrival time";
    [uprice setValue:[UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    uprice.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
    uprice.textAlignment = NSTextAlignmentLeft;
    uprice.backgroundColor = [UIColor whiteColor];
    [uprice setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
    uprice.returnKeyType = UIReturnKeyDone;
     uprice.keyboardType=UIKeyboardTypeNumberPad;
    uprice.autocapitalizationType = UITextAutocapitalizationTypeWords;
    uprice.textAlignment=NSTextAlignmentCenter;;
    
    
    
    [v addSubview:uprice];
    
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton addTarget:self
                     action:@selector(okclick)
           forControlEvents:UIControlEventTouchUpInside];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
    
    [okButton setBackgroundImage:[UIImage imageNamed:@"license_car_type_button.png"] forState:UIControlStateNormal];
    [okButton setBackgroundImage:[UIImage imageNamed:@"license_car_type_button.png"] forState:UIControlStateHighlighted];
    
    okButton.frame = CGRectMake(261, 0, 56, 40);
    [v addSubview:okButton];
    
    v.Frame=CGRectMake(0, 89, 320, 40);
    v.backgroundColor=[UIColor grayColor];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2];
    [UIView  setAnimationDelegate:self];
    
   //vc.frame = CGRectMake(10, 290, 300, 41);
    
   v.alpha=1.0;
    v.hidden=NO;
    [v.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [v.layer setBorderWidth: 1.0];
    [_mapView addSubview:v];
    [UIView commitAnimations];
    
    UIView *sep=[[UIView alloc]initWithFrame:CGRectMake(148, 0, 1, 40)];
    sep.backgroundColor=[UIColor blackColor];
    [v addSubview:sep];
    
   
}
- (void)tapped

{
    
    [uNametextField resignFirstResponder];
    [uBid resignFirstResponder];
    [uprice resignFirstResponder];;
    
    
    
    
}
- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    
}



- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    main.contentInset = contentInsets;
    
    main.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your app might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    
    
    CGPoint field_size=activeField.frame.origin;
    
    field_size.y+=activeField.frame.size.height;
    
    
    
    if (!CGRectContainsPoint(aRect, field_size) ) {
        
        [main scrollRectToVisible:activeField.frame animated:YES];
        
    }
    
    info=nil;
    
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    main.contentInset = contentInsets;
    
    main.scrollIndicatorInsets = contentInsets;
    
}





- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField

{
    
    activeField = textField;
    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    NSInteger nextTag = textField.tag + 1;
    
    // Try to find next responder
    
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        
        // Found next responder, so set it.
        
        activeField =((UITextField *)[textField.superview viewWithTag:nextTag]);
        
        [nextResponder becomeFirstResponder];
        
    } else {
        
        // Not found, so remove keyboard.
        
        [textField resignFirstResponder];
        
    }
    
    return NO; // We do not want UITextField to insert line-breaks.
    
}

-(void) textFieldDidEndEditing:(UITextField *)textField

{
    
    activeField = nil;
    
}
-(void)okclick{
    UIAlertView *alert;
    if([uBid.text isEqualToString:@""]) {
        alert=nil;
        alert=[[UIAlertView alloc]init];
        [alert setTitle:@"Warning"];
        [alert setMessage:@"No bid specified"];
        [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
        [alert show];
        [uBid becomeFirstResponder];
        return;
    }
    else if([uprice.text isEqualToString:@""]) {
        alert=nil;
        alert=[[UIAlertView alloc]init];
        [alert setTitle:@"Warning"];
        [alert setMessage:@"No Price specified"];
        [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
        [alert show];
        [uprice becomeFirstResponder];
        return;
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
        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeupedit&id=%d&status=Bid&mback=%@&bid=%@",_id,uprice.text,uBid.text];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            InformationArray=[json objectForKey:@"DriverList"] ;
            if(json)
            {
                NSLog(@"Login Successful");
                [self HideActivityIndicator];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Biding Done" message:@"Bid Successfully Done.Check status in Homepage" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
                [self.view endEditing:YES];
                
                pup.hidden=YES;
                
            }
        }
        
        
        // }
    }
    }
    
    [self HideActivityIndicator];
    
    
}


@end
