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

@implementation QieziViewController
BMKMapManager* _mapManager;

@synthesize _search;
@synthesize mView;
@synthesize location;
@synthesize pointsArr;
@synthesize routePointsArr;
@synthesize routeLine;
@synthesize routeLineView;
@synthesize currentLocation;
@synthesize isRouting;
@synthesize stopRoute;
- (void)dealloc
{
    [_search release];
    [location release];
    [pointsArr release];
    [routeLine release];
    [routeLineView release];
    [currentLocation release];
    [routePointsArr release];
    [mView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        //self.title = NSLocalizedString(@"轨迹回放", @"轨迹回放");
        [self setUpTitleView:NSLocalizedString(@"轨迹回放", @"轨迹回放")];
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
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
    
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
            [self.mView setShowsUserLocation:NO];
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
    mapView.zoomLevel = 18;

    //mapView.zoomLevel = 3;
    //加个当前坐标的小气泡
    //[_search reverseGeocode:userLocation.location.coordinate];
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
}

- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
		MapPointAnnotion* item = [[MapPointAnnotion alloc]init];
		item.coordinate = result.geoPt;
		item.title = result.strAddr;
        item.subtitle=@"我的位置";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68.0f, 30.0f)];
    [leftLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.shadowColor = [UIColor colorWithRed:0.0f
                                            green:0.0f
                                             blue:0.0f
                                            alpha:0.4f];
    leftLabel.shadowOffset = CGSizeMake(0.0f, 0.9f);
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"设置围栏";
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -0, 68.0f, 30.0f)];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right.png"] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right-hl.png"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(setupLockRect:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:leftLabel];
    [self setUpLeftButton: leftButton];
    [leftButton release];

    
    UILabel * sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90.0f, 30.0f)];
    [sendLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]];
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.shadowColor = [UIColor colorWithRed:0.0f
                                            green:0.0f
                                             blue:0.0f
                                            alpha:0.4f];
    sendLabel.shadowOffset = CGSizeMake(0.0f, 0.9f);
    sendLabel.backgroundColor = [UIColor clearColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.text = @"显示/关闭轨迹";
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, -0, 100.0f, 30.0f)];
//    [rightButton setImage:[UIImage imageNamed:@"navbar-right.png"] forState:UIControlStateNormal];
//    [rightButton setImage:[UIImage imageNamed:@"navbar-right-hl.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(toggleRouteLine:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addSubview:sendLabel];    
    [self setUpRightButton: rightButton];
    [rightButton release];

    // 要使用百度地图,请先启动 BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init] ;
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
    _search = [[BMKSearch alloc]init];
    _search.delegate = self;

    BMKMapView *mv = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 431)];
    self.mView = mv;
    [self.view addSubview:self.mView];
    self.mView.delegate = self;
    [self.mView setZoomEnabled:YES];
    //[self.mView setZoomLevel:18];
    [self.mView setShowsUserLocation:NO];//显示定位的蓝点儿
    
    //    [mView setCenterCoordinate:location.coordinate animated:YES];
    NSLog(@"%@", [self.pointsArr objectAtIndex:0]);
    CLLocation *locationOne = (CLLocation *)[self.pointsArr objectAtIndex:0];
    [self.mView setCenterCoordinate:locationOne.coordinate animated:YES];
    isRouting = NO;
    stopRoute = NO;
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mView addGestureRecognizer:mTap];
    [mTap release];
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
- (void)setupLockRect:(id) sender
{
    if (self.mView.annotations.count < 2)
    {
        NSLog(@"请在地图上选择两个坐标，设置围栏！");

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在地图上选择两个坐标，设置围栏！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    MapPointAnnotion *item0 = [self.mView.annotations objectAtIndex:0];
    MapPointAnnotion *item1 = [self.mView.annotations objectAtIndex:1];
    
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
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:
                           [[[CLLocation alloc] initWithLatitude:coord1.latitude longitude:coord1.longitude] autorelease],
                           [[[CLLocation alloc] initWithLatitude:coord2.latitude longitude:coord2.longitude] autorelease],
                           [[[CLLocation alloc] initWithLatitude:coord3.latitude longitude:coord3.longitude] autorelease],
                           [[[CLLocation alloc] initWithLatitude:coord4.latitude longitude:coord4.longitude] autorelease],
                           [[[CLLocation alloc] initWithLatitude:coord1.latitude longitude:coord1.longitude] autorelease],
                           nil];
 
    if (self.routeLine)
    {
        [self.mView removeOverlay:routeLine];
    }
    self.routeLine = nil;
    
    if (self.routeLineView)
    {
        [self.routeLineView removeFromSuperview];
    }
    
    [self.pointsArr removeAllObjects];
    self.pointsArr = nil;
    
    [self.routePointsArr removeAllObjects];
    self.routePointsArr = nil;
    
    self.pointsArr = arr;
    
    [self startRoute:@""];
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
        [self.mView setZoomLevel:18];
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


#pragma mark
#pragma mark MKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    NSLog(@"overlayViews: %@", overlayViews);
    NSLog(@"开始下一个路线, %d", self.routePointsArr.count);

    [self performSelector:@selector(startRoute:) withObject:@"启动轨迹回放" afterDelay:1.5f];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    NSLog(@"%@ ----- %@", self, NSStringFromSelector(_cmd));
    
	BMKOverlayView* overlayView = nil;
	
	if(overlay == self.routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now.
        if (self.routeLineView) {
            [self.routeLineView removeFromSuperview];
        }
        
        self.routeLineView = [[BMKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 5;
        
		overlayView = self.routeLineView;
	}
	
	return overlayView;
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.mView.annotations.count >=2 )
    {
        [self.mView removeAnnotation:[self.mView.annotations objectAtIndex:0]];
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
    
    
}

@end
