//
//  TRMLastPosVC.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 7/19/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "TRMLastPosVC.h"

@interface TRMLastPosVC ()

@end

@implementation TRMLastPosVC
@synthesize mpView = _mpView;

- (void)dealloc
{
    if (_mpView) {
        [_mpView release];
        _mpView = nil;
    }
    [super dealloc];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self leftButtonWithImage:[UIImage imageNamed:@"topbar_menu.png"] action:@selector(LeftButtonPress:) onTarget:self];
    [self rightButtonWithTitle:@"定位" action:@selector(RightButtonPress:) onTarget:self];
    [self setupTitle:@"终端最后位置" action:@selector(toggleMenu) target:self.navigationController];
    
    BMKMapView *mapv = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    self.mpView = mapv;
    [mapv release];
    [self.view addSubview:self.mpView];
    
    [self.mpView setZoomLevel:15];
    if(![GlobaMethods isUserAuth])
    {
        [self LoginModalPresent];
    }
}
-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
    [_mpView viewWillAppear];
    _mpView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
    [_mpView viewWillDisappear];
    _mpView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 用户登录
#pragma mark
-(void)LoginModalPresent
{
//    LoginController *objLogin = [[LoginController alloc] init];
//    objLogin.delegate = self;
//    CustomNavBarVC *navController = [[[CustomNavBarVC alloc] initWithRootViewController:objLogin] autorelease];
//    [self.tabBarController presentModalViewController:navController animated:YES];
//    [objLogin release];
}

-(void)LoginRecieved
{
    NSLog(@"登录成功!");
}

- (void) Logout:(id) sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self LoginModalPresent];
    
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
    if(self.terminalInfo)
    {
        [_msgRouter getLocListWithUid:uid
                             password:pwd
                              withTid:[self.terminalInfo objectForKey:@"id"]
                             delegate:self
                             selector:@selector(getLocListSuccess:)
                        errorSelector:@selector(getLocListError:)];
    }
    else
    {
        [_msgRouter getLocListWithUid:uid
                             password:pwd
                              withTid:nil
                             delegate:self
                             selector:@selector(getLocListSuccess:)
                        errorSelector:@selector(getLocListError:)];
    }
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
        NSArray * pos = [response objectForKey:@"pos"];
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
            //            [self performSelector:@selector(showAllTerminals) withObject:nil];
            [self showAllTerminals];
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
    [self Logout:nil];
}

- (void)RightButtonPress:(id)sender
{
    [self getLocListByTid];
}

#pragma mark - map operation
-(void)cleanMap
{
    NSArray* arrAnn = [NSArray arrayWithArray:self.mpView.annotations];
    [self.mpView removeAnnotations:arrAnn];

    NSArray *arrOverlays = [NSArray arrayWithArray:self.mpView.overlays];
    [self.mpView removeOverlays:arrOverlays];
}

#pragma mark - 显示该终端所有路线
- (void)showAllTerminals
{
    DLog(@"%d, %d", [self.navigationController.viewControllers count], [self isEqual:self.navigationController.topViewController]);
    [self cleanMap];
    [self showTerminalsOnMap:self.dataArr];
}

- (void)showAllRoutelineAnimation:(BOOL)animation
{
    
    
}

- (void)showTerminalsOnMap:(NSArray *) arr
{
    NSMutableArray *arrAnn = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for(int idx = 0; idx < [arr count]; idx++)
	{
        NSDictionary *locInfo = [arr objectAtIndex:idx];
        NSString *slat = [locInfo objectForKey:@"lat"];
        NSString *slon =  [locInfo objectForKey:@"lon"];
        CLLocation *locOne = [[CLLocation alloc] initWithLatitude:[slat doubleValue] longitude:[slon doubleValue]];
        //////
        CLLocationCoordinate2D coordOne = CLLocationCoordinate2DMake([slat doubleValue], [slon doubleValue]);
        NSDictionary *tip = BMKBaiduCoorForWgs84(coordOne);
        CLLocationCoordinate2D adjCoordOne = BMKCoorDictionaryDecode(tip);
        //BMKMapPoint point = BMKMapPointForCoordinate(adjCoordOne);
        ///////
        MapPointAnnotion* item = [[MapPointAnnotion alloc]init];
//        item.coordinate = locOne.coordinate;
        item.coordinate = adjCoordOne;
        item.title = [locInfo objectForKey:@"id"];//[NSString stringWithFormat:@"%.f, %.f", locOne.coordinate.latitude, locOne.coordinate.longitude];
        item.subtitle=[locInfo objectForKey:@"adr"];
        [arrAnn addObject:item];
//        [self.mpView addAnnotation:item];
        [item release];
    }
    [self.mpView addAnnotations:arrAnn];
}

#pragma mark - 百度地图
#pragma mark 定位委托
//开始定位
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"将要开始定位");
}

//更新坐标
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"获取更新的用户坐标");
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
  
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"添加多个标注");
    BMKAnnotationView * viewOne = [views objectAtIndex:0];
    // viewOne.annotation.coordinate.latitude
    [self.mpView setCenterCoordinate:viewOne.annotation.coordinate];
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

#pragma mark -
#pragma mark Button Item handler
- (void)toggleToolbar:(id) sender
{

}
@end
