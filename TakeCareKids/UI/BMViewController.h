//
//  BMViewController.h
//  KidMap
//
//  Created by Jeffrey Ma on 2/14/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "math.h"
#import "BMapKit.h"

@interface BMViewController : UIViewController<BMKGeneralDelegate, BMKMapViewDelegate,BMKSearchDelegate>
{
    BMKMapManager *mapManager;       
    BMKSearch* _search;//搜索要用到的
    BMKMapView* mapView;//地图视图
    IBOutlet UITextField* fromText;
    NSString  *cityStr;
    NSString *cityName;
    CLLocationCoordinate2D startPt;
    float localLatitude;
    float localLongitude;
    BOOL localJudge;
    NSMutableArray *pathArray;
    
    UITextField *lbl;
}
@property(nonatomic, retain) BMKMapManager* mapManager;

@property(nonatomic, retain) IBOutlet UITextField* fromText;
@property(nonatomic, retain) NSMutableArray * pathArray;
@property(nonatomic, retain) NSString * cityStr;
@property(nonatomic, retain) NSString * cityName;
@property(nonatomic, retain) BMKMapView * mapView;
@property(nonatomic, retain) BMKSearch * _search;

@property(nonatomic, assign) CLLocationCoordinate2D startPt;
@property(nonatomic, assign) float localLatitude;
@property(nonatomic, assign) float localLongitude;
@property(nonatomic, assign) BOOL localJudge;
@property(nonatomic, retain) UITextField *lbl;

@end
