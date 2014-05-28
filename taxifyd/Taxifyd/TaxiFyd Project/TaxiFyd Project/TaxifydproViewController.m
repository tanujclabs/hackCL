//
//  TaxifydproViewController.m
//  TaxiFyd Project
//
//  Created by Click Labs on 5/4/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "TaxifydproViewController.h"
#import "Navigation.h"
#import "sidemenu.h"
#import "AsyncImageView.h"
#import "ProfileDriverViewController.h"
@interface TaxifydproViewController ()
{
    UIScrollView *main;
    UITextField *uNametextField;
    UITextField *uphonetextField;
    UITextField *upcostperhrtextField;
    UITextField *upcartypeField;
    UIImageView *vc1;
    UIImageView *vc2;
    UIImageView *vc3;
    UIImageView *vc4;
    UIImageView *vc5;
    UIImageView *vc6;
    BOOL flag;
}
@end

@implementation TaxifydproViewController

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
    main.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"driverback.jpg"]];
    main.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [main setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:main];
    
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    
    [main addGestureRecognizer:tapScroll];

    Navigation *nav=[[Navigation alloc]init];
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    
        navBar=[nav addNavigation:@"Profile info" withView:main];
    UIButton* homeButton = [[UIButton alloc] init ];
    [homeButton setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    homeButton.frame=CGRectMake(5 , 0, 50, 50);
    [navBar addSubview:homeButton];
    
    UIButton* homeButtons = [[UIButton alloc] init ];
    [homeButtons setBackgroundImage:[UIImage imageNamed:@"profile.png"] forState:UIControlStateNormal];
    [homeButtons addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    homeButtons.frame=CGRectMake(270 , 15, 25, 25);
    [navBar addSubview:homeButtons];
    [main addSubview: navBar];

	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    {
        vc1=[[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 280, 200)];
    vc1.image=[UIImage imageNamed:@"registration_square.png"];
    vc1.userInteractionEnabled=YES;
    {
        UILabel *titlelbl=[[UILabel alloc]init];
        //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
        titlelbl.numberOfLines = 0;
        titlelbl.text=[NSString stringWithFormat:@"STEP 1 OF 5"] ;
        titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:16];
        
        titlelbl.textColor=[UIColor grayColor];
        titlelbl.textAlignment=NSTextAlignmentLeft;
        titlelbl.backgroundColor=[UIColor clearColor];
        titlelbl.frame=CGRectMake(18, 7, 200, 40);
        [vc1 addSubview:titlelbl];
    }
    {
        UILabel *titlelbl=[[UILabel alloc]init];
        //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
        titlelbl.numberOfLines = 0;
        titlelbl.text=[NSString stringWithFormat:@"ENTER DRIVER ID"] ;
        titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:19];
        
        titlelbl.textColor=[UIColor blackColor];
        titlelbl.textAlignment=NSTextAlignmentLeft;
        titlelbl.backgroundColor=[UIColor clearColor];
        titlelbl.frame=CGRectMake(18, 37, 200, 40);
        [vc1 addSubview:titlelbl];
    }
    {
        UIImageView *nameBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 77, 230, 40)];
        nameBackGroundView.image = [UIImage imageNamed:@"input-text-square.png"];
        nameBackGroundView.userInteractionEnabled = YES;
        [vc1 addSubview:nameBackGroundView];
        
        uNametextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, 220, 30)];
        uNametextField.delegate=self;
        uNametextField.placeholder = @"ENTER DRIVER LICENSE";
        [uNametextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        uNametextField.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
        uNametextField.borderStyle = UITextBorderStyleNone;
        uNametextField.textAlignment = NSTextAlignmentLeft;
        uNametextField.backgroundColor = [UIColor clearColor];
        [uNametextField setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
        uNametextField.returnKeyType = UIReturnKeyNext;
        uNametextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [vc1 addSubview:uNametextField];
        
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginButton addTarget:self
                        action:@selector(driverClick)
              forControlEvents:UIControlEventTouchUpInside];
        [loginButton setTitle:@"NEXT" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
        
        [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
        [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
        loginButton.frame = CGRectMake(20, 130, 230, 41);
        [vc1 addSubview:loginButton];

    }

    
    [main addSubview:vc1];}
    
    
    
    {
       vc2 =[[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 280, 200)];
        vc2.image=[UIImage imageNamed:@"registration_square.png"];
        vc2.hidden=YES;
        
        vc2.userInteractionEnabled=YES;
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"STEP 2 OF 5"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:16];
            
            titlelbl.textColor=[UIColor grayColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 7, 200, 40);
            [vc2 addSubview:titlelbl];
        }
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"ENTER MOBILE NO"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:19];
            
            titlelbl.textColor=[UIColor blackColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 37, 200, 40);
            [vc2 addSubview:titlelbl];
        }
        {
            UIImageView *nameBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 77, 230, 40)];
            nameBackGroundView.image = [UIImage imageNamed:@"input-text-square.png"];
            nameBackGroundView.userInteractionEnabled = YES;
            [vc2 addSubview:nameBackGroundView];
            
            uphonetextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, 220, 30)];
            uphonetextField.delegate=self;
            uphonetextField.placeholder = @"MOBILE NO";
            [uphonetextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            uphonetextField.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
            uphonetextField.borderStyle = UITextBorderStyleNone;
            uphonetextField.textAlignment = NSTextAlignmentLeft;
            uphonetextField.backgroundColor = [UIColor clearColor];
            [uphonetextField setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            uphonetextField.returnKeyType = UIReturnKeyNext;
            uphonetextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            [vc2 addSubview:uphonetextField];
            
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton addTarget:self
                            action:@selector(mobileClick)
                  forControlEvents:UIControlEventTouchUpInside];
            [loginButton setTitle:@"NEXT" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
            loginButton.frame = CGRectMake(20, 130, 230, 41);
            [vc2 addSubview:loginButton];
            
        }
        
        
        [main addSubview:vc2];}
    
    
    
    {
        vc3 =[[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 280, 200)];
        vc3.image=[UIImage imageNamed:@"registration_square.png"];
        vc3.hidden=YES;
        
        vc3.userInteractionEnabled=YES;
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"STEP 3 OF 5"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:16];
            
            titlelbl.textColor=[UIColor grayColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 7, 200, 40);
            [vc3 addSubview:titlelbl];
        }
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"ENTER COST PER KM"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:19];
            
            titlelbl.textColor=[UIColor blackColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 37, 200, 40);
            [vc3 addSubview:titlelbl];
        }
        {
            UIImageView *nameBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 77, 230, 40)];
            nameBackGroundView.image = [UIImage imageNamed:@"input-text-square.png"];
            nameBackGroundView.userInteractionEnabled = YES;
            [vc3 addSubview:nameBackGroundView];
            
            upcostperhrtextField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, 220, 30)];
            upcostperhrtextField.delegate=self;
            upcostperhrtextField.placeholder = @"COST PER HOUR";
            [upcostperhrtextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            upcostperhrtextField.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
            upcostperhrtextField.borderStyle = UITextBorderStyleNone;
            upcostperhrtextField.textAlignment = NSTextAlignmentLeft;
            upcostperhrtextField.backgroundColor = [UIColor clearColor];
            [upcostperhrtextField setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            upcostperhrtextField.returnKeyType = UIReturnKeyNext;
            upcostperhrtextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            [vc3 addSubview:upcostperhrtextField];
            
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton addTarget:self
                            action:@selector(costClick)
                  forControlEvents:UIControlEventTouchUpInside];
            [loginButton setTitle:@"NEXT" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
            loginButton.frame = CGRectMake(20, 130, 230, 41);
            [vc3 addSubview:loginButton];
            
        }
        
        
        [main addSubview:vc3];}
    
    
    {
        vc4 =[[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 280, 200)];
        vc4.image=[UIImage imageNamed:@"registration_square.png"];
        vc4.hidden=YES;
        
        vc4.userInteractionEnabled=YES;
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"STEP 4 OF 5"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:16];
            
            titlelbl.textColor=[UIColor grayColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 7, 200, 40);
            [vc4 addSubview:titlelbl];
        }
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"ENTER CAR TYPE"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:19];
            
            titlelbl.textColor=[UIColor blackColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 37, 200, 40);
            [vc4 addSubview:titlelbl];
        }
        {
            UIImageView *nameBackGroundView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 77, 230, 40)];
            nameBackGroundView.image = [UIImage imageNamed:@"input-text-square.png"];
            nameBackGroundView.userInteractionEnabled = YES;
            [vc4 addSubview:nameBackGroundView];
            
            upcartypeField = [[UITextField alloc] initWithFrame:CGRectMake(26, 77, 220, 30)];
            upcartypeField.delegate=self;
            upcartypeField.placeholder = @"CAR TYPE";
            [upcartypeField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            upcartypeField.textColor = [UIColor colorWithRed:16.0/255 green:137.0/255 blue:168.0/255 alpha:1];
            upcartypeField.borderStyle = UITextBorderStyleNone;
            upcartypeField.textAlignment = NSTextAlignmentLeft;
            upcartypeField.backgroundColor = [UIColor clearColor];
            [upcartypeField setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:15]];
            upcartypeField.returnKeyType = UIReturnKeyNext;
            upcartypeField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            [vc4 addSubview:upcartypeField];
            
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton addTarget:self
                            action:@selector(ctypeClick)
                  forControlEvents:UIControlEventTouchUpInside];
            [loginButton setTitle:@"NEXT" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
            loginButton.frame = CGRectMake(20, 130, 230, 41);
            [vc4 addSubview:loginButton];
            
        }
        
        
        [main addSubview:vc4];}
    
    
    
    {
        vc5 =[[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 280, 200)];
        vc5.image=[UIImage imageNamed:@"registration_square.png"];
        vc5.hidden=YES;
        
        vc5.userInteractionEnabled=YES;
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"STEP 5 OF 5"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic" size:16];
            
            titlelbl.textColor=[UIColor grayColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 7, 200, 40);
            [vc5 addSubview:titlelbl];
        }
        {
            UILabel *titlelbl=[[UILabel alloc]init];
            //titlelbl.lineBreakMode = UILineBreakModeWordWrap;
            titlelbl.numberOfLines = 0;
            titlelbl.text=[NSString stringWithFormat:@"SAVE ALL DATA"] ;
            titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:19];
            
            titlelbl.textColor=[UIColor blackColor];
            titlelbl.textAlignment=NSTextAlignmentLeft;
            titlelbl.backgroundColor=[UIColor clearColor];
            titlelbl.frame=CGRectMake(18, 37, 200, 40);
            [vc5 addSubview:titlelbl];
        }
        {

            
       
            
            
            UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [loginButton addTarget:self
                            action:@selector(SubmitClick)
                  forControlEvents:UIControlEventTouchUpInside];
            [loginButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
            [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            loginButton.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
            
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
            [loginButton setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
            loginButton.frame = CGRectMake(20, 100, 230, 41);
            [vc5 addSubview:loginButton];
            
        }
        
        
        [main addSubview:vc5];}
    
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
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getdriverpro&fbid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBuserID"]];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
           NSDictionary *driverInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",driverInfo);
            uNametextField.text=[driverInfo objectForKey:@"licenseno"];
            uphonetextField.text=[driverInfo objectForKey:@"phno"];
            upcostperhrtextField.text=[driverInfo objectForKey:@"kmpercost"];
            upcartypeField.text=[driverInfo objectForKey:@"cartype"];
            
        }
    }




}
-(void)driverClick{
    if(uNametextField.text.length>=1){
        vc1.hidden=YES;
        vc2.hidden=NO;
        vc3.hidden=YES;
        vc4.hidden=YES;
    }
}
-(void)mobileClick{
   if(uphonetextField.text.length>=1){
       vc1.hidden=YES;
       vc2.hidden=YES;
       vc3.hidden=NO;
       vc4.hidden=YES;
   }
}
-(void)costClick{
    if(upcostperhrtextField.text.length>=1){
        vc1.hidden=YES;
        vc2.hidden=YES;
        vc3.hidden=YES;
        vc4.hidden=NO;
        
    }
}
-(void)ctypeClick{
    if(upcartypeField.text.length>=1){
        vc1.hidden=YES;
        vc2.hidden=YES;
        vc3.hidden=YES;
        vc4.hidden=YES;
        vc5.hidden=NO;
    }
}
-(void)SubmitClick{
    
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
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=updatedriverpro&fbid=%@&licenseno=%@&kmpercost=%@&cartype=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBuserID"],uNametextField.text,upcostperhrtextField.text,upcartypeField.text];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *driverInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",driverInfo);
            uNametextField.text=[driverInfo objectForKey:@"licenseno"];
            upcostperhrtextField.text=[driverInfo objectForKey:@"kmpercost"];
            upcartypeField.text=[driverInfo objectForKey:@"cartype"];vc5.hidden=YES;vc1.hidden=NO;
            
        }
    }
    
    
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
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=updatepro&fbid=%@&phno=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FBuserID"],uphonetextField.text];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *driverInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",driverInfo);
           
            uphonetextField.text=[driverInfo objectForKey:@"phno"];
            
            
        }
    }
    }
    
    

}
- (void)tapped

{
    
    [uNametextField resignFirstResponder];
     [uphonetextField resignFirstResponder];
    [upcostperhrtextField resignFirstResponder];
    [upcartypeField resignFirstResponder];
//    [uBid resignFirstResponder];
//    [uprice resignFirstResponder];;
    
    
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)HideActivityIndicator
{
    [SVProgressHUD dismiss];
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
-(void)moreButtonAction{
    ProfileDriverViewController *pvc=[[ProfileDriverViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}
@end
