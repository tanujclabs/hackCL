//
//  Navigation.m
//  IdealApp
//
//  Created by Click Labs on 2/7/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import "Navigation.h"

@implementation Navigation
{
    int font_size;
}
-(UINavigationBar *) addNavigation:(NSString *)titleText withView:(UIView *)myview
{
    @autoreleasepool {
         UINavigationBar *navBar = [[UINavigationBar alloc] init];
        [navBar setBackgroundImage:[UIImage imageNamed:@"header.png"]
                    forBarPosition:UIBarPositionAny
                        barMetrics:UIBarMetricsDefault];
        UILabel *lbl=[[UILabel alloc]init];
        lbl.text=titleText;
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.textColor=[UIColor whiteColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone||UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(myview.frame.size.height > 568.0f)
            {
                font_size=36;
                navBar.frame=CGRectMake(0, 0, myview.frame.size.width, 80);
                lbl.frame=CGRectMake(0, 30, myview.frame.size.width-10, 50);
              
            }
            else
            {
                font_size=20;
                navBar.frame=CGRectMake(-5, 0, myview.frame.size.width+5, 50);
                lbl.frame=CGRectMake(0, 10, myview.frame.size.width-10, 30);
            }

        }
       [lbl setFont:[UIFont fontWithName:@"CenturyGothic-Bold" size:font_size]];
       [navBar addSubview:lbl];
        return navBar;
    }
}
-(void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont andColor:(UIColor*)color{
    @autoreleasepool {
        CGSize size = CGSizeMake(320, 44);
        
        UIGraphicsBeginImageContext(size);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGRect fillRect = CGRectMake(0,0,size.width,size.height);
        CGContextSetFillColorWithColor(currentContext, color.CGColor);
        CGContextFillRect(currentContext, fillRect);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        UINavigationBar* navAppearance = [UINavigationBar appearance];
        
        [navAppearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    
}
@end
