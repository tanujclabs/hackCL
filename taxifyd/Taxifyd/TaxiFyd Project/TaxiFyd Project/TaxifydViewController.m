//
//  TaxifydViewController.m
//  TaxiFyd Project
//
//  Created by Click Labs on 5/2/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "TaxifydViewController.h"
#import "homeVC.h"
#import "DriverVC.h"
@interface TaxifydViewController ()
{
    NSMutableArray *InformationArray;
    UIScrollView *main;
    UIButton *facebook;
    NSString *userImage;
    UIView *popupView;
    NSString *account_type;
}
@end

@implementation TaxifydViewController

-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstTimeLoginYes"])
    {
        [self LoginFromAceessTokens];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    main=[[UIScrollView alloc]init];
    main.backgroundColor=[UIColor clearColor];
    main.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [main setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:main];
    
    
    UIImage *facebookSizeOff=[UIImage imageNamed:@"ZW4QC.png"];
    UIImage *facebookSizeOn=[UIImage imageNamed:@"ZW4QC.png"];
    facebook = [UIButton buttonWithType:UIButtonTypeCustom];
    facebook.frame = CGRectMake(0,0, facebookSizeOff.size.width, facebookSizeOff.size.height);
    facebook.center=main.center;
    [facebook setBackgroundImage:facebookSizeOff forState:UIControlStateNormal];
    [facebook setBackgroundImage:facebookSizeOn forState:UIControlStateSelected];
    [facebook setBackgroundImage:facebookSizeOn forState:UIControlStateHighlighted];
    [facebook setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 0.0f)];
    //[facebook setTitle:@" Sign in with Facebook " forState:(UIControlStateNormal&UIControlStateHighlighted&UIControlStateSelected)];
    [facebook setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [facebook setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [facebook setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [facebook.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic" size:14]];
    [facebook addTarget:self action:@selector(facebooklogin:) forControlEvents:UIControlEventTouchDown];
    [main addSubview:facebook];
}
-(void)LoginFromAceessTokens
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
        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"FBuserID"]];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            if(json)
            {
                //                    if([json objectForKey:@"error"])
                //                    {
                //                        [self HideActivityIndicator];
                //                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Some error in login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                //                        [alert show];
                //
                //                    }
                //                    else
                //                    {
                [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"username"] forKey:@"name"];
                [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"proimage"] forKey:@"image_url"];
                [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"atoken"]forKey:@"access_token"];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"actype"]  forKey:@"usertype"];
                [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"emailid"]  forKey:@"email"];
                
                
                NSLog(@"access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]);
                NSLog(@"name=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]);
                NSLog(@"image_url=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"image_url"]);
                
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTimeLoginYes"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if([[[NSUserDefaults standardUserDefaults]objectForKey:@"usertype"] isEqualToString:@""])
                {
                    account_type=@"";
                    return;
                }
                else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"usertype"] lowercaseString] isEqualToString:@"user"])
                {
                    homeVC *home = [[homeVC alloc] init];
                    [self.navigationController pushViewController:home animated:YES];
                }
                else if([[[[NSUserDefaults standardUserDefaults]objectForKey:@"usertype"]lowercaseString] isEqualToString:@"driver"])
                {
                    DriverVC *home = [[DriverVC alloc] init];
                    [self.navigationController pushViewController:home animated:YES];
                }

                NSLog(@"Login Successful");
                [self HideActivityIndicator];
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
-(void)facebooklogin:(id)sender
{
    [[soundManager shared] buttonSound];
    NSLog(@"facebook:");
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"FBonBackGround"];
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
        if (FBSession.activeSession.isOpen )
        {
            [self UserInformation];
        }
        else
        {
            NSArray *permissions = [[NSArray alloc] initWithObjects:@"email",@"user_photos",@"user_birthday",@"read_friendlists", nil];
            // NSArray *permissions = [[NSArray alloc] initWithObjects:@"read_friendlists",@"user_photos",nil];
            [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
             //             [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
             {
                 if(!error)
                 {
                     [self UserInformation];
                 }else
                 {
                     NSLog(@"Error : %@",error);
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Facebook Error" message:@"Taxifyd uses your Facebook identity to make sure you're real. You'll need to accept to join!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                     [self HideActivityIndicator];
                 }
             }];
        }
    }
    
    
}
-(void)UserInformation
{
    
    NSLog(@"yes enter");
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
        [[FBRequest requestForGraphPath:@"me"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error )
            {
                [self ShowActivityIndicatorWithTitle:@"Loading..."];
                [[[FBSession activeSession] accessTokenData] accessToken];
                NSLog(@"acces token=%@",[[[FBSession activeSession] accessTokenData] accessToken]);
                [[NSUserDefaults standardUserDefaults]setValue:[[[FBSession activeSession] accessTokenData] accessToken]  forKey:@"FbAccessTokenKey"];
                NSLog(@"sdfsdfdsfsf=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"FbAccessTokenKey"]);
                NSLog(@"result %@",result);
                NSString *userName=[result objectForKey:@"name"];
                NSString *userid=[result objectForKey:@"id"];
                NSString *email = [result objectForKey:@"email"];
                NSString *gender = [result objectForKey:@"gender"];
                NSString *dob = [result objectForKey:@"birthday"];
                NSString *userLocation  = [[result objectForKey:@"location"] objectForKey:@"name"];
                
                [[NSUserDefaults standardUserDefaults]setValue:userid  forKey:@"FBuserID"];
                [[NSUserDefaults standardUserDefaults]setValue:userName   forKey:@"FBuserName"];
                [[NSUserDefaults standardUserDefaults]setValue:email   forKey:@"FBemail"];
                [[NSUserDefaults standardUserDefaults]setValue:gender   forKey:@"FBgender"];
                [[NSUserDefaults standardUserDefaults]setValue:dob   forKey:@"FBbirthday"];
                [[NSUserDefaults standardUserDefaults]setObject:userLocation forKey:@"location"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSLog(@"userid %@",userid);
                NSLog(@"userName %@",userName);
                NSLog(@"email %@",email);
                NSLog(@"gender %@",gender);
                NSLog(@"dob %@",dob);
                NSLog(@"userLocation %@",userLocation);
                [self HideActivityIndicator];
                [self LoginFromAceessTokens];
                if([account_type isEqualToString:@""])
                    [self popupView];
            }
            else
            {
                [self HideActivityIndicator];
            }
        }];
    }
}
-(void)registerFromFacebook
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
        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=newpro&actype=%@&username=%@&atoken=%@&coverimage=%@&emailid=%@&fbid=%@&proimage=%@&lastLlong=%f&lastLlat=%f",account_type,[[NSUserDefaults standardUserDefaults]valueForKey:@"FBuserName"],@"",@"",[[NSUserDefaults standardUserDefaults]valueForKey:@"FBemail"],[[NSUserDefaults standardUserDefaults]valueForKey:@"FBuserID"],@"",0.0,0.0];
        
        NSLog(@"post %@",post);
      
        NSData *data = [self  getDataFrom:post];
      
        if (data)
        {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
                NSLog(@"json %@",json);
                if(json)
                {
//                    if([json objectForKey:@"error"])
//                    {
//                        [self HideActivityIndicator];
//                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Some error in login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                        [alert show];
//    
//                    }
//                    else
//                    {
                    [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"username"] forKey:@"name"];
                    [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"proimage"] forKey:@"image_url"];
                       [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"atoken"]forKey:@"access_token"];
                    
        
                        [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"actype"]  forKey:@"usertype"];
                        [[NSUserDefaults standardUserDefaults] setObject:[json valueForKey:@"emailid"]  forKey:@"email"];
        
        
                        NSLog(@"access_token=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]);
                        NSLog(@"name=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"name"]);
                        NSLog(@"image_url=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"image_url"]);

    
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTimeLoginYes"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookLogin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    [self HideActivityIndicator];
                    if([account_type isEqualToString:@"User"])
                    {
                        homeVC *home = [[homeVC alloc] init];
                        [self.navigationController pushViewController:home animated:YES];
                        
                    }
                    else
                    {
                        DriverVC *home = [[DriverVC alloc] init];
                        [self.navigationController pushViewController:home animated:YES];
                    }
                        NSLog(@"Login Successful");
                    
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


-(void) popupView
{
    [[soundManager shared] buttonSound];
    popupView=nil;
    popupView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    popupView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"transparent_bg.png"]];
    //popupView.alpha=0.8;
    popupView.userInteractionEnabled=YES;
    
    UIImageView *frontView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"registration_square.png"]];
    frontView.frame=CGRectMake(0, 0, frontView.image.size.width/2, 210);
    frontView.center=popupView.center;
    frontView.userInteractionEnabled=YES;
    [popupView addSubview:frontView];
    
    UIImage *crossSizeOff=[UIImage imageNamed:@"popup_cross.png"];
    UIImage *crossSizeOn=[UIImage imageNamed:@"popup_cross_onclick.png"];
    UIButton *crossView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [crossView setBackgroundImage:crossSizeOff forState:UIControlStateNormal];
    [crossView setBackgroundImage:crossSizeOn forState:UIControlStateSelected];
    [crossView setBackgroundImage:crossSizeOn forState:UIControlStateHighlighted];
    [crossView addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchDown];
    crossView.frame=CGRectMake(frontView.frame.origin.x+frontView.frame.size.width-crossSizeOff.size.width/4, frontView.frame.origin.y-crossSizeOff.size.height/4, crossSizeOff.size.width/2, crossSizeOff.size.height/2);
    //[popupView addSubview:crossView];
    
    
    UILabel *titlelbl=[[UILabel alloc]init];
    titlelbl.numberOfLines=2;
    titlelbl.text=@"USER TYPE";
    titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:20];
    titlelbl.textAlignment=NSTextAlignmentCenter;
    titlelbl.textColor=[UIColor blackColor];
    titlelbl.backgroundColor=[UIColor clearColor];
    titlelbl.frame=CGRectMake(0, 15, frontView.frame.size.width, 30);
    [frontView addSubview:titlelbl];
    
    UIImage *addOff=[UIImage imageNamed:@"btn.png"];
    UIImage *addOn=[UIImage imageNamed:@"btn_onclick.png"];
    UIButton *customer = [UIButton buttonWithType:UIButtonTypeCustom];
    customer.frame=CGRectMake(20, 60, addOff.size.width/2-15, 45);
    [customer setTitle:@"PASSANGER" forState:UIControlStateNormal];
    [customer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    customer.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
    
    [customer setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
    [customer setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
    
    [customer addTarget:self action:@selector(SelectedUser:) forControlEvents:UIControlEventTouchDown];
    [frontView addSubview:customer];
    
    UIButton *driver = [UIButton buttonWithType:UIButtonTypeCustom];
    driver.frame=CGRectMake(20, customer.frame.origin.y+customer.frame.size.height+20, addOff.size.width/2-15, 45);
    [driver setTitle:@"DRIVER" forState:UIControlStateNormal];
    [driver setTitleColor:[UIColor colorWithRed:104.0/255.0 green:51.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    driver.tag=2;
    driver.userInteractionEnabled=YES;
    
    [driver setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    driver.titleLabel.font = [UIFont fontWithName:@"CenturyGothic-Bold" size:18];
    
    [driver setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateNormal];
    [driver setBackgroundImage:[UIImage imageNamed:@"next_submit_button.png"] forState:UIControlStateHighlighted];
    [driver addTarget:self action:@selector(SelectedUser:) forControlEvents:UIControlEventTouchDown];
    [frontView addSubview:driver];
    
    
    
    [self.view addSubview:popupView];
}
-(void)removeView
{
    [[soundManager shared] buttonSound];
    [popupView removeFromSuperview];
    
}
-(void)SelectedUser:(id)sender
{
    if(((UIButton *)sender).tag==1)
        account_type=@"User";
    else
        account_type=@"Driver";
    [self removeView];
    [self registerFromFacebook];
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
