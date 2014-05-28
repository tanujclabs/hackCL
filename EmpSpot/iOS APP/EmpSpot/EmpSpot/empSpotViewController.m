//
//  empSpotViewController.m
//  EmpSpot
//
//  Created by Varun Kubba on 02/05/14.
//  Copyright (c) 2014 clicklabs. All rights reserved.
//

#import "empSpotViewController.h"

@interface empSpotViewController ()

@end

@implementation empSpotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    l=1;

       NSString  *deviceType= [UIDevice currentDevice].model;
    NSLog(@"deviceType %@",deviceType);
    inoutFlagArray=[[NSMutableArray alloc] init];
    pinArray=[[NSMutableArray alloc] init];
    userIdArray=[[NSMutableArray alloc] init];
    userNameArray=[[NSMutableArray alloc] init];
    userImageArray=[[NSMutableArray alloc] init];
    
    letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    
    [self servercall];
    employTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 120, 768, 902)];
    employTableView.backgroundColor=[UIColor whiteColor];
    employTableView.delegate=self;
    employTableView.dataSource=self;
    employTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:employTableView];

    
    UIImageView *headerview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 120)];
    headerview.image=[UIImage imageNamed:@"header.png"];
    [self.view addSubview:headerview];
    
    sectionsAZ = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];


}

-(void)servercall
{
    serverCallBool=YES;
    requestForEmployeeName = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://67.202.34.113:2000/list_users"]];
    [requestForEmployeeName setPostValue:@"device_token" forKey:@"device_token"];
    [requestForEmployeeName setDelegate:self];
    [requestForEmployeeName startSynchronous];
 

}

-(void)tableviewUI
{
    [self servercall];


}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
            return sectionsAZ;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    sectionArray=[userNameArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", [sectionsAZ objectAtIndex:section]]];
    NSUInteger t= [sectionArray count];
    NSLog(@"sectionArray %@",sectionArray);
    NSLog(@"t== %lu",(unsigned long)t);
    return t;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,738,50)];
    [imageView setImage:[UIImage imageNamed:@"simple_bg.png"]];
    [headerView addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 738, 50)] ;
    label.text = [NSString stringWithFormat:@"   %@",[sectionsAZ objectAtIndex:section]];
    label.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *celId=@"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:celId];
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    else
    {
    }
    NSLog(@"l=%d",l);
    
    AsyncImageView*imageViewForPostcardSmal = [[AsyncImageView alloc] init];
    imageViewForPostcardSmal.backgroundColor=[UIColor whiteColor];
    imageViewForPostcardSmal.frame = CGRectMake(10, 15, 120, 120);
    NSURL *tempURL2=[NSURL URLWithString:[userImageArray objectAtIndex:indexPath.row]];
    imageViewForPostcardSmal.imageURL = tempURL2;
    imageViewForPostcardSmal.contentMode = UIViewContentModeScaleAspectFit;
    imageViewForPostcardSmal.clipsToBounds = YES;
    imageViewForPostcardSmal.backgroundColor=[UIColor darkGrayColor];
    [cell.contentView addSubview:imageViewForPostcardSmal];
    
    employNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, 50, 380, 50)];
    employNameLabel.font=[UIFont boldSystemFontOfSize:30];
    [cell.contentView addSubview:employNameLabel];

    
    sectionArray = [userNameArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", [sectionsAZ objectAtIndex:indexPath.section]]];
    NSArray* data = [[sectionArray objectAtIndex:indexPath.row ] componentsSeparatedByString: @"$$##"];
    NSLog(@"foo=%@",data);
    frndName = [data objectAtIndex:0];
    [employNameLabel setText:[NSString stringWithFormat:@"%@",frndName]];

    
    
    //employNameLabel.text=[userNameArray objectAtIndex:indexPath.row];
    
    UIButton *inButton=[[UIButton alloc] initWithFrame:CGRectMake(540, 30, 80, 80)];
    [inButton addTarget:self action:@selector(inButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [inButton setBackgroundImage:[UIImage imageNamed:@"in.png"] forState:UIControlStateNormal];
    [inButton setExclusiveTouch:YES];
    NSLog(@"l=%d",l);
    inButton.tag=l+1;
    [cell.contentView addSubview:inButton];
    
    UIButton *outButton=[[UIButton alloc] initWithFrame:CGRectMake(648, 30, 80, 80)];
    [outButton addTarget:self action:@selector(outButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [outButton setExclusiveTouch:YES];
    outButton.tag=l+10001;
    [outButton setBackgroundImage:[UIImage imageNamed:@"out.png"] forState:UIControlStateNormal];
    [cell.contentView addSubview:outButton];

    dividerView=[[UIView alloc] initWithFrame:CGRectMake(0, 149, 738, 1)];
    [dividerView setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:dividerView];
    
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    l++;
    return cell;
}

-(void)inButtonPressed:(UIButton *)sender
{
    NSLog(@"sender %d",[sender tag]);
    inButtonClicked=YES;
    
    NSLog(@"%@",[userNameArray objectAtIndex:sender.tag]);
    userName=[userNameArray objectAtIndex:sender.tag-2];
    userId=[userIdArray objectAtIndex:sender.tag-2];
    if([[inoutFlagArray objectAtIndex:sender.tag-2]intValue]==0)
    {
        popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
        UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        [leaveGroupView setTag:95002];
        UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
        UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okPinButton.frame=CGRectMake(50, 300, 170, 50);
        okPinButton.tag=sender.tag;
        [okPinButton setExclusiveTouch:YES];
        
        pinTextView=[[UITextField alloc] initWithFrame:CGRectMake(50, 200, 400, 50)];
        [pinTextView setSecureTextEntry:YES];
        pinTextView.keyboardType=UIKeyboardTypeNumberPad;
        pinTextView.placeholder=@" ENTER PIN";
        pinTextView.background=[UIImage imageNamed:@"textfield.png"];
        [pinTextView setFont:[UIFont boldSystemFontOfSize:30]];
        
        UIButton *cancelPinButton=[[UIButton alloc] initWithFrame:CGRectMake(280, 300, 170, 50)];
        [cancelPinButton setExclusiveTouch:YES];
        [cancelPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [cancelPinButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        
        [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
        
        blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
        
        UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        popTap.numberOfTapsRequired = 1;
        popUpView.userInteractionEnabled = YES;
        [popUpView addGestureRecognizer:popTap];
        
        
        [popheaderLabel setText:@"Authentication"];
        [popheaderLabel setTextColor:[UIColor whiteColor]];
        [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
        [popheaderLabel setBackgroundColor:[UIColor clearColor]];
        
        textlabel.numberOfLines = 5;
        [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
        [textlabel setText:@"Enter your Pin"];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
        [textlabel setTextAlignment:NSTextAlignmentCenter];
        
        [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [okPinButton addTarget:self action:@selector(okPinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popUpView];
        [popUpView addSubview:leaveGroupView];
        [leaveGroupView addSubview:blueStripView];
        [blueStripView addSubview:popheaderLabel];
        [leaveGroupView addSubview:textlabel];
        [leaveGroupView addSubview:cancelPinButton];
        [leaveGroupView addSubview:okPinButton];
        [leaveGroupView addSubview:pinTextView];
        [self attachPopUpAnimationToView:leaveGroupView];
        
    }
    else
    {
        popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
        UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        [leaveGroupView setTag:95002];
        UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
        UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okPinButton.frame=CGRectMake(150, 300, 200, 50);
        [okPinButton setExclusiveTouch:YES];
        
        
        [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
        
        blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
        
        UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        popTap.numberOfTapsRequired = 1;
        popUpView.userInteractionEnabled = YES;
        [popUpView addGestureRecognizer:popTap];
        
        
        [popheaderLabel setText:@"Error"];
        [popheaderLabel setTextColor:[UIColor whiteColor]];
        [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
        [popheaderLabel setBackgroundColor:[UIColor clearColor]];
        
        textlabel.numberOfLines = 5;
        [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
        [textlabel setText:@"Please Exit first"];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
        [textlabel setTextAlignment:NSTextAlignmentCenter];
        
        [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [okPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popUpView];
        [popUpView addSubview:leaveGroupView];
        [leaveGroupView addSubview:blueStripView];
        [blueStripView addSubview:popheaderLabel];
        [leaveGroupView addSubview:textlabel];
        [leaveGroupView addSubview:okPinButton];
        [self attachPopUpAnimationToView:leaveGroupView];

    }
    
  
}



-(void)outButtonPressed:(UIButton *)sender
{
    inButtonClicked=NO;
     NSLog(@"sender %d",[sender tag]);
    userId=[userIdArray objectAtIndex:sender.tag-10002];
    userName=[userNameArray objectAtIndex:sender.tag-10002];
    if([[inoutFlagArray objectAtIndex:sender.tag-10002]intValue]==1)
    {
        popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
        UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        [leaveGroupView setTag:95002];
        UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
        UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okPinButton.frame=CGRectMake(50, 300, 170, 50);
        okPinButton.tag=sender.tag;
        [okPinButton setExclusiveTouch:YES];
        
        pinTextView=[[UITextField alloc] initWithFrame:CGRectMake(50, 200, 400, 50)];
        [pinTextView setSecureTextEntry:YES];
        pinTextView.placeholder=@" ENTER PIN";
        pinTextView.keyboardType=UIKeyboardTypeNumberPad;
        pinTextView.background=[UIImage imageNamed:@"textfield.png"];
        [pinTextView setFont:[UIFont boldSystemFontOfSize:30]];
        
        UIButton *cancelPinButton=[[UIButton alloc] initWithFrame:CGRectMake(280, 300, 170, 50)];
        [cancelPinButton setExclusiveTouch:YES];
        [cancelPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [cancelPinButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        
        [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
        
        blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
        
        UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        popTap.numberOfTapsRequired = 1;
        popUpView.userInteractionEnabled = YES;
        [popUpView addGestureRecognizer:popTap];
        
        
        [popheaderLabel setText:@"Authentication"];
        [popheaderLabel setTextColor:[UIColor whiteColor]];
        [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
        [popheaderLabel setBackgroundColor:[UIColor clearColor]];
        
        textlabel.numberOfLines = 5;
        [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
        [textlabel setText:@"Enter your Pin"];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
        [textlabel setTextAlignment:NSTextAlignmentCenter];
        
        [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [okPinButton addTarget:self action:@selector(okOutPinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popUpView];
        [popUpView addSubview:leaveGroupView];
        [leaveGroupView addSubview:blueStripView];
        [blueStripView addSubview:popheaderLabel];
        [leaveGroupView addSubview:textlabel];
        [leaveGroupView addSubview:cancelPinButton];
        [leaveGroupView addSubview:okPinButton];
        [leaveGroupView addSubview:pinTextView];
        [self attachPopUpAnimationToView:leaveGroupView];
        
    }
    else
    {
        popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
        UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        [leaveGroupView setTag:95002];
        UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
        UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okPinButton.frame=CGRectMake(150, 300, 200, 50);
        [okPinButton setExclusiveTouch:YES];
        
        
        [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
        
        blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
        
        UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        popTap.numberOfTapsRequired = 1;
        popUpView.userInteractionEnabled = YES;
        [popUpView addGestureRecognizer:popTap];
        
        
        [popheaderLabel setText:@"Error"];
        [popheaderLabel setTextColor:[UIColor whiteColor]];
        [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
        [popheaderLabel setBackgroundColor:[UIColor clearColor]];
        
        textlabel.numberOfLines = 5;
        [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
        [textlabel setText:@"Please Enter first"];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
        [textlabel setTextAlignment:NSTextAlignmentCenter];
        
        [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [okPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popUpView];
        [popUpView addSubview:leaveGroupView];
        [leaveGroupView addSubview:blueStripView];
        [blueStripView addSubview:popheaderLabel];
        [leaveGroupView addSubview:textlabel];
        [leaveGroupView addSubview:okPinButton];
        [self attachPopUpAnimationToView:leaveGroupView];
        
    }
    
}

-(void)tapDetected
{
    [popUpView removeFromSuperview];
    popUpView=nil;
}

-(void)okPinButtonPressed:(UIButton *)sender
{
    [popUpView removeFromSuperview];
    popUpView=nil;
    
    NSLog(@"%ld",(long)[sender tag]);
    NSLog(@"pinarray %@",pinArray);
    NSLog(@"pin value=%@",[pinArray objectAtIndex:[sender tag]-1]);
    if([[pinArray objectAtIndex:sender.tag-1]intValue]==[pinTextView.text intValue])
    {
        employImageController=[[UIImagePickerController alloc] init];
        employImageController.delegate = self;
        employImageController.allowsEditing = YES;
        
        employImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
        employImageController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:employImageController animated:YES completion:NULL];
    }
    else
    {
        popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
        UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        [leaveGroupView setTag:95002];
        UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
        UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okPinButton.frame=CGRectMake(150, 300, 200, 50);
        [okPinButton setExclusiveTouch:YES];
        
        
        [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
        
        blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
        
        UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        popTap.numberOfTapsRequired = 1;
        popUpView.userInteractionEnabled = YES;
        [popUpView addGestureRecognizer:popTap];
        
        
        [popheaderLabel setText:@"Error"];
        [popheaderLabel setTextColor:[UIColor whiteColor]];
        [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
        [popheaderLabel setBackgroundColor:[UIColor clearColor]];
        
        textlabel.numberOfLines = 5;
        [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
        [textlabel setText:@"Wrong PIN"];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
        [textlabel setTextAlignment:NSTextAlignmentCenter];
        
        [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [okPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popUpView];
        [popUpView addSubview:leaveGroupView];
        [leaveGroupView addSubview:blueStripView];
        [blueStripView addSubview:popheaderLabel];
        [leaveGroupView addSubview:textlabel];
        [leaveGroupView addSubview:okPinButton];
        [self attachPopUpAnimationToView:leaveGroupView];

    }

}

-(void)okOutPinButtonPressed:(UIButton *)sender
{
    [popUpView removeFromSuperview];
    popUpView=nil;
    NSLog(@"pin value=%@",[pinArray objectAtIndex:[sender tag]-10001]);

    if([[pinArray objectAtIndex:sender.tag-10001]intValue]==[pinTextView.text intValue])
    {
        employImageController=[[UIImagePickerController alloc] init];
        employImageController.delegate = self;
        employImageController.allowsEditing = YES;
        
        employImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
        employImageController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:employImageController animated:YES completion:NULL];
    }
    else
    {
        popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
        UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
        UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        [leaveGroupView setTag:95002];
        UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
        UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
        UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okPinButton.frame=CGRectMake(150, 300, 200, 50);
        [okPinButton setExclusiveTouch:YES];
        
        
        [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
        [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
        
        blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
        
        UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
        popTap.numberOfTapsRequired = 1;
        popUpView.userInteractionEnabled = YES;
        [popUpView addGestureRecognizer:popTap];
        
        
        [popheaderLabel setText:@"Error"];
        [popheaderLabel setTextColor:[UIColor whiteColor]];
        [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
        [popheaderLabel setBackgroundColor:[UIColor clearColor]];
        
        textlabel.numberOfLines = 5;
        [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
        [textlabel setText:@"Wrong PIN"];
        [textlabel setBackgroundColor:[UIColor clearColor]];
        [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
        [textlabel setTextAlignment:NSTextAlignmentCenter];
        
        [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [okPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:popUpView];
        [popUpView addSubview:leaveGroupView];
        [leaveGroupView addSubview:blueStripView];
        [blueStripView addSubview:popheaderLabel];
        [leaveGroupView addSubview:textlabel];
        [leaveGroupView addSubview:okPinButton];
        [self attachPopUpAnimationToView:leaveGroupView];
        
    }

}

-(void)cancelPinButtonPressed
{
    [popUpView removeFromSuperview];
    popUpView=nil;
}

-(NSString *) genRandStringLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(25) % [letters length]]];
    }
    
    return randomString;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *uploadImage = [info objectForKey:UIImagePickerControllerEditedImage];

    CGRect rect=[[info objectForKey:@"UIImagePickerControllerCropRect"]CGRectValue];
    [self getImageOrientation:rect.size.width high:rect.size.height screenswidth:320 screenheight:320];

    newImage=[self resizeImage:uploadImage newSize:CGSizeMake(imagewidth, imageheight)];

    
    NSDate *date=[NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSString *dateString = [outputFormatter stringFromDate:date];
    
    NSLog(@"datestring=%@",dateString);
    NSString *str=[self genRandStringLength:10];
    NSLog(@"str=%@",str);
    NSString *timeStamp=[NSString stringWithFormat:@"%@%@",dateString,str];
    NSLog(@"timestamp=%@",timeStamp);

    NSString *documentsDirectory =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"/OfflineImages"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:NO attributes:nil error:nil];

    NSError *error;
    NSArray * docsdirectoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    docsdirectoryContents = [docsdirectoryContents filteredArrayUsingPredicate:
                             [NSPredicate predicateWithFormat:@"pathExtension ==[c] %@", @"jpeg"]];
    //int str=[[NSString stringWithFormat:@"%d",docsdirectoryContents.count]integerValue]+1;
    
    savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg",timeStamp ]] ;
    //  NSLog(@"path=%@",savedGroupImagePath);
     imageData= UIImageJPEGRepresentation(newImage, 0.5);
    //   NSLog(@"path=%@",imageData);
    [imageData writeToFile:savedImagePath atomically:YES];

    NSLog(@"savedImagePath--> %@",savedImagePath);
   // NSLog(@"imageData--> %@",imageData);
    
    imagePreviewView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    imagePreviewView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:imagePreviewView];
    
    UIImageView *headerImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 120)];
    headerImageview.image=[UIImage imageNamed:@"simple_header.png"];
    [imagePreviewView addSubview:headerImageview];
    
    employNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 120)];
    employNameLabel.text=userName;
    employNameLabel.textAlignment=NSTextAlignmentCenter;
    employNameLabel.textColor=[UIColor whiteColor];
    employNameLabel.font=[UIFont boldSystemFontOfSize:40];
    [imagePreviewView addSubview:employNameLabel];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 120, 768, 904)];
    imageView.image=uploadImage;
    [imagePreviewView addSubview:imageView];
    
    UIView *buttonsView=[[UIView alloc] initWithFrame:CGRectMake(0, 1024, 768, 168)];
    buttonsView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [imagePreviewView addSubview:buttonsView];
    
    [UIView animateWithDuration:1.0
                          delay:0.4
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^
     {
         [buttonsView setFrame:CGRectMake(0, 856, 768, 168)];
         
         
         
     } //196, 143, 89, 4
                     completion:^(BOOL finished){
                     }];
    
    UIButton *okButton=[[UIButton alloc] initWithFrame:CGRectMake(134, 60, 200, 50)];
    [okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [okButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [buttonsView addSubview:okButton];
    
    UIButton *cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(434, 60, 200, 50)];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [buttonsView addSubview:cancelButton];
    
    picker.delegate=nil;
    [picker dismissViewControllerAnimated:YES completion:nil];



    //[picker dismissModalViewControllerAnimated:YES];
    
//    UIImageView *cameraRollImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
//    
//    UIImage *image = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    [cameraRollImageView setImage:image];
//    
//    cameraRollImageView.userInteractionEnabled = YES;
//    
//    cameraRollImageView.multipleTouchEnabled = YES;
//    
//    int kMaxResolution = 1024;
//    
//    CGImageRef imgRef = image.CGImage;
//    
//    CGFloat widthR = CGImageGetWidth(imgRef);
//    
//    CGFloat heightR = CGImageGetHeight(imgRef);
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    CGRect bounds = CGRectMake(0, 0, widthR, heightR);
//    
//    if (widthR > kMaxResolution || heightR > kMaxResolution)
//        
//    {
//        
//        CGFloat ratio = widthR/heightR;
//        
//        if (ratio > 1)
//            
//        {
//            
//            bounds.size.width = kMaxResolution;
//            
//            bounds.size.height = roundf(bounds.size.width / ratio);
//            
//        }
//        
//        else
//            
//        {
//            
//            bounds.size.height = kMaxResolution;
//            
//            bounds.size.width = roundf(bounds.size.height * ratio);
//            
//        }
//        
//    }
//    
//    CGFloat scaleRatio = bounds.size.width / widthR;
//    
//    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
//    
//    CGFloat boundHeight;
//    
//    UIImageOrientation orient = image.imageOrientation;
//    
//    switch(orient) {
//            
//        case UIImageOrientationUp: //EXIF = 1
//            
//            transform = CGAffineTransformIdentity;
//            
//            break;
//            
//        case UIImageOrientationUpMirrored: //EXIF = 2
//            
//            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
//            
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            
//            break;
//            
//        case UIImageOrientationDown: //EXIF = 3
//            
//            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
//            
//            transform = CGAffineTransformRotate(transform, M_PI);
//            
//            break;
//            
//        case UIImageOrientationDownMirrored: //EXIF = 4
//            
//            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
//            
//            transform = CGAffineTransformScale(transform, 1.0, -1.0);
//            
//            break;
//            
//        case UIImageOrientationLeftMirrored: //EXIF = 5
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
//            
//            transform = CGAffineTransformScale(transform, -1.0, 1.0);
//            
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            
//            break;
//            
//        case UIImageOrientationLeft: //EXIF = 6
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
//            
//            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//            
//            break;
//            
//        case UIImageOrientationRightMirrored: //EXIF = 7
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeScale(-1.0, 1.0);
//            
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            
//            break;
//            
//        case UIImageOrientationRight: //EXIF = 8
//            
//            boundHeight = bounds.size.height;
//            
//            bounds.size.height = bounds.size.width;
//            
//            bounds.size.width = boundHeight;
//            
//            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
//            
//            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//            
//            break;
//            
//        default:
//            
//            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
//            
//    }
//    
//    UIGraphicsBeginImageContext(bounds.size);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
//        
//    {
//        
//        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
//        
//        CGContextTranslateCTM(context, -heightR, 0);
//        
//    }
//    
//    else
//        
//    {
//        
//        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//        
//        CGContextTranslateCTM(context, 0, -heightR);
//        
//    }
//    
//    CGContextConcatCTM(context, transform);
//    
//    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, widthR, heightR), imgRef);
//    
//    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
//    
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"selectedImage.png"];
//    
//    
//    
//    imageData = UIImagePNGRepresentation(imageCopy);
//    
//    NSLog(@"imageCopy=%@",imageCopy);
//    
//    [imageData writeToFile:savedImagePath atomically:NO];
//    
//    NSLog(@"print");
//    
    
    
   
    

}

-(void)getImageOrientation:(float )width high:(float )height screenswidth:(float)screenWidth screenheight:(float)screenHeight
{
    if(width<screenWidth && height<screenHeight)
    {
        imagewidth = width;
        imageheight = height;
    }
    else if (width >=screenWidth && height >= screenHeight)
        
    {
        NSLog(@"width=%f",width-screenWidth);
        NSLog(@"height=%f",height-screenHeight);
        if(width-screenWidth >= height-screenHeight)
            
        {
            float newHeight = (height/width)*screenHeight;    //imageviewHeight
            imagewidth = screenWidth;
            imageheight = newHeight;
            
        }
        else if(width-screenWidth < height-screenHeight)
        {
            float newWidth = (width/height)*screenHeight;
            imagewidth = newWidth;
            imageheight = screenHeight;
        }
        
    }else if (width >= screenWidth && height < screenHeight)
        
    {
        float newHeight = (height/width)*screenWidth;
        imagewidth = screenWidth;
        imageheight = newHeight;
        
    }
    else if (width < screenWidth && height > screenHeight)
        
    {
        float newWidth = (width/height)*screenHeight;
        imagewidth = newWidth;
        imageheight = screenHeight;
        
    }
    else if (width == screenWidth && height == screenHeight)
    {
        imagewidth = screenWidth;
        imageheight = screenHeight;
    }
    
    NSLog(@"width=%f",imagewidth);
    NSLog(@"height=%f",imageheight);
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (void)requestStarted:(ASIHTTPRequest *)request

{
    NSLog(@"starteeeddd");
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    
    NSLog(@"error %@",error);
    
    popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
    UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
    [leaveGroupView setTag:95002];
    UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
    UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
    UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okPinButton.frame=CGRectMake(150, 300, 200, 50);
    [okPinButton setExclusiveTouch:YES];
    
    
    [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
    [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
    
    blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
    
    UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
    popTap.numberOfTapsRequired = 1;
    popUpView.userInteractionEnabled = YES;
    [popUpView addGestureRecognizer:popTap];
    
    
    [popheaderLabel setText:@"Error"];
    [popheaderLabel setTextColor:[UIColor whiteColor]];
    [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
    [popheaderLabel setBackgroundColor:[UIColor clearColor]];
    
    textlabel.numberOfLines = 5;
    [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
    [textlabel setText:@"Cannot connect to server"];
    [textlabel setBackgroundColor:[UIColor clearColor]];
    [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
    [textlabel setTextAlignment:NSTextAlignmentCenter];
    
    [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [okPinButton addTarget:self action:@selector(cancelPinButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popUpView];
    [popUpView addSubview:leaveGroupView];
    [leaveGroupView addSubview:blueStripView];
    [blueStripView addSubview:popheaderLabel];
    [leaveGroupView addSubview:textlabel];
    [leaveGroupView addSubview:okPinButton];
    [self attachPopUpAnimationToView:leaveGroupView];
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [userNameArray removeAllObjects];
    [userIdArray removeAllObjects];
    [userImageArray removeAllObjects];
    [pinArray removeAllObjects];
    [inoutFlagArray removeAllObjects];
    if(serverCallBool==YES)
    {
        NSString *responseString = [request responseString];
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"json--> %@",json);
        NSArray *datas=[json objectForKey:@"data"];
        NSLog(@"data-->%@",datas);
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"user_name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *sortedArray=[datas sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        NSLog(@"data: %@",sortedArray);
        
        
        
        for(NSString *k in sortedArray)
        {
            [userNameArray addObject:[(NSDictionary *)k objectForKey:@"user_name"]];
            [userIdArray addObject:[(NSDictionary *)k objectForKey:@"user_id"]];
            [inoutFlagArray addObject:[(NSDictionary *)k objectForKey:@"in_out_flag"]];
            [pinArray addObject:[(NSDictionary *)k objectForKey:@"pin"]];
            [userImageArray addObject:[(NSDictionary *)k objectForKey:@"user_image"]];
        }
        NSLog(@"userNameArray--> %@",userNameArray);
        NSLog(@"userIdArray--> %@",userIdArray);
        NSLog(@"inoutFlagArray--> %@",inoutFlagArray);
        NSLog(@"pinArray--> %@",pinArray);
        NSLog(@"userImageArray--> %@",userImageArray);
        
    }
    else
    {
        NSString *responseString = [request responseString];
        
        NSData* data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"json--> %@",json);
        NSString *error=[(NSDictionary *)json objectForKey:@"error"];
        NSString *log=[(NSDictionary *)json objectForKey:@"log"];
        NSLog(@"error %@",error);
        if([error isEqualToString:@"No file to upload"])
        {
            popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
            UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
            UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
            [leaveGroupView setTag:95002];
            UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
            UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
            UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okPinButton.frame=CGRectMake(150, 300, 200, 50);
            [okPinButton setExclusiveTouch:YES];
            
            
            [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
            [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
            
            blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
            
            UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
            popTap.numberOfTapsRequired = 1;
            popUpView.userInteractionEnabled = YES;
            [popUpView addGestureRecognizer:popTap];
            
            
            [popheaderLabel setText:@"Error"];
            [popheaderLabel setTextColor:[UIColor whiteColor]];
            [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
            [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
            [popheaderLabel setBackgroundColor:[UIColor clearColor]];
            
            textlabel.numberOfLines = 5;
            [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
            [textlabel setText:error];
            [textlabel setBackgroundColor:[UIColor clearColor]];
            [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
            [textlabel setTextAlignment:NSTextAlignmentCenter];
            
            [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
            [okPinButton addTarget:self action:@selector(okButtonPopUpPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:popUpView];
            [popUpView addSubview:leaveGroupView];
            [leaveGroupView addSubview:blueStripView];
            [blueStripView addSubview:popheaderLabel];
            [leaveGroupView addSubview:textlabel];
            [leaveGroupView addSubview:okPinButton];
            [self attachPopUpAnimationToView:leaveGroupView];

        }
        else if ([error isEqualToString:@""])
        {
            popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
            UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
            UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
            [leaveGroupView setTag:95002];
            UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
            UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
            UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okPinButton.frame=CGRectMake(150, 300, 200, 50);
            [okPinButton setExclusiveTouch:YES];
            
            
            [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
            [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
            
            blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
            
            UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
            popTap.numberOfTapsRequired = 1;
            popUpView.userInteractionEnabled = YES;
            [popUpView addGestureRecognizer:popTap];
            
            
            [popheaderLabel setText:@"Error"];
            [popheaderLabel setTextColor:[UIColor whiteColor]];
            [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
            [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
            [popheaderLabel setBackgroundColor:[UIColor clearColor]];
            
            textlabel.numberOfLines = 5;
            [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
            [textlabel setText:error];
            [textlabel setBackgroundColor:[UIColor clearColor]];
            [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
            [textlabel setTextAlignment:NSTextAlignmentCenter];
            
            [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
            [okPinButton addTarget:self action:@selector(okButtonPopUpPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:popUpView];
            [popUpView addSubview:leaveGroupView];
            [leaveGroupView addSubview:blueStripView];
            [blueStripView addSubview:popheaderLabel];
            [leaveGroupView addSubview:textlabel];
            [leaveGroupView addSubview:okPinButton];
            [self attachPopUpAnimationToView:leaveGroupView];

        }
        else if (log.length!=0)
        {
            popUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
            UIView *leaveGroupView = [[UIView alloc]initWithFrame:CGRectMake(134, 312, 500, 400)];
            UIImageView *blueStripView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
            [leaveGroupView setTag:95002];
            UILabel *popheaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 40)];
            UILabel *textlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 500, 40)];
            UIButton *okPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
            okPinButton.frame=CGRectMake(150, 300, 200, 50);
            [okPinButton setExclusiveTouch:YES];
            
            
            [popUpView setBackgroundColor:[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.7]];
            [leaveGroupView setBackgroundColor:[UIColor whiteColor]];
            
            blueStripView.image=[UIImage imageNamed:@"simple_bg.png"];
            
            UITapGestureRecognizer *popTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected)];
            popTap.numberOfTapsRequired = 1;
            popUpView.userInteractionEnabled = YES;
            [popUpView addGestureRecognizer:popTap];
            
            
            [popheaderLabel setText:@"Success"];
            [popheaderLabel setTextColor:[UIColor whiteColor]];
            [popheaderLabel setFont:[UIFont boldSystemFontOfSize:30]];
            [popheaderLabel setTextAlignment:NSTextAlignmentCenter];
            [popheaderLabel setBackgroundColor:[UIColor clearColor]];
            
            textlabel.numberOfLines = 5;
            [textlabel setTextColor:[UIColor colorWithRed:37.0/255 green:53.0/255 blue:53.0/255 alpha:1.0]];
            [textlabel setText:log];
            [textlabel setBackgroundColor:[UIColor clearColor]];
            [textlabel setFont:[UIFont boldSystemFontOfSize:30]];
            [textlabel setTextAlignment:NSTextAlignmentCenter];
            
            [okPinButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
            [okPinButton addTarget:self action:@selector(okButtonPopUpPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:popUpView];
            [popUpView addSubview:leaveGroupView];
            [leaveGroupView addSubview:blueStripView];
            [blueStripView addSubview:popheaderLabel];
            [leaveGroupView addSubview:textlabel];
            [leaveGroupView addSubview:okPinButton];
            [self attachPopUpAnimationToView:leaveGroupView];

        }
    }
    
    
}

-(void)okButtonPopUpPressed
{
    l=1;
    [imagePreviewView removeFromSuperview];
    imagePreviewView=nil;
    [popUpView removeFromSuperview];
    popUpView=nil;
    [self cancelButtonClicked];
    [self servercall];
    
    
    [employTableView reloadData];
}

-(void)okButtonClicked
{

    serverCallBool=NO;
    if(inButtonClicked==YES)
    {
        NSLog(@"savedImagePath--> %@",savedImagePath);

        ASIFormDataRequest *_requestForEntry = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://67.202.34.113/nodeTraining/empspot/index.php?action=attendance"]];
        __weak ASIFormDataRequest *requestForEntry = _requestForEntry;
        [requestForEntry setPostValue:userId forKey:@"user_id"];
        [requestForEntry setPostValue:@"1" forKey:@"in_out_flag"];
        [requestForEntry setFile:savedImagePath forKey:@"image"];
        [requestForEntry setTimeOutSeconds:60];
        [requestForEntry setDelegate:self];
        [requestForEntry startAsynchronous];

        
        
        
        
        //        [requestForEntry setCompletionBlock:^{
//      
//            NSString *json1= [requestForEntry responseString];
//            NSLog(@"json=%@",json1);
//            NSData* data = [json1 dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//
////            NSDictionary *json = [[NSDictionary alloc] init];
//            NSError *error;
////            NSMutableDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//
//            NSData *jsonData = [json1 dataUsingEncoding:NSUTF8StringEncoding];
//            
//            json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//            
//            NSLog(@"imagePostJson=%@", error);
//            [requestForEntry setDelegate:nil];
//
//
//        }];
//        
//        [requestForEntry setFailedBlock:^{
//
//            [requestForEntry setDelegate:nil];
//        }];
       
        
        
        
    
        
//        dispatch_queue_t q_background = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
//        dispatch_async(q_background, ^{
//            
//            NSURL *submiturl = [[NSURL alloc] initWithString:@"http://67.202.34.113:2000/attendance_entry"];
//          ASIFormDataRequest *Request = [ASIFormDataRequest requestWithURL:submiturl];
//            
//            
//                //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//               //NSString *documentsDirectory = [paths objectAtIndex:0];
////                NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"selectedImage.png"];
////                NSLog(@"filePath=%@",filePath);
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//            NSString *documentsDirectory = [paths objectAtIndex:0];
//            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"selectedImage.png"];
//            NSLog(@"filePath=%@",filePath);
//            [Request setTimeOutSeconds:300];
//                [Request setFile:filePath forKey:@"image"];
//                [Request setPostValue:@"1" forKey:@"in_out_flag"];
//                NSLog(@"user_id=%@",userId);
//                [Request setPostValue:userId forKey:@"user_id"];
//    
//           
//            [Request setDelegate:self];
//            [Request startSynchronous];
//            
//            
//            
//        });
        
        

    }
    else
    {
        ASIFormDataRequest *_requestForEntry = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://67.202.34.113/nodeTraining/empspot/index.php?action=attendance"]];
        __weak ASIFormDataRequest *requestForEntry = _requestForEntry;
        
        NSLog(@"userId%@",userId);
        NSLog(@"savedImagePath %@",imageData);
        [requestForEntry setPostValue:userId forKey:@"user_id"];
        [requestForEntry setPostValue:@"0" forKey:@"in_out_flag"];
        [requestForEntry setFile:savedImagePath forKey:@"image"];
        [requestForEntry setTimeOutSeconds:60];
        [requestForEntry setDelegate:self];
        [requestForEntry startAsynchronous];

    }
}

-(void)cancelButtonClicked
{
    [imagePreviewView removeFromSuperview];
    imagePreviewView=nil;
}

- (void)attachPopUpAnimationToView:(UIView *)myView
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    NSArray *frameValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:scale1], [NSValue valueWithCATransform3D:scale2],[NSValue valueWithCATransform3D:scale3],[NSValue valueWithCATransform3D:scale4],nil];
    [animation setValues:frameValues];
    NSArray *frameTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:1.0], nil];
    [animation setKeyTimes:frameTimes];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.5;
    [myView.layer addAnimation:animation forKey:@"popup"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
