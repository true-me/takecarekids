//
//  BMViewController.m
//  KidMap
//
//  Created by Jeffrey Ma on 2/14/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "BMViewController.h"

#pragma mark - 自定义宏
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

BOOL isRetina = FALSE;
#pragma mark - RouteAnnotation Class definition
@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation
@synthesize type = _type;
@synthesize degree = _degree;
@end

#pragma mark - UIImage Class definition
@interface UIImage(InternalMethod)
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;
@end

@implementation UIImage(InternalMethod)
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    CGSize rotatedSize = self.size;
   if (isRetina)
   {
        rotatedSize.width *= 2;
        rotatedSize.height *= 2;
    }
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

#pragma mark - BMViewController Class definition & declaration

@interface BMViewController ()

@end

@implementation BMViewController

@synthesize _search;//搜索要用到的
@synthesize mapView;//地图视图
@synthesize fromText;
@synthesize cityStr;
@synthesize cityName;
@synthesize startPt;
@synthesize localLatitude;
@synthesize localLongitude;
@synthesize localJudge;
@synthesize pathArray;
@synthesize lbl;
@synthesize mapManager;
@synthesize routeLine;
@synthesize routeLineView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Third", @"Third");
        self.tabBarItem.image = [UIImage imageNamed:@"Third"];
    }
    return self;
}

- (void)dealloc
{
    [mapView release];
    [lbl release];
    [fromText release];
    [mapManager release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 百度地图api提供16个级别的缩放
    //     {"20m","50m","100m","200m","500m","1km","2km","5km","10km","20km","25km","50km","100km","200km","500km","1000km","2000km"}  
    // {"50m","100m","200m","500m","1km","2km","5km","10km","20km","25km","50km","100km","200km","500km","1000km","2000km"}
    //启动BMKMapManager
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"2772BD5CAFF652491F65707D6D5E9ABEBF3639CC" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    BMKMapView *mv = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.mapView = mv;
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];//显示定位的蓝点儿
    [self.mapView setZoomEnabled:YES];

    [mv release];
    
//    <wpt lat="34.23553" lon="108.89257">
//    <name>西安高新四路创业广场星巴克</name>
    CLLocationCoordinate2D coordinate;                  //设定经纬度
    coordinate.latitude = 34.23553;         //纬度
    coordinate.longitude = 108.89257;      //经度

//    [self.mapView setZoomLevel:18];
//    
    [self.mapView setCenterCoordinate:coordinate animated:YES];

    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.001f, 0.001f));
    //[self.mapView setRegion:viewRegion animated:YES];

    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
//  
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    self.pathArray = arr;  //用来记录路线信息的，以后会用到
    [arr release];
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
//                                                      longitude:coordinate.longitude];
//    [self.pathArray addObject:location];
//    [location release];
//    
//    coordinate.latitude = 34.23654;         //纬度
//    coordinate.longitude = 108.89258;      //经度
//    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:coordinate.latitude
//                                                      longitude:coordinate.longitude];
//    [self.pathArray addObject:location1];
//    [location1 release];
//    
//    coordinate.latitude = 34.27564;         //纬度
//    coordinate.longitude = 108.89258;      //经度
//    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:coordinate.latitude
//                                                       longitude:coordinate.longitude];
//    [self.pathArray addObject:location2];
//    [location2 release];
//    
//    [self configureRoutes];
    
    
//[self.mapView setCenterCoordinate:coordinate animated:YES];
//

//    BMKSearch *bmSearch = [[BMKSearch alloc] init];//search类，搜索的时候会用到
//    self._search = bmSearch;
//    self._search.delegate = self;
//    [bmSearch release];
//    
//    self.fromText.text = @"新中关";
//    
//    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
//    if (fabs(screenSize.width - 640.0f) < 0.1
//        && fabs(screenSize.height - 960.0f) < 0.1)
//    {
//        isRetina = TRUE;
//    }
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    self.pathArray = arr;  //用来记录路线信息的，以后会用到
//    [arr release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法

-(NSString *)getMyBundlePath1:(NSString *)filename
{
    NSBundle * libBundle = MYBUNDLE;
    if (libBundle && filename)
    {
        NSString * s=[[libBundle resourcePath] stringByAppendingPathComponent: filename];
        NSLog(@"%@" ,s);
        return s;
    }
    return nil ;
}

-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{

    CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude
                                                      longitude:userLocation.coordinate.longitude];
    // check the zero point
    if  (userLocation.coordinate.latitude == 0.0f ||
         userLocation.coordinate.longitude == 0.0f)
        return;
    
    // check the move distance
    if (self.pathArray.count > 0)
    {
        CLLocationDistance distance = [location distanceFromLocation:_currentLocation];
        if (distance < 5)
            return;
    }
    
    if (nil == self.pathArray) {
        self.pathArray = [[NSMutableArray alloc] init];
    }
    
    [self.pathArray addObject:location];
    _currentLocation = location;
    
    NSLog(@"points: %@", self.pathArray);
    
    [self configureRoutes];
    
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//    [self.mapView setCenterCoordinate:coordinate animated:YES];
//    return;
//    
//    NSLog(@"!latitude!!!  %f",userLocation.location.coordinate.latitude);//获取经度
//    
//    NSLog(@"!longtitude!!!  %f",userLocation.location.coordinate.longitude);//获取纬度
//    
//    localLatitude=userLocation.location.coordinate.latitude;//把获取的地理信息记录下来
//    
//    localLongitude=userLocation.location.coordinate.longitude;
//    
//    CLGeocoder *Geocoder=[[CLGeocoder alloc]init];//CLGeocoder用法参加之前博客
//    
//    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
//        
//        for (CLPlacemark *placemark in place)
//        {
//            
//            cityStr=placemark.thoroughfare;
//            cityName=placemark.locality;
//
//            NSLog(@"%@, %@, %@, %@", placemark.locality, placemark.subLocality
//                            , placemark.thoroughfare, placemark.subThoroughfare);//获取街道地址
//            break;
//            
//        }
//        
//    };
//    
//    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
//    
//    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];
}


#pragma mark - 1：地图区域改变时候调用函数：
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}

- (void)configureRoutes
{
    // define minimum, maximum points
	BMKMapPoint northEastPoint = BMKMapPointMake(0.f, 0.f);
	BMKMapPoint southWestPoint = BMKMapPointMake(0.f, 0.f);
	
	// create a c array of points.
    //    NSMutableArray *mapPointarr = [NSMutableArray arrayWithObjects:<#(const id *)#> count:<#(NSUInteger)#>
    BMKMapPoint* pointArray = malloc(sizeof(CLLocationCoordinate2D) * self.pathArray.count);
    
	// for(int idx = 0; idx < pointStrings.count; idx++)
    for(int idx = 0; idx < self.pathArray.count; idx++)
	{
        CLLocation *location = [self.pathArray objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
		CLLocationDegrees longitude = location.coordinate.longitude;
        
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
        [self.mapView removeOverlay:self.routeLine];
    }
    
    self.routeLine = [BMKPolyline polylineWithPoints:pointArray count:self.pathArray.count];
    
    // add the overlay to the map
	if (nil != self.routeLine) {
		[self.mapView addOverlay:self.routeLine];
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
        self.routeLineView.lineWidth = 10;
        
		overlayView = self.routeLineView;
	}
	
	return overlayView;
}
@end
