//
//  QieziViewController.m
//  BaiduDemo
//
//  Created by jian zhang on 12-5-7.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import "QieziViewController.h"
#import "MapPointAnnotion.h"

#define MAP_ANNVIEW_I_TAG 78000
#define TAG_ALERT_LOGIN 56
#define TAG_ALERT_LOGOUT 57

@implementation QieziViewController
BMKMapManager* _mapManager;

@synthesize toolbar;
@synthesize _search;
@synthesize mView;
@synthesize location;
@synthesize pointsArr;
@synthesize routePointsArr;
@synthesize routeLine;
@synthesize routeLineView;
@synthesize polygon;
@synthesize polygonView;
@synthesize currentLocation;
@synthesize isRouting;
@synthesize stopRoute;
@synthesize srchBar;
- (void)dealloc
{
    [_search release];
    [location release];
    [pointsArr release];
    [routeLine release];
    [routeLineView release];
    [polygon release];
    [polygonView release];
    [currentLocation release];
    [routePointsArr release];
    [mView release];
    [srchBar release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //self.title = NSLocalizedString(@"轨迹回放", @"轨迹回放");
        [self setupTitleView:@"关注孩子"];
        //self.tabBarItem.image = [UIImage imageNamed:@"Third"];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - 百度地图
#pragma mark-
#pragma mark 定位委托
//开始定位
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    
    NSLog(@"开始定位");
}

//更新坐标

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    
    NSLog(@"更新坐标");
    
    
    CLLocation *locationOne = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude
                                                         longitude:userLocation.coordinate.longitude];
    // check the zero point
    if  (userLocation.coordinate.latitude == 0.0f ||
         userLocation.coordinate.longitude == 0.0f)
        return;
    
    // check the move distance
    if (self.pointsArr.count > 0)
    {
        CLLocationDistance distance = [locationOne distanceFromLocation:self.location];
        if (distance < 5)
        {
            NSLog(@"距离过短不更新");
            self.location = userLocation.location;
            if (!mapView.isUserLocationVisible)
            {
                [mapView setCenterCoordinate:userLocation.location.coordinate];
                mapView.showsUserLocation = YES;
                
            }
            else
            {
                [mapView setCenterCoordinate:userLocation.location.coordinate];
                [mapView setShowsUserLocation:YES];
            }
            return;
        }
    }
    
    if (nil == self.pointsArr) {
        self.pointsArr = [[NSMutableArray alloc] init];
    }
    
    self.location = userLocation.location;
    
    //给view中心定位
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.25;
    region.span.longitudeDelta = 0.25;
    mapView.region   = region;
    mapView.zoomLevel = 16;
    
    //mapView.zoomLevel = 3;
    //加个当前坐标的小气泡
    BOOL ret = [_search reverseGeocode:userLocation.location.coordinate];
    // mapView.showsUserLocation = NO;
    mapView.showsUserLocation = NO;
    
    
}

//定位失败

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    
    NSLog(@"定位错误%@",error);
    
    [mapView setShowsUserLocation:NO];
    
}

//定位停止

-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView{
    
    NSLog(@"定位停止");
}

#pragma mark-
#pragma mark 区域改变

/**
 *地图区域即将改变时会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //mapView.showsUserLocation = YES;
    NSLog(@"地图区域即将改变");
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"地图区域改变完成");
}

#pragma mark-
#pragma mark 标注
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    NSLog(@"生成标注");
    
    BMKAnnotationView *annotationView =[mapView viewForAnnotation:annotation];
    
    if (annotationView==nil&&[annotation isKindOfClass:[MapPointAnnotion class]])
    {
        MapPointAnnotion* pointAnnotation=(MapPointAnnotion*)annotation;
        NSString *AnnotationViewID = [NSString stringWithFormat:@"iAnnotation-%i",pointAnnotation.tag];
		annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:AnnotationViewID];
        
        if ([[pointAnnotation subtitle] isEqualToString:@"我的位置"])
        {
            ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorRed;
        }else if([[pointAnnotation subtitle] isEqualToString:@"目标位置"]){
            ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorPurple;
        }else{
            ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorGreen;
        }
        
		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
        
        
        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
        annotationView.annotation = annotation;
        
        annotationView.canShowCallout = TRUE;
        annotationView.tag=pointAnnotation.tag;
    }
	return annotationView ;
    
    //    static NSString *AnnotationViewID = @"annotationViewID";
	
    //    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    //    if (annotationView == nil) {
    //        annotationView = [[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] autorelease];
    //		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
    //		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    //    }
    //
    //	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    //    annotationView.annotation = annotation;
    //	annotationView.canShowCallout = TRUE;
    //    return annotationView;
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"添加多个标注");
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"选中标注");
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    NSLog(@"取消选中标注");
}

#pragma mark-
#pragma mark 地理编码和反地理编码

- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
}

- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
		for (int i = 0; i < result.poiInfoList.count; i++)
        {
			BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
			BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
			item.coordinate = poi.pt;
			item.title = poi.name;
			[self.mView addAnnotation:item];
			[item release];
            if (i == 0)
            {
                [self.mView setCenterCoordinate:item.coordinate];
            }
		}
	}
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
		MapPointAnnotion* item = [[MapPointAnnotion alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        item.subtitle=result.strAddr;
		[mView addAnnotation:item];
		[item release];
        
        NSLog(@"添加地名名称标注");
	}
    
}
#pragma mark - fun
-(void)cleanMap
{
    NSArray* array = [NSArray arrayWithArray:mView.annotations];
    
    for (MapPointAnnotion* ann in array) {
        [mView removeAnnotation:ann];
    }
}


#pragma mark - View lifecycle
-(void) setupPage
{
    [self leftButtonWithImage:[UIImage imageNamed:@"topbar_menu.png"] withSelector:@selector(toggleToolbar:) onTarget:self];
    [self rightButtonWithTitle:@"定位" withSelector:@selector(toUserLocation:) onTarget:self];
    [self setupTitle:@"GPS系统"];
    [self initToolbar];
    
    // 要使用百度地图,请先启动 BaiduMapManager
    _mapManager = [[BMKMapManager alloc] init] ;
    // 如果要关注网络及授权验证事件,请设定 generalDelegate 参 数
    BOOL ret = [_mapManager start:@"2772BD5CAFF652491F65707D6D5E9ABEBF3639CC" generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    // 初始化轨迹坐标数据源。
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:
                           [[[CLLocation alloc] initWithLatitude:34.246772 longitude:108.916447] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.246772 longitude:108.916447] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.261213 longitude:108.917022] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.261213 longitude:108.917022] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.262645 longitude:108.89187 ] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.262645 longitude:108.89187 ] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.247726 longitude:108.88957 ] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.243191 longitude:108.895894] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.240326 longitude:108.907248] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.245936 longitude:108.916591] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.23949  longitude:108.92004 ] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.247249 longitude:108.934413] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.257513 longitude:108.933838] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.261571 longitude:108.925358] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.261213 longitude:108.917884] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.262526 longitude:108.934557] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.257155 longitude:108.939013] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.25262  longitude:108.938581] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.252978 longitude:108.925502] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.255723 longitude:108.912998] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.255843 longitude:108.906242] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.25083  longitude:108.902074] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.245578 longitude:108.899631] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.238416 longitude:108.897906] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.233521 longitude:108.902362] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.22994  longitude:108.909404] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.228507 longitude:108.902074] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.231134 longitude:108.89575 ] autorelease],
                           [[[CLLocation alloc] initWithLatitude:34.236744 longitude:108.88957 ] autorelease],
                           nil];
    
    self.pointsArr = arr;  //用来记录路线信息的，以后会用到
    _search = [[BMKSearch alloc] init];
    _search.delegate = self;
    
    isRouting = NO;
    stopRoute = NO;
    
    
    BMKMapView *mv = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 431)];
    self.mView = mv;
    [self.view addSubview:self.mView];
    self.mView.delegate = self;
    [self.mView setZoomEnabled:YES];
    //[self.mView setZoomLevel:18];
    [self.mView setShowsUserLocation:YES];//显示定位的蓝点儿
    //
    //    //    [mView setCenterCoordinate:location.coordinate animated:YES];
    //    NSLog(@"%@", [self.pointsArr objectAtIndex:0]);
    //    CLLocation *locationOne = (CLLocation *)[self.pointsArr objectAtIndex:0];
    //    [self.mView setCenterCoordinate:locationOne.coordinate animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 验证登录
    if(![GlobaMethods isUserAuth])
    {
        [self LoginModalPresent];
    }
    else
    {
        [self setupPage];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Button Item handler
- (void)toggleToolbar:(id) sender
{
    if ([self.toolbar isHidden])
    {
        [self.toolbar setHidden:NO];
        
        [self.view bringSubviewToFront:self.toolbar];
    }
    else
    {
        [self.toolbar setHidden:YES];
        [self.srchBar setHidden:YES];
    }
    
}

- (void)tapSearch:(id) sender
{
    [self.srchBar setHidden:NO];
    [self.view bringSubviewToFront:srchBar];
    [toolbar setHidden:YES];
}

- (void)setupLockRect:(id) sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 421)
    {
        NSLog(@"关闭电子围栏，取消围栏模式！");
        
        // 关闭设置电子围栏
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText = @"围栏模式已经关闭";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] autorelease];
        [HUD showAnimated:YES whileExecutingBlock:^{
            NSArray* array = [NSArray arrayWithArray:self.mView.annotations];
            [self.mView removeAnnotations:array];
            array = [NSArray arrayWithArray:self.mView.overlays];
            [self.mView removeOverlays:array];
            [self removeGestureRecognizerOnLockMode];
            btn.tag = 420;
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
            [HUD release];
            HUD = nil;
        }];
        
        return;
    }
    else
    {
        
        NSLog(@"请在地图上选择两个坐标，开始设置围栏！");
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        
        HUD.delegate = self;
        HUD.labelText = @"启动围栏模式！";
        HUD.detailsLabelText = @"请在地图上选择两个坐标";
        HUD.square = YES;
        [HUD showAnimated:YES whileExecutingBlock:^{
            
            NSArray* array = [NSArray arrayWithArray:self.mView.annotations];
            [self.mView removeAnnotations:array];
            array = [NSArray arrayWithArray:self.mView.overlays];
            [self.mView removeOverlays:array];
            
            UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
            [self.mView addGestureRecognizer:mTap];
            [mTap release];
            btn.tag = 421;
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
            [HUD release];
            HUD = nil;
        }];
        return;
    }
    //
    //    MapPointAnnotion *item0 = [self.mView.annotations objectAtIndex:0];
    //    MapPointAnnotion *item1 = [self.mView.annotations objectAtIndex:1];
    //
    //    CGPoint p0 = [self.mView convertCoordinate:item0.coordinate toPointToView:self.mView];
    //    CGPoint p1 = [self.mView convertCoordinate:item1.coordinate toPointToView:self.mView];
    //    CGFloat x1, y1, x2, y2;
    //    if (p0.x < p1.x)
    //    {
    //        x1 = p0.x;
    //        x2 = p1.x;
    //    }
    //    else
    //    {
    //        x1 = p1.x;
    //        x2 = p0.x;
    //    }
    //
    //    if (p0.y < p1.y)
    //    {
    //        y1 = p0.y;
    //        y2 = p1.y;
    //    }
    //    else
    //    {
    //        y1 = p1.y;
    //        y2 = p0.y;
    //    }
    //
    //    CGPoint pt1 = CGPointMake(x1, y1);
    //    CGPoint pt2 = CGPointMake(x2, y1);
    //    CGPoint pt3 = CGPointMake(x2, y2);
    //    CGPoint pt4 = CGPointMake(x1, y2);
    //
    //    CLLocationCoordinate2D coord1 =[self.mView convertPoint:pt1 toCoordinateFromView:self.mView];
    //    CLLocationCoordinate2D coord2 =[self.mView convertPoint:pt2 toCoordinateFromView:self.mView];
    //    CLLocationCoordinate2D coord3 =[self.mView convertPoint:pt3 toCoordinateFromView:self.mView];
    //    CLLocationCoordinate2D coord4 =[self.mView convertPoint:pt4 toCoordinateFromView:self.mView];
    //
    //    NSMutableArray *arr = [NSMutableArray arrayWithObjects:
    //       [[[CLLocation alloc] initWithLatitude:coord1.latitude longitude:coord1.longitude] autorelease],
    //       [[[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude] autorelease],
    //       [[[CLLocation alloc] initWithLatitude:coord3.latitude longitude:coord3.longitude] autorelease],
    //       [[[CLLocation alloc] initWithLatitude:coord4.latitude longitude:coord4.longitude] autorelease],
    //       [[[CLLocation alloc] initWithLatitude:coord1.latitude longitude:coord1.longitude] autorelease],
    //                           nil];
    //
    //    if (self.routeLine)
    //    {
    //        [self.mView removeOverlay:routeLine];
    //    }
    //    self.routeLine = nil;
    //
    //    if (self.routeLineView)
    //    {
    //        [self.routeLineView removeFromSuperview];
    //    }
    //
    //    [self.pointsArr removeAllObjects];
    //    self.pointsArr = nil;
    //
    //    [self.routePointsArr removeAllObjects];
    //    self.routePointsArr = nil;
    //
    //    self.pointsArr = arr;
    //
    //    [self startRoute:@""];
}

- (void)toggleRouteLine:(id) sender
{
    NSLog(@"显示/关闭轨迹回放");
    if (!isRouting)
    {
        // 如果轨迹绘制完成或者尚未绘制轨迹。则清理，并且开始。
        if (self.routeLine)
        {
            [self.mView removeOverlay:routeLine];
        }
        self.routeLine = nil;
        
        if (self.routeLineView)
        {
            [self.routeLineView removeFromSuperview];
        }
        self.routeLineView = nil;
        
        [self.routePointsArr removeAllObjects];
        self.routePointsArr= nil;
        
        [self performSelector:@selector(startRoute:) withObject:@"启动轨迹回放" afterDelay:0.0f];
    }
    else
    {
        // 如果正在回放轨迹，则关闭轨迹回放。
        stopRoute = YES;
    }
}

- (void)startRoute:(NSString *)string
{
    [mView setShowsUserLocation:NO];
    
    if (stopRoute)
    {
        if (self.routeLine)
        {
            [self.mView removeOverlay:routeLine];
        }
        self.routeLine = nil;
        
        if (self.routeLineView)
        {
            [self.routeLineView removeFromSuperview];
        }
        self.routeLineView = nil;
        
        [self.routePointsArr removeAllObjects];
        self.routePointsArr= nil;
        
        isRouting = NO;
        stopRoute = NO;
        return;
    }
    isRouting = YES;
    if (nil == self.routePointsArr)
    {
        self.routePointsArr = [[NSMutableArray alloc] init];
    }
    if (self.routePointsArr.count == self.pointsArr.count)
    {
        // 不再继续绘制
        isRouting = NO;
        return;
    }
    [self.routePointsArr addObject:[self.pointsArr objectAtIndex:self.routePointsArr.count]];
    [self configureRoutes];
    
}

- (void)configureRoutes
{
    // define minimum, maximum points
	BMKMapPoint northEastPoint = BMKMapPointMake(0.f, 0.f);
	BMKMapPoint southWestPoint = BMKMapPointMake(0.f, 0.f);
	
	// create a c array of points.
    //    NSMutableArray *mapPointarr = [NSMutableArray arrayWithObjects:<#(const id *)#> count:<#(NSUInteger)#>
    
    BMKMapPoint* pointArray = (BMKMapPoint* )malloc(sizeof(CLLocationCoordinate2D) * self.routePointsArr.count);
    
	// for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < self.routePointsArr.count; idx++)
	{
        CLLocation *locationOne = [self.routePointsArr objectAtIndex:idx];
        [self.mView setZoomLevel:14];
        NSLog(@"locOne=%f, %f", locationOne.coordinate.latitude, locationOne.coordinate.longitude);
        if (idx == self.routePointsArr.count -1 )
        {
            [self.mView setCenterCoordinate:locationOne.coordinate animated:YES];
        }
        
        //[self.mView setShowsUserLocation:YES];
        
        CLLocationDegrees latitude  = locationOne.coordinate.latitude;
		CLLocationDegrees longitude = locationOne.coordinate.longitude;
        
		// create our coordinate and add it to the correct spot in the array
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        //		MKMapPoint point = MKMapPointForCoordinate(coordinate);
        BMKMapPoint point = BMKMapPointForCoordinate(coordinate);
		
		// if it is the first point, just use them, since we have nothing to compare to yet.
		if (idx == 0) {
			northEastPoint = point;
			southWestPoint = point;
		} else {
			if (point.x > northEastPoint.x)
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x)
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y)
				southWestPoint.y = point.y;
		}
        
		pointArray[idx] = point;
	}
	
    if (self.routeLine) {
        [self.mView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [BMKPolyline polylineWithPoints:pointArray count:self.routePointsArr.count];
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[self.mView addOverlay:self.routeLine];
	}
    
    // clear the memory allocated earlier for the points
	free(pointArray);
    
    /*
     double width = northEastPoint.x - southWestPoint.x;
     double height = northEastPoint.y - southWestPoint.y;
     
     _routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, width, height);
     
     // zoom in on the route.
     [self.mapView setVisibleMapRect:_routeRect];
     */
}

- (void) toUserLocation:(id)sender
{
    [self.mView setZoomLevel:18];
//    BOOL ret = [_search reverseGeocode:self.location.coordinate];
    self.mView.showsUserLocation = YES;
}

#pragma mark - MKMapViewDelegate
#pragma mark
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
    
    if (overlayViews.count > 0)
    {
        id overlayView = [overlayViews objectAtIndex:0];
        if ([overlayView isKindOfClass:[BMKPolygonView class]])
        {
            return;
        }
    }
    NSLog(@"开始下一个路线, %d", self.routePointsArr.count);
    [self performSelector:@selector(startRoute:) withObject:@"启动轨迹回放" afterDelay:1.2f];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    BMKOverlayView* overlayView = nil;
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        if (self.polygonView)
        {
            [self.polygonView removeFromSuperview];
        }
        self.polygonView = [[[BMKPolygonView alloc] initWithOverlay:overlay] autorelease];
        self.polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        self.polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        self.polygonView.lineWidth = 3.0;
        overlayView = self.polygonView;
    }
	
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        if(overlay == self.routeLine)
        {
            //if we have not yet created an overlay view for this overlay, create it now.
            if (self.routeLineView)
            {
                [self.routeLineView removeFromSuperview];
            }
            self.routeLineView = [[BMKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
            overlayView = self.routeLineView;
        }
    }
	return overlayView;
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.mView.annotations.count >= 2 )
    {
        // 移除多边形数据
        [self.mView removeAnnotation:[self.mView.annotations objectAtIndex:0]];
        // 移除多边形覆盖对象
        if (self.polygon)
        {
            [self.mView removeOverlay:self.polygon];
            self.polygon = nil;
        }
        
        if (self.polygonView)
        {
            [self.polygonView removeFromSuperview];
            self.polygonView = nil;
        }
        
        //return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mView convertPoint:touchPoint toCoordinateFromView:self.mView];//这里touchMapCoordinate就是该点的经纬度了
    
    NSLog(@"touching %f,%f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    //    if (annotationa) {
    //
    //        [self.mView removeAnnotation:annotationa];
    //
    //    }
    MapPointAnnotion* item = [[MapPointAnnotion alloc]init];
    item.coordinate = touchMapCoordinate;
    item.title = [NSString stringWithFormat:@"%.f, %.f", touchMapCoordinate.latitude, touchMapCoordinate.longitude];
    item.subtitle=@"我的位置";
    [mView addAnnotation:item];
    [item release];
    
    if (self.mView.annotations.count == 2 )
    {
        // 画多边形
        
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        HUD.labelText = @"围栏设置成功";
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] autorelease];
        [HUD showAnimated:YES whileExecutingBlock:^{
            [self createLockRect:self.mView.annotations];
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
            [HUD release];
            HUD = nil;
        }];
        return;
    }
}

- (void)createLockRect:(NSArray *) arr
{
    
    MapPointAnnotion *item0 = [arr objectAtIndex:0];
    MapPointAnnotion *item1 = [arr objectAtIndex:1];
    
    CGPoint p0 = [self.mView convertCoordinate:item0.coordinate toPointToView:self.mView];
    CGPoint p1 = [self.mView convertCoordinate:item1.coordinate toPointToView:self.mView];
    CGFloat x1, y1, x2, y2;
    if (p0.x < p1.x)
    {
        x1 = p0.x;
        x2 = p1.x;
    }
    else
    {
        x1 = p1.x;
        x2 = p0.x;
    }
    
    if (p0.y < p1.y)
    {
        y1 = p0.y;
        y2 = p1.y;
    }
    else
    {
        y1 = p1.y;
        y2 = p0.y;
    }
    
    CGPoint pt1 = CGPointMake(x1, y1);
    CGPoint pt2 = CGPointMake(x2, y1);
    CGPoint pt3 = CGPointMake(x2, y2);
    CGPoint pt4 = CGPointMake(x1, y2);
    
    CLLocationCoordinate2D coord1 =[self.mView convertPoint:pt1 toCoordinateFromView:self.mView];
    CLLocationCoordinate2D coord2 =[self.mView convertPoint:pt2 toCoordinateFromView:self.mView];
    CLLocationCoordinate2D coord3 =[self.mView convertPoint:pt3 toCoordinateFromView:self.mView];
    CLLocationCoordinate2D coord4 =[self.mView convertPoint:pt4 toCoordinateFromView:self.mView];
    
    CLLocationCoordinate2D coords[4] = {coord1, coord2, coord3, coord4};
    //    coords[0].latitude = 39;
    //    coords[0].longitude = 116;
    //    coords[1].latitude = 38;
    //    coords[1].longitude = 115;
    //    coords[2].latitude = 38;
    //    coords[2].longitude = 117;
    NSMutableArray *arrloc = [NSMutableArray arrayWithObjects:
                              [[[CLLocation alloc] initWithLatitude:coord1.latitude longitude:coord1.longitude] autorelease],
                              [[[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude] autorelease],
                              [[[CLLocation alloc] initWithLatitude:coord3.latitude longitude:coord3.longitude] autorelease],
                              [[[CLLocation alloc] initWithLatitude:coord4.latitude longitude:coord4.longitude] autorelease],
                              nil];
    
    //    // define minimum, maximum points
    //	BMKMapPoint northEastPoint = BMKMapPointMake(0.f, 0.f);
    //	BMKMapPoint southWestPoint = BMKMapPointMake(0.f, 0.f);
    //
    //	// create a c array of points.
    //    //    NSMutableArray *mapPointarr = [NSMutableArray arrayWithObjects:<#(const id *)#> count:<#(NSUInteger)#>
    //
    //    BMKMapPoint* pointArray = (BMKMapPoint* )malloc(sizeof(CLLocationCoordinate2D) * self.routePointsArr.count);
    //
    //	// for(int idx = 0; idx < pointStrings.count; idx++)
    //    for(int idx = 0; idx < arrloc.count; idx++)
    //	{
    //        CLLocation *locationOne = [arrloc objectAtIndex:idx];
    //        //[self.mView setZoomLevel:14];
    //        NSLog(@"locOne=%f, %f", locationOne.coordinate.latitude, locationOne.coordinate.longitude);
    //        if (idx == arrloc.count -1 )
    //        {
    //            //[self.mView setCenterCoordinate:locationOne.coordinate animated:YES];
    //        }
    //
    //        CLLocationDegrees latitude  = locationOne.coordinate.latitude;
    //		CLLocationDegrees longitude = locationOne.coordinate.longitude;
    //
    //		// create our coordinate and add it to the correct spot in the array
    //		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    //        //		MKMapPoint point = MKMapPointForCoordinate(coordinate);
    //        BMKMapPoint point = BMKMapPointForCoordinate(coordinate);
    //
    //		// if it is the first point, just use them, since we have nothing to compare to yet.
    //		if (idx == 0) {
    //			northEastPoint = point;
    //			southWestPoint = point;
    //		} else {
    //			if (point.x > northEastPoint.x)
    //				northEastPoint.x = point.x;
    //			if(point.y > northEastPoint.y)
    //				northEastPoint.y = point.y;
    //			if (point.x < southWestPoint.x)
    //				southWestPoint.x = point.x;
    //			if (point.y < southWestPoint.y)
    //				southWestPoint.y = point.y;
    //		}
    //
    //		pointArray[idx] = point;
    //	}
    //
    //    if (self.polygon)
    //    {
    //        [self.mView removeOverlay:polygon];
    //    }
    //    self.polygon = nil;
    //
    //    if (self.polygonView)
    //    {
    //        [self.polygonView removeFromSuperview];
    //    }
    //
    //    self.polygon = [BMKPolygon polygonWithPoints:pointArray count:arrloc.count];
    
    
    self.polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
    // add the overlay to the map
	if (nil != self.polygon) {
		[self.mView addOverlay:self.polygon];
	}
    
    // clear the memory allocated earlier for the points
	//free(pointArray);
    
    //    CLLocationCoordinate2D coords[3] = {0};
    //    coords[0].latitude = 39;
    //    coords[0].longitude = 116;
    //    coords[1].latitude = 38;
    //    coords[1].longitude = 115;
    //    coords[2].latitude = 38;
    //    coords[2].longitude = 117;
    //    BMKPolygon* plyg = [BMKPolygon polygonWithPoints:<#(BMKMapPoint *)#> count:<#(NSUInteger)#>];
    //    [self.mView addOverlay:plyg];
    
}


#pragma mark - 用户登录
#pragma mark
-(void)LoginModalPresent
{
    LoginController *objLogin = [[LoginController alloc] init];
    objLogin.delegate = self;
    CustomNavBarVC *navController = [[[CustomNavBarVC alloc] initWithRootViewController:objLogin] autorelease];
    [self.tabBarController presentModalViewController:navController animated:YES];
    [objLogin release];
}

-(void)LoginRecieved
{
    NSLog(@"登录成功!");
    [self setupPage];
    //    BMKMapView *mv = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 431)];
    //    self.mView = mv;
    //    [self.view addSubview:self.mView];
    //    self.mView.delegate = self;
    //    [self.mView setZoomEnabled:YES];
    //    [self.mView setZoomLevel:15];
    //    [self.mView setShowsUserLocation:YES];//显示定位的蓝点儿
    
    //    [mView setCenterCoordinate:location.coordinate animated:YES];
    //    NSLog(@"%@", [self.pointsArr objectAtIndex:0]);
    //    CLLocation *locationOne = (CLLocation *)[self.pointsArr objectAtIndex:0];
    //    [self.mView setCenterCoordinate:locationOne.coordinate animated:YES];
    //    [self loadUserInfo];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == TAG_ALERT_LOGIN)
    {
        if(buttonIndex == 0)
        {
            [self LoginModalPresent];
        }
    }
    if(alertView.tag == TAG_ALERT_LOGOUT)
    {
        //        if(buttonIndex == 1)
        //        {
        //            [self SetInfoHidden:YES];
        //            [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
        //            [MemberDAL DeleteUserListenData];
        //            [MemberDAL DeleteUser];
        //            self.mainModel = nil;
        //            [self.tblMemberMain reloadData];
        //            [self LoginModalPresent];
        //        }
    }
}
#pragma mark - 添加工具栏
#pragma mark
- (void) initToolbar
{
    UIToolbar *toolBarOne = [[UIToolbar alloc] initWithFrame:
                             CGRectMake(0.0f, 0.0f, 320.0f, 49.0f)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        
        //iOS 5
        UIImage *toolBarIMG = [UIImage imageNamed: @"download_edit_bg.png"];
        
        if ([toolBarOne respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [toolBarOne setBackgroundImage:toolBarIMG forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        }
        
    } else {
        
        //iOS 4
        [toolBarOne insertSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"download_edit_bg.png"]] autorelease] atIndex:0];
        
    }
    
    NSMutableArray *toolBarItems = [NSMutableArray arrayWithObjects:
                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"监控孩子" target:self action:@selector(toggleRouteLine:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"轨迹回放" target:self action:@selector(toggleRouteLine:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"电子围栏" target:self action:@selector(setupLockRect:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"搜索" target:self action:@selector(tapSearch:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
                                    nil];
    
    [toolBarOne setItems:toolBarItems animated:YES];
    self.toolbar = toolBarOne;
    [toolBarOne release];
    [self.toolbar setHidden:YES];
    [self.view addSubview:self.toolbar];
}

- (UIButton *) getButtonWithTitle:(NSString *) title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68.0f, 30.0f)];
    [lbl setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:12.0f]];
    lbl.textColor = [UIColor blackColor];
    lbl.shadowColor = [UIColor colorWithRed:0.0f
                                      green:0.0f
                                       blue:0.0f
                                      alpha:0.4f];
    lbl.shadowOffset = CGSizeMake(0.0f, 0.9f);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    
    UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(0, -0, 68.0f, 30.0f)] autorelease];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right.png"] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right-hl.png"] forState:UIControlStateHighlighted];
    //    [leftButton addTarget:self action:@selector(setupLockRect:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:target action:action forControlEvents:controlEvents];
    [btn addSubview:lbl];
    [lbl release];
    return btn;
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

#pragma mark -
#pragma mark Search Bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self doSearch:searchBar];
}

-(void) doSearch:(UISearchBar*)searchBar
{
    
    [searchBar resignFirstResponder];
    NSString *strKeyword = searchBar.text;
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"正在搜索...";
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self removeGestureRecognizerOnLockMode];
        NSArray* array = [NSArray arrayWithArray:self.mView.annotations];
        [self.mView removeAnnotations:array];
        array = [NSArray arrayWithArray:self.mView.overlays];
        [self.mView removeOverlays:array];
        
        BOOL flag = [_search poiSearchInCity:@"西安" withKey:strKeyword pageIndex:0];
        if (!flag) {
            NSLog(@"search failed!");
        }
    } completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }];
}

- (void) removeGestureRecognizerOnLockMode
{
    for (UIGestureRecognizer *recognizer in [self.mView gestureRecognizers])
    {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self.mView removeGestureRecognizer:recognizer];
        }
    }
}
@end


