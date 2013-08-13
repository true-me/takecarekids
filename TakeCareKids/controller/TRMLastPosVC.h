//
//  TRMLastPosVC.h
//  TakeCareKids
//
//  Created by Jeffrey Ma on 7/19/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MapPointAnnotion.h"
#import "MBProgressHUD.h"
#import "math.h"
#import "BaseViewController.h"
#import "LoginController.h"

@interface TRMLastPosVC : BaseViewController<BMKMapViewDelegate, MBProgressHUDDelegate, loginDelegate>
@property (nonatomic, retain) BMKMapView* mpView;
@property (nonatomic, retain) NSDictionary *terminalInfo;
@property (nonatomic, retain) MessageRouter *msgRouter;
@property (nonatomic, retain) NSMutableArray *dataArr;
@end
