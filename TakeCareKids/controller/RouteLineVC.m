//
//  RouteLineVC.m
//  BaiduDemo
//
//  Created by jian zhang on 12-5-7.
//  Copyright (c) 2012年 txtws.com. All rights reserved.
//

#import "RouteLineVC.h"
#import "MapPointAnnotion.h"

#define MAP_ANNVIEW_I_TAG 78000
#define TAG_ALERT_LOGIN 56
#define TAG_ALERT_LOGOUT 57

@implementation RouteLineVC

@synthesize toolbar = _toolbar;
@synthesize mpView = _mpView;
@synthesize location = _location;
@synthesize routeLine =_routeLine;
@synthesize routeLineView = _routeLineView;
@synthesize polygon = _polygon;
@synthesize polygonView = _polygonView;
@synthesize currentLocation = _currentLocation;
@synthesize terminalInfo = _terminalInfo;
@synthesize dataArr = _dataArr;
@synthesize pickerBt = _pickerBt;
@synthesize pickerEt = _pickerEt;
- (void)dealloc
{
    [_location release];
    [_routeLine release];
    [_routeLineView release];
    [_polygon release];
    [_polygonView release];
    [_currentLocation release];
    [_terminalInfo release];
    if (_mpView)
    {
        [_mpView setDelegate:nil];
        [_mpView release];
        _mpView = nil;
    }
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil withInfo:(NSDictionary *) info
{
    self = [self initWithNibName:nibNameOrNil bundle:nil];
    self.terminalInfo = info;
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.msgRouter = [MessageRouter getInstance];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void) setupPage
{
    [self leftButtonWithImage:[UIImage imageNamed:@"topbar_back.png"] withSelector:@selector(LeftButtonPress:) onTarget:self];
    [self rightButtonWithTitle:@"设置日期" withSelector:@selector(RightButtonPress:) onTarget:self];
    [self setupTitle:@"终端轨迹回放"];
    [self initToolbar];
    
    BMKMapView *mapv = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mpView = mapv;
    [mapv release];
    [self.view addSubview:self.mpView];
    
    [self.mpView setZoomLevel:15];
    [mapv release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 验证登录
    [self setupPage];
    [self getLocListByTid];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mpView viewWillAppear];
    _mpView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mpView viewWillDisappear];
    _mpView.delegate = nil; // 不用时，置nil
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

        CLLocationDistance distance = [locationOne distanceFromLocation:self.location];
        if (distance < 5)
        {
            NSLog(@"距离过短不更新");
            self.location = userLocation.location;
            if (!mapView.isUserLocationVisible)
            {
                mapView.showsUserLocation = NO;
//                
//                [mapView setCenterCoordinate:userLocation.location.coordinate];
            }
            else
            {
                [mapView setCenterCoordinate:userLocation.location.coordinate];
                [mapView setShowsUserLocation:YES];
            }
            return;
        }
    
    self.location = userLocation.location;
    [mapView setCenterCoordinate:userLocation.location.coordinate];    //给view中心定位
//    BMKCoordinateRegion region;
//    region.center.latitude  = userLocation.location.coordinate.latitude;
//    region.center.longitude = userLocation.location.coordinate.longitude;
//    region.span.latitudeDelta  = 0.25;
//    region.span.longitudeDelta = 0.25;
//    mapView.region   = region;
//    mapView.zoomLevel = 16;
//    //加个当前坐标的小气泡
//    mapView.showsUserLocation = YES;
}

//定位失败

-(void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"定位错误%@",error);
    [mapView setShowsUserLocation:NO];
}

//定位停止

-(void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
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
    DLog(@"地图区域即将改变");
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    DLog(@"地图区域改变完成");
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
    static NSString *AnnotationViewID = @"annotationViewID";
    
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    ((BMKPinAnnotationView*) annotationView).pinColor = BMKPinAnnotationColorPurple;
    ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;// 设置该标注点动画显示
    //    [annotationView setDraggable:YES];//允许用户拖动
    //    [annotationView setSelected:YES animated:YES];//让标注处于弹出气泡框的状态
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));//
    annotationView.annotation = annotation;//绑定对应的标点经纬度
    annotationView.canShowCallout = TRUE;//允许点击弹出气泡框
    return annotationView;
  
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
			[self.mpView addAnnotation:item];
			[item release];
            if (i == 0)
            {
                [self.mpView setCenterCoordinate:item.coordinate];
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
		[self.mpView addAnnotation:item];
		[item release];
        
        NSLog(@"添加地名名称标注");
	}
    
}
#pragma mark - fun
-(void)cleanMap
{
    NSArray* arrAnn = [NSArray arrayWithArray:self.mpView.annotations];
    [self.mpView removeAnnotations:arrAnn];

    NSArray *arrOverlays = [NSArray arrayWithArray:self.mpView.overlays];
    [self.mpView removeOverlays:arrOverlays];
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
    }
    
}

- (void) toUserLocation:(id)sender
{
    self.mpView.showsUserLocation = YES;
}

#pragma mark - MKMapViewDelegate
#pragma mark
- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
//    DLog(@"%@ ----- %@", __, NSStringFromSelector(_cmd));
    DLog(@"overlayViews: %d", [overlayViews count]);
    
    if (overlayViews.count > 0)
    {
        id overlayView = [overlayViews objectAtIndex:0];
        if ([overlayView isKindOfClass:[BMKPolygonView class]])
        {
            return;
        }
    }
//    NSLog(@"开始下一个路线, %d", self.routePointsArr.count);
//    [self performSelector:@selector(startRoute:) withObject:@"启动轨迹回放" afterDelay:1.2f];
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    DLog(@"overlayViews: %s", object_getClassName(overlay));
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
        self.polygonView.lineWidth = 8.0;
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
            self.routeLineView.lineJoin = kCGLineJoinMiter;
            self.routeLineView.miterLimit = 20;
            self.routeLineView.strokeColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
            self.routeLineView.fillColor = [[UIColor greenColor] colorWithAlphaComponent:0.7];
            self.routeLineView.lineWidth = 5;
            overlayView = self.routeLineView;
        }
    }
	return overlayView;
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
                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"搜索" target:self action:@selector(tapSearch:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
                                    //                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"电子围栏" target:self action:@selector(setupLockRect:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
                                    [[[UIBarButtonItem alloc] initWithCustomView:[self getButtonWithTitle:@"注销登录" target:self action:@selector(Logout:) forControlEvents:UIControlEventTouchUpInside]] autorelease],
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
	[hud removeFromSuperview];
	[hud release];
	hud = nil;
}

- (void) removeGestureRecognizerOnLockMode
{
    for (UIGestureRecognizer *recognizer in [self.mpView gestureRecognizers])
    {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        {
            [self.mpView removeGestureRecognizer:recognizer];
        }
    }
}


- (void) Logout:(id) sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - RequestFunction
- (void)getLocListByTid
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在加载";
    [hud show:YES];
	
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    
//    NSDate *nowdt = [NSDate date];
    NSString *bt = nil;
    NSString *et = nil;
    
    if (self.pickerBt && self.pickerEt)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        bt = [formatter stringFromDate:self.pickerBt.date];
        et = [formatter stringFromDate:self.pickerEt.date];
        [formatter release];
    }
    else
    {
        NSDate *nowdt = [self dateFromString:@"2013-07-17 23:59:59"];
        NSDateFormatter *formattter=[[NSDateFormatter alloc] init];
        [formattter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];//zh_CN
        [formattter setLocale:locale];
        [locale release];
        et=[formattter stringFromDate:nowdt];
        bt= [formattter stringFromDate:[nowdt dateByAddingTimeInterval:0-24 * 60 *60]];
        [formattter release];
    }

    [_msgRouter getLocHistoryWithUid:uid
                         password:pwd
                          withTid:[self.terminalInfo objectForKey:@"id"]
                          withBt:bt
                         withEt:et
                          delegate:self
                          selector:@selector(getLocListSuccess:)
                     errorSelector:@selector(getLocListError:)];
}

#pragma mark - NetworkDelegate
#pragma mark Recive data

- (void)getLocListSuccess:(NSDictionary *)response
{
    NSLog(@"%s=%@", __PRETTY_FUNCTION__, response);
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    
    NSInteger result = [[response objectForKey:@"rst"] intValue];
    if (result == 0)
    {
        NSArray * pos = [response objectForKey:@"dts"];
        if ([DataCheck isValidArray:pos])
        {
            if (!self.dataArr)
            {
                NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
                self.dataArr = arr;
                [arr release];
            }
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:pos];
            //[self performSelector:@selector(showAllRouteline) withObject:nil];
            [self showAllRouteline];

            //            [self saveTodb:tms];
        }
        if (hud)
        {
            hud.labelText = @"完成！";
        }
    }
    else
    {
        if (hud)
        {
            hud.labelText = @"请求数据失败！";
        }
    }
    [hud hide:YES afterDelay:0.5f];

}


- (void)getLocListError:(NSDictionary *)errorInfo
{
    DLog(@"errorInfo=%@", errorInfo);
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    if (hud)
    {
        hud.labelText = @"请求数据失败！";
        [hud hide:YES afterDelay:0.5f];
    }
}

-(void) saveTodb:(NSArray *) arr
{
//    for (NSDictionary *dictOne in arr)
//    {
//        NSMutableDictionary *dicModel = [[NSMutableDictionary alloc] initWithCapacity:0];
//        for (NSString *key in dictOne.allKeys)
//        {
//            NSString *newKey = [NSString stringWithFormat:@"tm%@", key];
//            NSString *value = [dictOne objectForKey:key];
//            [dicModel setObject:value forKey:newKey];
//        }
//        
//        Terminal *modelOne = [Terminal objectWithProperties:dicModel];
//        [modelOne setToDB];
//        [dicModel release];
//    }
}

#pragma mark - NavButtonFunction
- (void)LeftButtonPress:(id)sender
{
    [self cleanMap];

    //DLog(@"");
    if ([self.navigationController.viewControllers count] > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)RightButtonPress:(id)sender
{
    
    [self StartdateSheet];
}

#pragma mark - 显示该终端所有路线
- (void)showAllRouteline
{
    DLog(@"%d, %d", [self.navigationController.viewControllers count], [self isEqual:self.navigationController.topViewController]);
    [self cleanMap];
//    [self.mpView setZoomLevel:18];
    [self showRouteHistory:self.dataArr];
}

- (void)showAllRoutelineAnimation:(BOOL)animation
{
    
    
}

- (void)showRouteHistory:(NSArray *) arr
{
    // define minimum, maximum points
	BMKMapPoint northEastPoint = BMKMapPointMake(0.f, 0.f);
	BMKMapPoint southWestPoint = BMKMapPointMake(0.f, 0.f);
	
	// create a c array of points.
    //    NSMutableArray *mapPointarr = [NSMutableArray arrayWithObjects: count:
    
    BMKMapPoint* pointArray = (BMKMapPoint* )malloc(sizeof(CLLocationCoordinate2D) * [arr count]);
    
    for(int idx = 0; idx < [arr count]; idx++)
	{
        NSDictionary *locInfo = [arr objectAtIndex:idx];
        CLLocation *locOne = nil;
        
        if ([DataCheck isValidDictionary:locInfo])
        {
            NSString *slat = [locInfo objectForKey:@"lat"];
            NSString *slon =  [locInfo objectForKey:@"lon"];
            locOne = [[CLLocation alloc] initWithLatitude:[slat doubleValue] longitude:[slon doubleValue]];
        }
        [self.mpView setZoomLevel:16];
        NSLog(@"locOne=%f, %f", locOne.coordinate.latitude, locOne.coordinate.longitude);
        if (idx == arr.count -1 )
        {
            [self.mpView setCenterCoordinate:locOne.coordinate animated:YES];
        }
        
        CLLocationDegrees latitude  = locOne.coordinate.latitude;
		CLLocationDegrees longitude = locOne.coordinate.longitude;
		// create our coordinate and add it to the correct spot in the array
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
///
        NSDictionary *tip = BMKBaiduCoorForWgs84(coordinate);
        CLLocationCoordinate2D adjCoordOne = BMKCoorDictionaryDecode(tip);
        //BMKMapPoint point = BMKMapPointForCoordinate(adjCoordOne);
        ///////
        

        //		MKMapPoint point = MKMapPointForCoordinate(coordinate);
        BMKMapPoint point = BMKMapPointForCoordinate(adjCoordOne);
		
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
	
    if (self.routeLine)
    {
        [self.mpView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [BMKPolyline polylineWithPoints:pointArray count:[arr count]];
    
    // add the overlay to the map
	if (nil != self.routeLine)
    {
		[self.mpView addOverlay:self.routeLine];
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

- (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return destDate;
}


-(void)StartdateSheet

{
    NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" ;
    
    UIActionSheet *startsheet = [[UIActionSheet alloc] initWithTitle:title
                                             delegate:self
                                    cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"设置起始时间",
                                 nil];
    
    startsheet.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    [startsheet showFromTabBar: self.tabBarController.tabBar];
//    [startsheet showInView:self.view];
    startsheet.frame = CGRectMake(0, 64, 320, 516);
    
    if (!self.pickerBt)
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(0, 0, 320, 120);
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.tag = 101;
        self.pickerBt = datePicker;
        [datePicker release];
    }

    [startsheet addSubview:self.pickerBt];

    if (!self.pickerEt)
    {
        UIDatePicker *datePicker2 = [[UIDatePicker alloc] init];
        datePicker2.frame = CGRectMake(0, 180, 320, 120);
        datePicker2.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker2.tag = 102;
        self.pickerEt = datePicker2;
        [datePicker2 release];
    }
    
    [startsheet addSubview:self.pickerEt];
    [startsheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *timeBt = [formatter stringFromDate:self.pickerBt.date];
        NSString *timeEt = [formatter stringFromDate:self.pickerEt.date];
        [formatter release];
        //显示时间的变量
        DLog(@"%@, %@", timeBt, timeEt);
        [self getLocListByTid];
    }
//    [(UILabel *)[self.view viewWithTag:103] setText:timestamp];
 //   [actionSheet release];
}
@end


