//
//  QieziViewController.h
//  BaiduDemo
//
//  Created by jian zhang on 12-5-7.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "math.h"
#import "BaseViewController.h"
#import "BMapKit.h"

@interface QieziViewController : BaseViewController
<BMKMapViewDelegate, BMKSearchDelegate, BMKGeneralDelegate>
{
    BMKMapView* mView;
    BMKSearch* _search;
    CLLocation *location;
    
    // used for drow route line.
    NSMutableArray *pointsArr;
    NSMutableArray *routePointsArr;

    
    BMKPolyline *routeLine;
    BMKPolylineView *routeLineView;

    // current location
    CLLocation* currentLocation;
    
    BOOL isRouting;
    BOOL stopRoute;
}

@property (nonatomic, retain) BMKSearch *_search;
@property (nonatomic, retain) BMKMapView *mView;
@property (nonatomic, retain) CLLocation *location;

@property (nonatomic, retain) NSMutableArray *pointsArr;
@property (nonatomic, retain) NSMutableArray *routePointsArr;
@property (nonatomic, retain) BMKPolyline *routeLine;
@property (nonatomic, retain) BMKPolylineView *routeLineView;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) BOOL isRouting;
@property (nonatomic, assign) BOOL stopRoute;
@end
