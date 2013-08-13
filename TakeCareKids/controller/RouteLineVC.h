//
//  RouteLineVC.h
//  BaiduDemo
//
//  Created by jian zhang on 12-5-7.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "math.h"
#import "BaseViewController.h"
#import "BMapKit.h"

@interface RouteLineVC : BaseViewController
<BMKMapViewDelegate, MBProgressHUDDelegate, UIActionSheetDelegate>
{
}

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) BMKMapView *mpView;
@property (nonatomic, retain) CLLocation *location;

@property (nonatomic, retain) BMKPolyline *routeLine;
@property (nonatomic, retain) BMKPolylineView *routeLineView;

@property (nonatomic, retain) BMKPolygon *polygon;
@property (nonatomic, retain) BMKPolygonView *polygonView;

@property (nonatomic, retain) CLLocation *currentLocation;

@property (nonatomic, retain) NSDictionary *terminalInfo;
@property (nonatomic, retain) MessageRouter *msgRouter;
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) UIDatePicker *pickerBt;
@property (nonatomic, retain) UIDatePicker *pickerEt;


- (id)initWithNibName:(NSString *)nibNameOrNil withInfo:(NSDictionary *) info;
@end
