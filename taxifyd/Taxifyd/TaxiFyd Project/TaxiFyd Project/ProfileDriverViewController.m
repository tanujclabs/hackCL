//
//  ProfileDriverViewController.m
//  TaxiFyd Project
//
//  Created by Click Labs on 5/3/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "ProfileDriverViewController.h"
#import "Navigation.h"
#import "sidemenu.h"
#import "AsyncImageView.h"
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"
#import "TaxifydproViewController.h"

@interface ProfileDriverViewController ()
{
    UIScrollView *main;
    BOOL flag;
    NSDictionary *driverProfile;
    UITextField *time_fld;
    UITapGestureRecognizer *tap;
    UIImageView *popUp;
    NSString *ImageURL;

}
@end

@implementation ProfileDriverViewController

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
    flag=TRUE;
    main=[[UIScrollView alloc]init];
    main.backgroundColor=[UIColor whiteColor];
    main.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [main setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:main];
    Navigation *nav=[[Navigation alloc]init];
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    if(self.isCustomer)
        navBar=[nav addNavigation:@"Driver Detail" withView:main];
    else
    {
        navBar=[nav addNavigation:@"Profile" withView:main];
        
        UIButton* homeButtons = [[UIButton alloc] init ];
        [homeButtons setBackgroundImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
        [homeButtons addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
        homeButtons.frame=CGRectMake(270 , 20, 30, 10);
        [navBar addSubview:homeButtons];
    }
    UIButton* homeButton = [[UIButton alloc] init ];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    homeButton.frame=CGRectMake(5 , 0, 50, 50);
    [navBar addSubview:homeButton];
    
    
    [main addSubview: navBar];
    if(self.driverInfo)
    {
        ImageURL = [self.driverInfo objectForKey:@"proimage"];
        NSLog(@"urlString=%@",ImageURL);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[self.driverInfo objectForKey:@"fbid"]];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            driverProfile = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",driverProfile);
        }
        UIView *vc=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 480)];
        vc.backgroundColor=vc.backgroundColor=[UIColor colorWithRed:61.0f/255.0f green:81.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        [main addSubview:vc];
        
        UIView *vcstar=[[UIView alloc]initWithFrame:CGRectMake(0, 170, 320, 50)];
        vcstar.backgroundColor=[UIColor colorWithRed:30.0f/255.0f green:39.0f/255.0f blue:53.0f/255.0f alpha:0.99];
        [vc addSubview:vcstar];
        
        
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"%@",[self.driverInfo objectForKey:@"rating"]] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.textAlignment=NSTextAlignmentCenter;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(0, 20, 320, 40);
            [vcstar addSubview:titlelbl];
        }
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"Rating"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.textAlignment=NSTextAlignmentCenter;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(5, 0, 320, 40);
            [vcstar addSubview:titlelbl];
        }
        
        UIImageView *umgvw=[[UIImageView alloc]initWithFrame:CGRectMake(120, 10, 15, 15)];
        umgvw.image=[UIImage imageNamed:@"rating-start.png"];
        [vcstar addSubview:umgvw];
        
        
        
        UIView *proimg=[[UIView alloc]initWithFrame:CGRectMake(110, 55, 100, 100)];
        proimg.backgroundColor=[UIColor colorWithRed:47.0f/255.0f green:37.0f/255.0f blue:33.0f/255.0f alpha:0.5];
        
        proimg.layer.cornerRadius = 50;
        [main addSubview:proimg];
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"%@",[self.driverInfo objectForKey:@"username"]] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:17];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.textAlignment=NSTextAlignmentCenter;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(0, 110, 320, 15);
            [vc addSubview:titlelbl];
        }
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"%@",[driverProfile objectForKey:@"emailid"]] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:14];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.textAlignment=NSTextAlignmentCenter;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(0, 130, 320, 15);
            [vc addSubview:titlelbl];
        }
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"%@",[driverProfile objectForKey:@"phno"]] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:14];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.textAlignment=NSTextAlignmentCenter;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(0, 150, 320, 15);
            [vc addSubview:titlelbl];
        }
        
        
        
        
        AsyncImageView *userImage  = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
        userImage.backgroundColor = [UIColor whiteColor];
        userImage.contentMode = UIViewContentModeScaleAspectFill;
        userImage.clipsToBounds = YES;
        userImage.layer.cornerRadius=45;
        
        NSURL *tempURL=[NSURL URLWithString:ImageURL];
        userImage.imageURL = tempURL;
        tempURL=nil;
        [proimg addSubview:userImage];
        
        
        //++++++++++++++++++++++++++++++++++++++
        
        {  UIButton *askButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [askButton addTarget:self
                            action:@selector(askClick)
                  forControlEvents:UIControlEventTouchUpInside];
            [askButton setTitle:@"ASK FOR PICKUP" forState:UIControlStateNormal];
            [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            askButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
            
            [askButton setBackgroundImage:[UIImage imageNamed:@"ask-for-pick-up"] forState:UIControlStateNormal];
            [askButton setBackgroundImage:[UIImage imageNamed:@"ask-for-pick-up"] forState:UIControlStateHighlighted];
            
            askButton.frame = CGRectMake(15, 225, 140, 41);
            if(self.isLog==-10)
                askButton.userInteractionEnabled=NO;
            [vc addSubview:askButton];
        }
        
        {  UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [callButton addTarget:self
                            action:@selector(callClick)
                  forControlEvents:UIControlEventTouchUpInside];
            
            [callButton setTitle:@"CALL" forState:UIControlStateNormal];
            [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            callButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
            callButton.titleLabel.text=[callButton.titleLabel.text uppercaseString];
            [callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
            [callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];
            callButton.frame = CGRectMake(165, 225, 140, 41);
            [vc addSubview:callButton];
        }
        {
            UIView *uv=[[UIView alloc]initWithFrame:CGRectMake(10, 270, 300, 1)];
            uv.backgroundColor=[UIColor colorWithRed:43.0f/255.0f green:43.0f/255.0f blue:43.0f/255.0f alpha:0.3];
            [vc addSubview:uv];
            
        }
        
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"License"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(15, 330, 120, 20);
            [main addSubview:titlelbl];
            
            UIImage *licenceback=[UIImage imageNamed:@"license_car_type_button.png"];
            UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(15, 305, licenceback.size.width/2, licenceback.size.height/2)];
            licence.userInteractionEnabled=NO;
            [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
            [licence setTitle:[self.driverInfo objectForKey:@"licenseno"] forState:UIControlStateNormal];
            [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            [vc addSubview:licence];
            
        }
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"Car Type"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(200, 330, 120, 20);
            [main addSubview:titlelbl];
            
            UIImage *licenceback=[UIImage imageNamed:@"license_car_type_button.png"];
            UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(180, 305, licenceback.size.width/2, licenceback.size.height/2)];
            licence.userInteractionEnabled=NO;
            [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
            [licence setTitle:[self.driverInfo objectForKey:@"cartype"] forState:UIControlStateNormal];
            [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            [vc addSubview:licence];
            
        }
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"Status"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(15, 400, 120, 20);
            [main addSubview:titlelbl];
            
            UIImage *licenceback=[UIImage imageNamed:@"stats-button.png"];
            UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(15, 375,licenceback.size.width/2, licenceback.size.height/2)];
            licence.userInteractionEnabled=NO;
            [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
            [licence setTitle:[self.driverInfo objectForKey:@"status"] forState:UIControlStateNormal];
            [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            [vc addSubview:licence];
            
        }
        
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"Cost/km"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            titlelbl.textColor=[UIColor whiteColor];
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(180, 400, 120, 20);
            [main addSubview:titlelbl];
            
            UIImage *licenceback=[UIImage imageNamed:@"cost-per-km-button.png"];
            UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(180, 375, licenceback.size.width/2, licenceback.size.height/2)];
            licence.userInteractionEnabled=NO;
            [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
            [licence setTitle:[self.driverInfo objectForKey:@"kmpercost"] forState:UIControlStateNormal];
            [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            [vc addSubview:licence];
            
        }
        
//        UIButton* homeButton = [[UIButton alloc] init ];
//        [homeButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
//        [homeButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        homeButton.frame=CGRectMake(-5 , 0, 50, 50);
//        
//        [main addSubview: homeButton];
        NSLog(@"Login Successful");
    }
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [main addGestureRecognizer:tap];
}
- (void)tapped
{
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    if(!self.isCustomer)
    {
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
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
        ImageURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",ImageURL);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            self.driverInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",self.driverInfo);
            
            NSString *posts =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getdriverpro&fbid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
            
            NSLog(@"post %@",posts);
            
            NSData *datas = [self  getDataFrom:posts];
            
            NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",jsons);
            
            UIView *vc=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 480)];
            vc.backgroundColor=vc.backgroundColor=[UIColor colorWithRed:61.0f/255.0f green:81.0f/255.0f blue:102.0f/255.0f alpha:1.0];
            [main addSubview:vc];
            
            UIView *vcstar=[[UIView alloc]initWithFrame:CGRectMake(0, 170, 320, 50)];
            vcstar.backgroundColor=[UIColor colorWithRed:30.0f/255.0f green:39.0f/255.0f blue:53.0f/255.0f alpha:0.99];
            [vc addSubview:vcstar];
            
            
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"%@",[jsons objectForKey:@"rating"]] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.textAlignment=NSTextAlignmentCenter;
                titlelbl.backgroundColor=[UIColor clearColor];
                titlelbl.frame=CGRectMake(0, 20, 320, 40);
                [vcstar addSubview:titlelbl];
            }
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"Rating"] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:16];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.textAlignment=NSTextAlignmentCenter;
                titlelbl.backgroundColor=[UIColor clearColor];
                titlelbl.frame=CGRectMake(5, 0, 320, 40);
                [vcstar addSubview:titlelbl];
            }
            
            UIImageView *umgvw=[[UIImageView alloc]initWithFrame:CGRectMake(120, 10, 15, 15)];
            umgvw.image=[UIImage imageNamed:@"rating-start.png"];
            [vcstar addSubview:umgvw];
            
            
            
            UIView *proimg=[[UIView alloc]initWithFrame:CGRectMake(110, 55, 100, 100)];
            proimg.backgroundColor=[UIColor colorWithRed:47.0f/255.0f green:37.0f/255.0f blue:33.0f/255.0f alpha:0.5];
            
            proimg.layer.cornerRadius = 50;
            [main addSubview:proimg];
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"%@",[self.driverInfo objectForKey:@"username"]] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:17];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.textAlignment=NSTextAlignmentCenter;
                titlelbl.backgroundColor=[UIColor clearColor];
                titlelbl.frame=CGRectMake(0, 110, 320, 15);
                [vc addSubview:titlelbl];
            }
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"%@",[self.driverInfo objectForKey:@"emailid"]] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:14];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.textAlignment=NSTextAlignmentCenter;
                titlelbl.backgroundColor=[UIColor clearColor];
                titlelbl.frame=CGRectMake(0, 130, 320, 15);
                [vc addSubview:titlelbl];
            }
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"%@",[self.driverInfo objectForKey:@"phno"]] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:14];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.textAlignment=NSTextAlignmentCenter;
                titlelbl.backgroundColor=[UIColor clearColor];
                titlelbl.frame=CGRectMake(0, 150, 320, 15);
                [vc addSubview:titlelbl];
            }
            
            
            
            
            AsyncImageView *userImage  = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
            userImage.backgroundColor = [UIColor whiteColor];
            userImage.contentMode = UIViewContentModeScaleAspectFill;
            userImage.clipsToBounds = YES;
            userImage.layer.cornerRadius=45;
            NSURL *tempURL=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"image_url"]];
            userImage.imageURL = tempURL;
            tempURL=nil;
            [proimg addSubview:userImage];
            
            
            //++++++++++++++++++++++++++++++++++++++
            if(_isCustomer){
                
                
                
                
            {  UIButton *askButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [askButton addTarget:self
                              action:@selector(askClick)
                    forControlEvents:UIControlEventTouchUpInside];
                [askButton setTitle:@"ASK FOR PICKUP" forState:UIControlStateNormal];
                [askButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                askButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
                
                [askButton setBackgroundImage:[UIImage imageNamed:@"ask-for-pick-up"] forState:UIControlStateNormal];
                [askButton setBackgroundImage:[UIImage imageNamed:@"ask-for-pick-up"] forState:UIControlStateHighlighted];
                
                askButton.frame = CGRectMake(15, 225, 140, 41);
                [vc addSubview:askButton];
            }
            
            {  UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [callButton addTarget:self
                               action:@selector(callClick)
                     forControlEvents:UIControlEventTouchUpInside];
                
                [callButton setTitle:@"CALL" forState:UIControlStateNormal];
                [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                callButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:15];
                callButton.titleLabel.text=[callButton.titleLabel.text uppercaseString];
                [callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
                [callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateHighlighted];
                callButton.frame = CGRectMake(165, 225, 140, 41);
                [vc addSubview:callButton];
            }
                UIView *uv=[[UIView alloc]initWithFrame:CGRectMake(10, 270, 300, 1)];
                uv.backgroundColor=[UIColor colorWithRed:43.0f/255.0f green:43.0f/255.0f blue:43.0f/255.0f alpha:0.3];
                [vc addSubview:uv];
            }
            {
                
                
            }
            
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"License"] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.backgroundColor=[UIColor clearColor];
                titlelbl.frame=CGRectMake(15, 330, 120, 20);
                
                [main addSubview:titlelbl];
                
                UIImage *licenceback=[UIImage imageNamed:@"license_car_type_button.png"];
                
                UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(15, 305, licenceback.size.width/2, licenceback.size.height/2)];
                licence.userInteractionEnabled=NO;
                [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
                [licence setTitle:[self.driverInfo objectForKey:@"licenseno"] forState:UIControlStateNormal];
                [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
                [vc addSubview:licence];
                if(!_isCustomer){
                    titlelbl.frame=CGRectMake(15, 290, 120, 20);
                    licence.frame=CGRectMake(15, 305-40, licenceback.size.width/2, licenceback.size.height/2);
                }
                
            }
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"Car Type"] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.backgroundColor=[UIColor clearColor];
               
                titlelbl.frame=CGRectMake(200, 330, 120, 20);
               
                [main addSubview:titlelbl];
                
                UIImage *licenceback=[UIImage imageNamed:@"license_car_type_button.png"];
                UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(180, 305, licenceback.size.width/2, licenceback.size.height/2)];
                licence.userInteractionEnabled=NO;
                [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
                [licence setTitle:[self.driverInfo objectForKey:@"cartype"] forState:UIControlStateNormal];
                [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
                [vc addSubview:licence];
                if(!_isCustomer){
                    titlelbl.frame=CGRectMake(180, 290, 120, 20);
                    licence.frame=CGRectMake(180, 305-40, licenceback.size.width/2, licenceback.size.height/2);
                }
                
            }
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"Status"] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.backgroundColor=[UIColor clearColor];
                
                titlelbl.frame=CGRectMake(13, 400, 120, 20);
              
                [main addSubview:titlelbl];
                
                UIImage *licenceback=[UIImage imageNamed:@"stats-button.png"];
                UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(13, 375,licenceback.size.width/2, licenceback.size.height/2)];
                licence.userInteractionEnabled=NO;
                [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
                [licence setTitle:@"LICENSE" forState:UIControlStateNormal];
                [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
                [vc addSubview:licence];
                if(!_isCustomer){
                    titlelbl.frame=CGRectMake(13, 360, 120, 20);
                    licence.frame=CGRectMake(13, 375-40, licenceback.size.width/2, licenceback.size.height/2);
                }
                
            }
            
            {
                UILabel *titlelbl=[[UILabel alloc]init];
                //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
                titlelbl.numberOfLines = 0;
                titlelbl.text=[NSString stringWithFormat:@"Cost/km"] ;
                titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
                
                titlelbl.textColor=[UIColor whiteColor];
                titlelbl.backgroundColor=[UIColor clearColor];
               
                titlelbl.frame=CGRectMake(180, 400, 120, 20);
                
                [main addSubview:titlelbl];
                
                UIImage *licenceback=[UIImage imageNamed:@"cost-per-km-button.png"];
                UIButton *licence=[[UIButton alloc]initWithFrame:CGRectMake(180, 375, licenceback.size.width/2, licenceback.size.height/2)];
                licence.userInteractionEnabled=NO;
                [licence setBackgroundImage:licenceback forState:UIControlStateNormal];
                [licence setTitle:[self.driverInfo objectForKey:@"kmpercost"] forState:UIControlStateNormal];
                [licence.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
                [vc addSubview:licence];
                
                if(!_isCustomer){
                    titlelbl.frame=CGRectMake(180, 360, 120, 20);
                    licence.frame=CGRectMake(180, 375-40, licenceback.size.width/2, licenceback.size.height/2);
                }
                
            }

            
            
        }
    }
    }

    [self HideActivityIndicator];
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
-(void)callClick
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",[driverProfile objectForKey:@"phno"]]]];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Notpermitted show];
    }
}
-(void)askClick
{
    popUp =[[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 280, 150)];
    
    popUp.image=[UIImage imageNamed:@"registration_square.png"];
    
    //popUp.hidden=YES;
    
    popUp.userInteractionEnabled=YES;
    
    
    {
        
        UIImageView *nameBackGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 40, 230, 30)];
        
        nameBackGroundView.image = [UIImage imageNamed:@"input-text-square.png"];
        
        nameBackGroundView.userInteractionEnabled = YES;
        
        [popUp addSubview:nameBackGroundView];
        
        
        time_fld=nil;
        time_fld = [[UITextField alloc]initWithFrame:CGRectMake(26, 40, 150, 30)];
        
        time_fld.delegate=self;
        
        time_fld.placeholder = @"Pickup within";
        
        [time_fld setValue:[UIColor grayColor]forKeyPath:@"_placeholderLabel.textColor"];
        
        time_fld.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
        
        time_fld.borderStyle = UITextBorderStyleNone;
        
        time_fld.textAlignment = NSTextAlignmentLeft;
        
        time_fld.backgroundColor = [UIColor clearColor];
        
        [time_fld setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
        
        time_fld.returnKeyType = UIReturnKeyNext;
        
        time_fld.keyboardType=UIKeyboardTypeNumberPad;
        
        time_fld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        time_fld.autocapitalizationType =UITextAutocapitalizationTypeWords;
        
        [popUp addSubview:time_fld];
        
        UILabel *minutelbl=[[UILabel alloc]init];
        
        //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
        
        minutelbl.numberOfLines = 0;
        
        minutelbl.text=[NSString stringWithFormat:@"minutes"] ;
        
        minutelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:15];
        
        
        
        minutelbl.textColor=[UIColor whiteColor];
        
        minutelbl.textAlignment=NSTextAlignmentCenter;
        
        minutelbl.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.9];
        
        minutelbl.frame=CGRectMake(150, 40, 90, 30);
        
        [popUp addSubview:minutelbl];
        
        
        
        UIButton* pickbtn = [[UIButton alloc] init ];
        [pickbtn setBackgroundImage:[UIImage imageNamed:@"stats-button.png"] forState:UIControlStateNormal];
        pickbtn.tag=1;
        [pickbtn addTarget:self action:@selector(pickbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
        pickbtn.frame=CGRectMake(15 , 90, popUp.frame.size.width/2-25, 30);
        [pickbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pickbtn setTitle:@"Pick Me" forState:UIControlStateNormal];
        [pickbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
        
        [popUp addSubview: pickbtn];
        
        UIButton* closebtn = [[UIButton alloc] init ];
        [closebtn setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateNormal];
        closebtn.tag=2;
        [closebtn addTarget:self action:@selector(pickbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
        closebtn.frame=CGRectMake(popUp.frame.size.width/2, 90, popUp.frame.size.width/2-15, 30);
        [closebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closebtn setTitle:@"Not Now" forState:UIControlStateNormal];
        [closebtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
        [popUp addSubview:closebtn];
        
    }
    
    [main addSubview:popUp];
}
-(void)pickbuttonaction:(id)sender
{
    if(((UIButton *)sender).tag==1)
    {
        [[soundManager shared] buttonSound];
        UIAlertView *alert=[[UIAlertView alloc]init];
        if([time_fld.text isEqualToString:@""])
        {
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
                NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeup&senderid=%@&receiverid=%@&uloclong=%f&uloclat=%f&expiretime=%@&starttime=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"],[self.driverInfo objectForKey:@"fbid"],self.user_Coordinate.longitude,self.user_Coordinate.latitude,@"",time_fld.text];
                
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
            [self tapped];
            [popUp removeFromSuperview];
            popUp=nil;
        }
    }
    else
    {
        [popUp removeFromSuperview];
        popUp=nil;
    }
    
    
    
}
-(void)moreButtonAction{
    TaxifydproViewController *tvc=[[TaxifydproViewController alloc]init];
    [self.navigationController pushViewController:tvc animated:YES];
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
-(void)aceptClick5{
    
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

@end
