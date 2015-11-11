//
//  mapViewController.m
//  Travel_W
//
//  Created by 王萌 on 15/9/29.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import "mapViewController.h"
#define  GET_CITY_URL   @"http://api.map.baidu.com/geocoder?location="
#define  GET_CITY_BACK_TYPE  @"&output=json"
@interface mapViewController ()

@end

@implementation mapViewController
@synthesize mAddress;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager performSelector:@selector(requestWhenInUseAuthorization)];
        }
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager performSelector:@selector(requestAlwaysAuthorization)];
        }
#endif
    }
    [_locationManager startUpdatingLocation];
    
    _longitude = [_Attractions[@"Longitude"] floatValue];
    _latitude = [_Attractions[@"Latitude"] floatValue];
    [self SetMapRegion];
    [self createAnnotations];
    //是否实现 点击切换坐标
    [self addGestureRecognizer];
    
    _longitudeLabel.text = _Attractions[@"Longitude"];
    _latitudeLabel.text = _Attractions[@"Latitude"];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //设置地图能否放大缩小
    _mapView.zoomEnabled = YES;
    //设置地图能否滚动
    _mapView.scrollEnabled = YES;
    
    [_mapView setDelegate:self];
    [_mapView setMapType:MKMapTypeStandard];

    //CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.longitude, self.latitude);
    
    //设置显示用户的位置
    if ([CLLocationManager locationServicesEnabled] == YES){
       _mapView.showsUserLocation = YES;
        //设置跟随用户
      [_mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
  }
    [self.view addSubview:_mapView];

}
//插大头针让气泡直接显示的代理
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKPinAnnotationView * piview = (MKPinAnnotationView *)[views objectAtIndex:0];
    [self.mapView selectAnnotation:piview.annotation animated:YES];
}

-(void)SetMapRegion
{
    CLLocationCoordinate2D myCoordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    NSLog(@"latitude = %f", myCoordinate.latitude);
    NSLog(@"longitude = %f", myCoordinate.longitude);
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center = myCoordinate;
    theRegion.span.longitudeDelta = 0.01f;
    theRegion.span.latitudeDelta = 0.01f;
    [_mapView setRegion:theRegion animated:YES];
}
#pragma  mark - 创建大头针 并且加载到MapView上 要是不创建大头针的话 是不能进入MKAnnotationView的代理方法的
- (void)createAnnotations
{
    _mAnnotation = [[MKPointAnnotation alloc] init];
    _mAnnotation.title = _Attractions[@"DetailAddress"];
    _mAnnotation.coordinate = CLLocationCoordinate2DMake(self.latitude,self.longitude);
    [_mapView addAnnotation:_mAnnotation];
}

#pragma  mark - 长按插针
- (void)addGestureRecognizer
{
    UILongPressGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_mapView addGestureRecognizer:singleRecognizer];
}

#pragma mark - mapview协议回调方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //用户位置更新
    [self adjustLocationOffset:userLocation];
}

//管理大头针视图，类似于tableView的cell管理
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]] == NO) {
        //这方法在刷新时会将用户的位置点也传进来，所以判断一下，如果不是大头针是用户坐标点返回nil
        return nil;
    }
    MKAnnotationView * annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotationView"];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotationView"];
    } else {
        annotationView.annotation = annotation;
    }
    //对这张图片进行剪切 ， scale 越大图片越小
    UIImage * image = [UIImage imageNamed:@"marker_inside_pink.png"];
    NSData * imageData = UIImagePNGRepresentation(image);
    image = [UIImage imageWithData:imageData scale:9];
    
    annotationView.image = image;
    
    //设置允许显示气泡  这个是显示承载的信息
    annotationView.canShowCallout = YES;
    return annotationView;
}

#pragma mark -纠正偏移量

- (void) adjustLocationOffset:(MKUserLocation *)userLocation {
    // 通过地图定位纠正CLLocationManager的偏差
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    region.center.latitude = userLocation.coordinate.latitude;
    region.center.longitude = userLocation.coordinate.longitude;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint mTouchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D mTouchMapCoordinate = [_mapView convertPoint:mTouchPoint toCoordinateFromView:_mapView];
#pragma matk  - 这个是可以获取点击的地址
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *loctionString = [NSString stringWithFormat:@"%3.7f,%3.7f",mTouchMapCoordinate.latitude,mTouchMapCoordinate.longitude];
        
        NSURL *cityUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",GET_CITY_URL, loctionString, GET_CITY_BACK_TYPE]];
        NSURLRequest *cityRequest = [NSURLRequest requestWithURL:cityUrl];
        NSData *requestData = [NSURLConnection sendSynchronousRequest:cityRequest returningResponse:nil error:nil];
        NSString *str = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        
        id cityInfo = [NSJSONSerialization JSONObjectWithData:requestData options:NSUTF8StringEncoding error:nil];
        if (cityInfo &&[cityInfo isKindOfClass:[NSDictionary class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _Attractions[@"DetailAddress"] = [NSString stringWithFormat:@"%@",([[cityInfo objectForKey:@"result"] objectForKey:@"formatted_address"])];
            });
        }
    });
    _mAnnotation.title = _Attractions[@"DetailAddress"];
    _mAnnotation.coordinate = mTouchMapCoordinate;
    [_mapView addAnnotation:(id <MKAnnotation>)_mAnnotation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
