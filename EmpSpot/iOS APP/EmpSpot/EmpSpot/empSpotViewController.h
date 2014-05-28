//
//  empSpotViewController.h
//  EmpSpot
//
//  Created by Varun Kubba on 02/05/14.
//  Copyright (c) 2014 clicklabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"
#import "AsyncImageView.h"
@interface empSpotViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASIHTTPRequestDelegate>
{
    UITableViewCell *cell;
    UILabel *employNameLabel;
    UIView *dividerView;
    UIImagePickerController *employImageController;
    UIView *imagePreviewView, *popUpView;
    ASIFormDataRequest *requestForEmployeeName;
    NSMutableArray *pinArray, *userIdArray, *userNameArray, *inoutFlagArray, *userImageArray, *sectionsAZ;
    UITableView *employTableView;
    UITextField *pinTextView;
    bool inButtonClicked;
    NSString *userId, *savedImagePath, *userName;
    NSString *letters;
    NSData *imageData;
    float imagewidth, imageheight;
    NSString* frndName;
    int l;
    NSArray *sectionArray;
    BOOL serverCallBool;
    UIImage *newImage;
}

@end
