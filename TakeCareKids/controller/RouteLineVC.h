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
<BMKMapViewDelegate, BMKSearchDelegate, BMKGeneralDelegate, MBProgressHUDDelegate,UISearchBarDelegate>
{
    UIToolbar *toolbar;
    BMKMapView* _mView;
    BMKSearch* _search;
    CLLocation *location;
    
    // used for drow route line.
    NSMutableArray *pointsArr;
    NSMutableArray *routePointsArr;
    
    
    BMKPolyline *routeLine;
    BMKPolylineView *routeLineView;
    
    BMKPolygon *polygon;
    BMKPolygonView *polygonView;
    
    // current location
    CLLocation* currentLocation;
    
    BOOL isRouting;
    BOOL stopRoute;
    
    MBProgressHUD *HUD;
    
    UISearchBar *srchBar;
}

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) BMKSearch *_search;
@property (nonatomic, retain) BMKMapView *mView;
@property (nonatomic, retain) CLLocation *location;

@property (nonatomic, retain) NSMutableArray *pointsArr;
@property (nonatomic, retain) NSMutableArray *routePointsArr;
@property (nonatomic, retain) BMKPolyline *routeLine;
@property (nonatomic, retain) BMKPolylineView *routeLineView;

@property (nonatomic, retain) BMKPolygon *polygon;
@property (nonatomic, retain) BMKPolygonView *polygonView;

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, assign) BOOL stopRoute;
@property (nonatomic, assign) IBOutlet UISearchBar *srchBar;

@property (nonatomic, retain) NSDictionary *terminalInfo;
@property (nonatomic, retain) MessageRouter *msgRouter;
@property (nonatomic, retain) NSMutableArray *dataArr;

- (id)initWithNibName:(NSString *)nibNameOrNil withInfo:(NSDictionary *) info;
@end
