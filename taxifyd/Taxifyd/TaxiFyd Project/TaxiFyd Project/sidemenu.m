//
//  sidemenu.m
//  IdealApp
//
//  Created by Click Labs on 2/12/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "sidemenu.h"
#import "homeVC.h"
#import "AsyncImageView.h"
#import "TaxifydViewController.h"
#import "DriverVC.h"
#import "ProfileDriverViewController.h"
#import "logcustomerVC.h"
static sidemenu *menu;
@implementation sidemenu
{
    NSArray *menu_img;
    int row_size;
    CGSize view_size;
    int font_size;
    UIViewController *main_view;
    UIAlertView *alertView;
    UIView *menu_view;
    BOOL isUser;
    NSArray *menu_name;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+(sidemenu *) shared{
    if(!menu){
        menu = [[sidemenu alloc] init];
    }
    return menu;
}
- (void)loadView:(UIViewController *)selfView withView:(UIView *)subView
{
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"usertype"] lowercaseString] isEqualToString:@"user"])
        isUser=TRUE;
    else
        isUser=FALSE;

    main_view=selfView;
    selfView.view.userInteractionEnabled=YES;
    
    NSLog(@"animation start");
    if(isUser)
    {
        menu_img=[[NSArray alloc]initWithObjects: @"home.png",@"logs.png",@"log-out.png", nil];
    
        menu_name=[[NSArray alloc]initWithObjects:@"Home",@"Logs" ,@"Logout", nil];
    }
    else
    {
        menu_img=[[NSArray alloc]initWithObjects: @"home.png",@"profile.png",@"log-out.png", nil];
        
        menu_name=[[NSArray alloc]initWithObjects:@"Home",@"Profile",@"Logout", nil];
    }
    m_view =[[UIView alloc]init];//WithFrame:CGRectMake(0, 0, 100, selfView.frame.size.height)];
    
    m_view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"driverback.jpg"]];// colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    [m_view setUserInteractionEnabled:TRUE];
    
    menu_view=[[UIView alloc]init];
    menu_view.backgroundColor=[UIColor colorWithWhite:0.2 alpha:0.9];
    menu_view.userInteractionEnabled=YES;
    [m_view addSubview:menu_view];
    
    AsyncImageView *userImage  = [[AsyncImageView alloc] init];
    userImage.backgroundColor = [UIColor whiteColor];
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.clipsToBounds = YES;
    NSURL *tempURL=[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"image_url"]];
    userImage.imageURL = tempURL;
    tempURL=nil;
    [menu_view addSubview:userImage];
    
    UILabel *titlelbl=[[UILabel alloc]init];
    titlelbl.numberOfLines=2;
    titlelbl.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    titlelbl.font=[UIFont fontWithName:@"CenturyGothic-Bold" size:20];
    titlelbl.textAlignment=NSTextAlignmentCenter;
    titlelbl.textColor=[UIColor whiteColor];
    titlelbl.backgroundColor=[UIColor clearColor];
    [menu_view addSubview:titlelbl];
    
    UITableView *tab=[[UITableView alloc]init];//WithFrame:CGRectMake(0, 0, m_view.frame.size.width, m_view.frame.size.height)];
    
    tab.delegate=self;
    
    tab.dataSource=self;
    
    tab.backgroundColor=[UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:0.7];
    
    tab.userInteractionEnabled=YES;
    
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(selfView.view.frame.size.height > 568.0f)
        {
            font_size=20;
            view_size.height=selfView.view.frame.size.height;
            view_size.width=200;
            row_size=130;
        }
        else
        {
            if (selfView.view.frame.size.height > 480.0f)
            {
                font_size=12;
                view_size.height=selfView.view.frame.size.height;
                view_size.width=240;
                row_size=50;
            }
            else
            {
                font_size=16;
                view_size.height=selfView.view.frame.size.height;
                view_size.width=240;
                row_size=50;
                
            }
        }
    menu_view.frame=CGRectMake(0, 0, view_size.width, view_size.height);
    tab.frame=CGRectMake(0, 150, view_size.width, view_size.height);
    titlelbl.frame=CGRectMake(00,115, view_size.width, 30);
    userImage.frame=CGRectMake(0, 0, 100, 100);
    userImage.center=CGPointMake(120, 60);
    userImage.layer.cornerRadius=50;
    
    [menu_view addSubview:tab];
    m_view.frame = CGRectMake(-view_size.width,0,view_size.width,view_size.height);
    [selfView.view addSubview:m_view];
    [UIView animateWithDuration:0.2
                     animations:^{
                         subView.frame=CGRectMake(view_size.width,0,selfView.view.frame.size.width,selfView.view.frame.size.height);
                         m_view.frame=CGRectMake(0, 0, view_size.width, view_size.height);
                        
                     }
                     completion:^(BOOL finished){
                     }];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Row Selected  : %d",indexPath.row);
    switch (indexPath.row) {
        case 0:
        {
            if(isUser)
            {
                homeVC *home = [[homeVC alloc] init];
                [main_view.navigationController pushViewController:home animated:NO];
                [[sidemenu shared]removeView:main_view.view];
            }
            else
            {
                DriverVC *home = [[DriverVC alloc] init];
                [main_view.navigationController pushViewController:home animated:NO];
                [[sidemenu shared]removeView:main_view.view];
            }
            break;
        }
        case 1:
        {
            if(isUser)
            {
                logcustomerVC *cust = [[logcustomerVC alloc] init];
                [main_view.navigationController pushViewController:cust animated:NO];
                [[sidemenu shared]removeView:main_view.view];
            }
            else
            {
                ProfileDriverViewController *profile = [[ProfileDriverViewController alloc] init];
                [main_view.navigationController pushViewController:profile animated:NO];
                [[sidemenu shared]removeView:main_view.view];
            }
            break;
        }
        
        case 2:
        {
            NSLog(@"Logout Selected");
            alertView=nil;
            alertView = [[UIAlertView alloc] initWithTitle:@"Log Out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm",nil];
            alertView.tag=1;
            alertView.delegate=self;
            [alertView show];
            break;
            break;
        }
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return row_size;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menu_name.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor=[UIColor clearColor];
    UIImageView *img_plan=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[menu_img objectAtIndex:indexPath.row]]];
    img_plan.frame=CGRectMake(12,5, img_plan.image.size.width/2+10,img_plan.image.size.height/2+10);
    [cell.contentView addSubview:img_plan];
    UILabel *menu_lbl=[[UILabel alloc]init];//WithFrame:CGRectMake(0,row_size-20, view_size.width, 20)];
    
    UIImageView *divider=[[UIImageView alloc]init];
    divider.image=[UIImage imageNamed:@"divider_line.png"];
    if(row_size>70)
    {
        divider.frame=CGRectMake(0, row_size-4, view_size.width ,4);
        menu_lbl.frame=CGRectMake(15,10, view_size.width, 20);
    }
    else
    {
        divider.frame=CGRectMake(0, row_size-2, view_size.width ,2);
        menu_lbl.frame=CGRectMake(60,10, view_size.width-120, 20);
    }
    
    
    [menu_lbl adjustsFontSizeToFitWidth];
    menu_lbl.numberOfLines=2;
    menu_lbl.textAlignment=NSTextAlignmentLeft;
    menu_lbl.text=[menu_name objectAtIndex:indexPath.row];
    [menu_lbl setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:font_size]];
    menu_lbl.textColor=[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    [cell.contentView addSubview:menu_lbl];
   
    [cell.contentView addSubview:divider];
    
    return cell;
}
-(void)removeView :(UIView *)selfView

{
    NSLog(@"animation Stop");
    selfView.userInteractionEnabled=YES;
    [UIView animateWithDuration:0.2
                     animations:^{
                         m_view.frame=CGRectMake(-view_size.width, 0, view_size.width, view_size.height);
                         selfView.frame=CGRectMake(0,0,selfView.frame.size.width,selfView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [m_view removeFromSuperview];
                         
                     }];
    
    
}
-(void)alertView:(UIAlertView *)myalertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[soundManager shared] buttonSound];
    if(myalertView.tag==1)
    {
        if (buttonIndex==0)
        {
        }
        else if(buttonIndex ==1)
        {
            [FBSession.activeSession closeAndClearTokenInformation];
            [FBSession.activeSession close];
            [FBSession setActiveSession:nil];
            
            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            
            NSString *token = [[NSString alloc] init];
            
            token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"device_token"]];
            
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
            
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"device_token"];
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"LogoutScussessFully"];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstTimeLoginYes"];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"facebookLogin"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSArray *viewContrlls=[[main_view navigationController] viewControllers];
            for( int i=0;i<[ viewContrlls count];i++)
            {
                id obj=[viewContrlls objectAtIndex:i];
                if([obj isKindOfClass:[TaxifydViewController class]])
                {
                    [[main_view navigationController] popToViewController:obj animated:YES];
                    return;
                }
                
            }
            
            
        }
        
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"access_token"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"access_token"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"FBuserID"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FBuserID"];
            //
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"image_url"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"image_url"];
            //
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"name"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"name"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"FBgender"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FBgender"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"FBemail"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FBemail"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"email"];
            //            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
            //
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"FbAccessTokenKey"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"FbAccessTokenKey"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"facebookLogin"];
            //            [[NSUserDefaults standardUserDefaults] setObject:@"(null)" forKey:@"score"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"facebookLogin"];
            //
            //            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"EmailLogin"];
            //            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EmailLogin"];
            //        
            //            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"loginButtonSelect"];
            //            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        
    }


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
