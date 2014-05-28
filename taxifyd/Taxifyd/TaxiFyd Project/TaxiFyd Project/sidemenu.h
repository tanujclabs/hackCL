//
//  sidemenu.h
//  IdealApp
//
//  Created by Click Labs on 2/12/14.
//  Copyright (c) 2014 Click Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface sidemenu : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UIView *m_view;
}
- (void)loadView:(UIViewController *)selfView withView:(UIView *)subView;
-(void)removeView:(UIView *)selfView;
+(sidemenu *)shared;

@end
