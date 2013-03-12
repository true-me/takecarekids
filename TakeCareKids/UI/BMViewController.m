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
    NSLog(@"!latitude!!!  %f",userLocation.location.coordinate.latitude);//获取经度
    
    NSLog(@"!longtitude!!!  %f",userLocation.location.coordinate.longitude);//获取纬度
    
    localLatitude=userLocation.location.coordinate.latitude;//把获取的地理信息记录下来
    
    localLongitude=userLocation.location.coordinate.longitude;
    
    CLGeocoder *Geocoder=[[CLGeocoder alloc]init];//CLGeocoder用法参加之前博客
    
    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error) {
        
        for (CLPlacemark *placemark in place)
        {
            
            cityStr=placemark.thoroughfare;
            cityName=placemark.locality;

            NSLog(@"%@, %@, %@, %@", placemark.locality, placemark.subLocality
                            , placemark.thoroughfare, placemark.subThoroughfare);//获取街道地址
            break;
            
        }
        
    };
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];
}


#pragma mark - 1：地图区域改变时候调用函数：
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
}
@end
