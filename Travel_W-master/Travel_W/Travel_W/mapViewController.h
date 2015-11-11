//
//  mapViewController.h
//  Travel_W
//
//  Created by 王萌 on 15/9/29.
//  Copyright (c) 2015年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface mapViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (retain,nonatomic)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) NSDictionary *dict;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,strong) PFObject *Attractions;
@property (nonatomic,strong)MKPointAnnotation *mAnnotation;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) CGFloat latitude;
@property (nonatomic,copy) NSString *mAddress;
@end
