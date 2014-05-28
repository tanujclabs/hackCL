//
//  logcustomerVC.m
//  TaxiFyd Project
//
//  Created by Click Labs on 5/4/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "logcustomerVC.h"
#import "Navigation.h"
#import "sidemenu.h"
#import "AsyncImageView.h"
#import "SVAnnotation.h"
#import "SVPulsingAnnotationView.h"
#import "driverThreadDetails.h"
#import "ProfileDriverViewController.h"
@interface logcustomerVC ()
{
    UIScrollView *main;
    NSDictionary *Info1;
    NSMutableArray *Info2;
    NSMutableArray *Info3;
    NSMutableArray *InformationArray;
    int user_type;
    BOOL flag;
    UITableView *logtable;
    UIAlertView *alert;
}
@end

@implementation logcustomerVC

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
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    flag=TRUE;
    main=[[UIScrollView alloc]init];
    main.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"driverback.jpg"]];;
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
    
    logtable=[[UITableView alloc]init];
    logtable.delegate=self;
    logtable.dataSource=self;
    logtable.backgroundColor=[UIColor clearColor];
    logtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    logtable.frame=CGRectMake(0, 50, main.frame.size.width, main.frame.size.height-50);
    [self.view addSubview:logtable];
    dispatch_queue_t q=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(q, ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!Info2) {
                alert=nil;
                [alert setTitle:@"Warning"];
                [alert setMessage:@"No Log Found"];
                [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
                [alert show];
            }
            NSLog(@"Friend List: %@",Info2);
            [logtable reloadData];
        });
    });
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


-(void)loadData
{
    [self ShowActivityIndicatorWithTitle:@"Loading..."];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        [self HideActivityIndicator];
        alert=nil;
        [alert setTitle:@"Warning"];
        [alert setMessage:@"No Internet Access"];
        [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
        [alert show];
    }
    else
    {
        
        NSString *postss =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        
        NSData *datass = [self  getDataFrom:postss];
        
        Info1 = [NSJSONSerialization JSONObjectWithData:datass options:NSJSONReadingMutableLeaves error:Nil];
        NSLog(@"json %@",Info1);
        
        
//        userImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=250&type=normal&width=250",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
//        NSLog(@"urlString=%@",userImage);
        
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getallthread&senderid=%@&status=Request",[[NSUserDefaults standardUserDefaults] objectForKey:@"FBuserID"]];
        
        NSLog(@"post %@",post);
        
        NSData *data = [self  getDataFrom:post];
        
        if (data)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:Nil];
            NSLog(@"json %@",json);
            Info2=[json objectForKey:@"DriverList"] ;
            if(json)
            {
                NSLog(@"Login Successful");
                Info3=[[NSMutableArray alloc]init];
                for(int count=0;count<Info2.count;count++)
                {
                    NSString *posts =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=getpro&fbid=%@",[[Info2 valueForKey:@"receiverid"] objectAtIndex:count]];
                    
                    NSData *datas = [self getDataFrom:posts];
                    
                    if (datas)
                    {
                        NSDictionary *profileInfo=[NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:Nil];
                        [Info3 addObject:[profileInfo mutableCopy]];
                    }
                }
                    
                [self HideActivityIndicator];
                
                
            }
            else
            {
                alert=nil;
                [alert setTitle:@"Warning"];
                [alert setMessage:@"Error in data fetch"];
                [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
                [alert show];
            }
            
        }
        else{
            alert=nil;
            [alert setTitle:@"Warning"];
            [alert setMessage:@"No Internet Access"];
            [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
            [alert show];
        }
        
    }
    [self HideActivityIndicator];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileDriverViewController *profile = [[ProfileDriverViewController alloc] init];
    profile.isCustomer=TRUE;
    profile.isLog=-10;
    profile.driverInfo=[Info3 objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:profile animated:NO];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[[[Info2 objectAtIndex:indexPath.row] objectForKey:@"status"]lowercaseString]isEqualToString:@"bid"])
        return 130;
    else
        return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Info2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d_%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        
        UIImageView *backview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 105)];
        backview.image=[UIImage imageNamed:@"white-rectangle-base.png"];
        [cell.contentView addSubview:backview];
        
        AsyncImageView *userImage  = [[AsyncImageView alloc] initWithFrame:CGRectMake(320-80, 8, 70, 70)];
        userImage.backgroundColor = [UIColor whiteColor];
        userImage.contentMode = UIViewContentModeScaleAspectFill;
        userImage.clipsToBounds = YES;
        userImage.layer.cornerRadius=2;
        NSURL *tempURL=[NSURL URLWithString:[[Info3 objectAtIndex:indexPath.row ] valueForKey:@"proimage"]];
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
        [cell.contentView addSubview:userImage];
        
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:[[[Info2 valueForKey:@"uloclat"] objectAtIndex:indexPath.row] floatValue] longitude:[[[Info2 valueForKey:@"uloclong"] objectAtIndex:indexPath.row] floatValue]];
                
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:[[Info1 objectForKey:@"lastLlat"] floatValue] longitude:[[Info1 objectForKey:@"lastLlong"] floatValue]];
                
        CLLocationDistance distance = [locA distanceFromLocation:locB]/1000;
                
                
        UILabel *typelbl=[[UILabel alloc]init];
        typelbl.numberOfLines = 0;
        if([[[Info2 valueForKey:@"type"] objectAtIndex:indexPath.row] isEqualToString:@"Simple"]){
            typelbl.textColor=[UIColor colorWithRed:13.0f/255.0f green:152.0f/255.0f blue:205.0f/255.0f alpha:1.0];
        }else{
            typelbl.textColor=[UIColor colorWithRed:239.0f/255.0f green:137.0f/255.0f blue:0.f/255.0f alpha:1.0];
        }
        typelbl.text=[NSString stringWithFormat:@"%@",[[Info2 valueForKey:@"type"] objectAtIndex:indexPath.row]];
        typelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:22];
        typelbl.backgroundColor=[UIColor clearColor];
        typelbl.frame=CGRectMake(6, 1, 12, 30);
        [cell.contentView addSubview:typelbl];
                
                
        UILabel *usernamelbl=[[UILabel alloc]init];
        usernamelbl.numberOfLines = 0;
        usernamelbl.text=[NSString stringWithFormat:@"%@",[[Info3 objectAtIndex:indexPath.row ] objectForKey:@"username"]];
        usernamelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:18];
        usernamelbl.textColor=[UIColor blackColor];
        usernamelbl.backgroundColor=[UIColor clearColor];
        usernamelbl.frame=CGRectMake(25, 1, 200, 30);
        [cell.contentView addSubview:usernamelbl];
                
        UILabel *maxpricelbl=[[UILabel alloc]init];
        maxpricelbl.numberOfLines = 0;
        NSString *strs=[NSString stringWithFormat:@"%@",[[Info2 valueForKey:@"maxprice"] objectAtIndex:indexPath.row]];
        if(strs.length>1){
            maxpricelbl.text=[NSString stringWithFormat:@"%@ Rs/km",[[Info2 valueForKey:@"maxprice"] objectAtIndex:indexPath.row]];
        }else{
            maxpricelbl.text=@"AS YOUR RATE";
        }
        maxpricelbl.font=[UIFont fontWithName:@"CenturyGothic" size:14];
        maxpricelbl.textColor=[UIColor blackColor];
        maxpricelbl.backgroundColor=[UIColor clearColor];
        maxpricelbl.frame=CGRectMake(10, 28, 200, 30);
        [cell.contentView addSubview:maxpricelbl];
                
                
        UIImageView *locationview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 64, 15, 15)];
        locationview.image=[UIImage imageNamed:@"location-icon.png"];
        [cell.contentView addSubview:locationview];
        UILabel *distancelbl=[[UILabel alloc]init];
        distancelbl.numberOfLines = 0;
        distancelbl.text=[NSString stringWithFormat:@"%.2f km from Here",distance];
        distancelbl.font=[UIFont fontWithName:@"CenturyGothic" size:14];
        distancelbl.textColor=[UIColor blackColor];
        distancelbl.backgroundColor=[UIColor clearColor];
        distancelbl.frame=CGRectMake(10, 56, 200, 30);
        [cell.contentView addSubview:distancelbl];
        
        if([[[[Info2 objectAtIndex:indexPath.row] objectForKey:@"status"]lowercaseString]isEqualToString:@"bid"])
        {
            backview.frame=CGRectMake(0, 0, 320, 150);
            userImage.frame=CGRectMake(320-80, 25, 70, 70);
            
            maxpricelbl.text=[NSString stringWithFormat:@"Passenger's Bid : %@",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"maxprice"]];
            maxpricelbl.frame=CGRectMake(10, 30, 200, 20);
            
            distancelbl.text=[NSString stringWithFormat:@"Driver's Bid : %@",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"bid"]];
            distancelbl.frame=CGRectMake(10, 50, 200, 20);
            
            UILabel *availablelbl=[[UILabel alloc]init];
            availablelbl.numberOfLines = 0;
            availablelbl.text=[NSString stringWithFormat:@"Available in : %@ minutes",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"mback"]];
            availablelbl.font=[UIFont fontWithName:@"CenturyGothic" size:14];
            availablelbl.textColor=[UIColor blackColor];
            availablelbl.backgroundColor=[UIColor clearColor];
            availablelbl.frame=CGRectMake(10, 70, 200, 20);
            [cell.contentView addSubview:availablelbl];
            
            UIButton* acceptbtn = [[UIButton alloc] init ];
            [acceptbtn setBackgroundImage:[UIImage imageNamed:@"stats-button.png"] forState:UIControlStateNormal];
            acceptbtn.tag=indexPath.row;
            [acceptbtn addTarget:self action:@selector(acceptbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
            acceptbtn.frame=CGRectMake(15 , 95, 60, 25);
            [acceptbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [acceptbtn setTitle:@"Accept" forState:UIControlStateNormal];
            [acceptbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
            
            [cell.contentView addSubview: acceptbtn];
            
            UIButton* rejectbtn = [[UIButton alloc] init ];
            [rejectbtn setBackgroundImage:[UIImage imageNamed:@"cost-per-km-button.png"] forState:UIControlStateNormal];
            rejectbtn.tag=indexPath.row-100;
            [rejectbtn addTarget:self action:@selector(rejecttbuttonaction:) forControlEvents:UIControlEventTouchUpInside];
            rejectbtn.frame=CGRectMake(90, 95,60, 25);
            [rejectbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rejectbtn setTitle:@"Reject" forState:UIControlStateNormal];
            [rejectbtn.titleLabel setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:16]];
            [cell.contentView addSubview:rejectbtn];
        }
        else if([[[[Info2 objectAtIndex:indexPath.row] objectForKey:@"status"]lowercaseString]isEqualToString:@"accept"])
        {
            
            maxpricelbl.text=[NSString stringWithFormat:@"Travel Fare : %@",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"maxprice"]];
            maxpricelbl.frame=CGRectMake(10, 30, 200, 20);
            
            distancelbl.text=[NSString stringWithFormat:@"Available in : %@ minutes",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"mback"]];
            distancelbl.frame=CGRectMake(10, 50, 200, 20);
            UIImageView *accept  = [[UIImageView alloc] initWithFrame:CGRectMake(320-110, 20, 25, 25 )];
            accept.image=[UIImage imageNamed:@"accepted.png"];
            accept.backgroundColor = [UIColor whiteColor];
            accept.contentMode = UIViewContentModeScaleAspectFill;
            accept.clipsToBounds = YES;
            accept.layer.cornerRadius=2;
            [cell.contentView addSubview:accept];
        }
        else if([[[[Info2 objectAtIndex:indexPath.row] objectForKey:@"status"]lowercaseString]isEqualToString:@"client accepted"])
        {
            
            maxpricelbl.text=[NSString stringWithFormat:@"Travel Fare : %@",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"bid"]];
            maxpricelbl.frame=CGRectMake(10, 30, 200, 20);
            
            distancelbl.text=[NSString stringWithFormat:@"Available in : %@ minutes",[[Info2 objectAtIndex:indexPath.row] objectForKey:@"mback"]];
            distancelbl.frame=CGRectMake(10, 50, 200, 20);
            UIImageView *accept  = [[UIImageView alloc] initWithFrame:CGRectMake(320-110, 20, 25, 25 )];
            accept.image=[UIImage imageNamed:@"accepted.png"];
            accept.backgroundColor = [UIColor whiteColor];
            accept.contentMode = UIViewContentModeScaleAspectFill;
            accept.clipsToBounds = YES;
            accept.layer.cornerRadius=2;
            [cell.contentView addSubview:accept];
        }
        
        
    }
    return cell;


}
-(void)rejecttbuttonaction:(id)sender
{
    UIButton *btn=((UIButton *)sender);
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable)
    {
        [self HideActivityIndicator];
        alert=nil;
        alert=[[UIAlertView alloc]init];
        [alert setTitle:@"Warning"];
        [alert setMessage:@"No Internet Access"];
        [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
        [alert show];
    }
    else
    {
        NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeupedit&id=%@&status=Reject&mback=Reject",[[Info2 objectAtIndex:btn.tag+100] objectForKey:@"id"]];
        
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
                [UIView animateWithDuration:0.7 animations:^{
                    [[btn.superview viewWithTag:btn.tag+100]removeFromSuperview];
                    [btn.superview setFrame:CGRectMake(btn.superview.frame.origin.x, btn.superview.frame.origin.y, btn.superview.frame.size.width, btn.superview.frame.size.width-30)];
                    [[btn.superview viewWithTag:btn.tag]removeFromSuperview];
                } completion:^ (BOOL finished){
                    if (finished) {
                        
                        
                    }}];
                
                
            }
        }
        
        
        // }
    }
    
    
    [self HideActivityIndicator];
}

-(void)acceptbuttonaction:(id)sender
{
    UIButton *btn=((UIButton *)sender);
    
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        
        if (netStatus == NotReachable)
        {
            [self HideActivityIndicator];
            alert=nil;
            alert=[[UIAlertView alloc]init];
            [alert setTitle:@"Warning"];
            [alert setMessage:@"No Internet Access"];
            [alert setCancelButtonIndex:[alert addButtonWithTitle:@"OK"]];
            [alert show];
        }
        else
        {
            NSString *post =[NSString stringWithFormat:@"http://dicoor.com/hackcl/?q=pickmeupedit&id=%@&status=%@&mback=%@",[[Info2 objectAtIndex:btn.tag] objectForKey:@"id"],@"client accepted",@"client accepted"];
            
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
                    [UIView animateWithDuration:0.7 animations:^{
                        UIImageView *accept  = [[UIImageView alloc] initWithFrame:CGRectMake(320-110, 20, 25, 25 )];
                        accept.image=[UIImage imageNamed:@"accepted.png"];
                        accept.backgroundColor = [UIColor whiteColor];
                        accept.contentMode = UIViewContentModeScaleAspectFill;
                        accept.clipsToBounds = YES;
                        accept.layer.cornerRadius=2;
                        [btn.superview addSubview:accept];
                        [[btn.superview viewWithTag:btn.tag-100]removeFromSuperview];
                        [btn.superview setFrame:CGRectMake(btn.superview.frame.origin.x, btn.superview.frame.origin.y, btn.superview.frame.size.width, btn.superview.frame.size.width-30)];
                        [[btn.superview viewWithTag:btn.tag]removeFromSuperview];
                        
                        
                    } completion:^ (BOOL finished){
                        if (finished) {
                           
                            
                        }}];
                    
                    [self HideActivityIndicator];
                    
                }
            }
            
            
        }
        
        
        [self HideActivityIndicator];
}


-(void)viewDidDisappear:(BOOL)animated
{
    Info1=nil;
    Info2=nil;
    [Info3 removeAllObjects];
    Info3=nil;
    InformationArray=nil;
    logtable=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
