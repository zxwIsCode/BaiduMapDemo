//
//  BMKGeocodeViewController.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/10.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "BMKGeocodeViewController.h"

@interface BMKGeocodeViewController ()<BMKMapViewDelegate, BMKGeoCodeSearchDelegate>

// 正向地理编码
@property(nonatomic,strong)UIButton *geoButton;
// 反向地理编码
@property(nonatomic,strong)UIButton *reverseGeoButton;
// 地图类
@property(nonatomic,strong)BMKMapView *mapView;
// 正反编码搜索类
@property(nonatomic,strong)BMKGeoCodeSearch *geoSearch;

@end

@implementation BMKGeocodeViewController

#pragma mark - Init

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.geoButton];
    [self.view addSubview:self.reverseGeoButton];
    [self.view addSubview:self.mapView];
    
    [self.mapView setZoomLevel:14];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.geoSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    self.geoButton.frame =CGRectMake(0, 64, 150, 40);
    self.reverseGeoButton.frame =CGRectMake(SCREEN_WIDTH -150, 64, 150, 40);
    self.mapView.frame =CGRectMake(0, 64 + 40, SCREEN_WIDTH, SCREEN_HEIGHT -64 -40);
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _geoSearch.delegate = nil; // 不用时，置nil
    _geoSearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_geoSearch != nil) {
        _geoSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
#pragma mark - Private Methods

#pragma mark - Action Methods
// 正向地理编码
-(void)geoCodeButtonClick:(UIButton *)button {
    
    BMKGeoCodeSearchOption *geoSearchOption =[[BMKGeoCodeSearchOption alloc] init];
    geoSearchOption.city =@"郑州";
    geoSearchOption.address =@"花园路口";
    BOOL flag =[self.geoSearch geoCode:geoSearchOption];
    if (flag) {
        NSLog(@"geo 检索成功");
    }else {
        NSLog(@"geo 检索失败");
    }
    
}
// 反向地理编码
-(void)reverseGeoButtonClick:(UIButton *)button {
    
    BMKReverseGeoCodeOption *reverseCodeOption =[[BMKReverseGeoCodeOption alloc]init];
    reverseCodeOption.reverseGeoPoint =(CLLocationCoordinate2D){35.300,112.877};
    BOOL flag =[self.geoSearch reverseGeoCode:reverseCodeOption];
    if (flag) {
        NSLog(@"反geo 检索成功");
    }else {
        NSLog(@"反geo 检索失败");
    }}
#pragma mark - BMKMapViewDelegate
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    return annotationView;
}
#pragma mark - BMKGeoCodeSearchDelegate

// geo 编码
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    // 清除地图上所有的标记和overlay 图层
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    if (error == 0) {
        BMKPointAnnotation *item =[[BMKPointAnnotation alloc]init];
        item.coordinate =result.location;
        item.title =result.address;
        [self.mapView addAnnotation:item];
        self.mapView.centerCoordinate =result.location;
        
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        mAlertView(titleStr, showmeg);
    }
    
}
// 反 geo 编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    // 清除地图上所有的标记和overlay 图层
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    if (error == 0) {
        BMKPointAnnotation *item =[[BMKPointAnnotation alloc]init];
        item.coordinate =result.location;
        item.title =result.address;
        [self.mapView addAnnotation:item];
        self.mapView.centerCoordinate =result.location;
        
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        mAlertView(titleStr, showmeg);
    }
}

#pragma mark - Setter & Getter

-(UIButton *)geoButton {
    if (!_geoButton) {
        _geoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _geoButton.backgroundColor =[UIColor redColor];
        [_geoButton setTitle:@"地理编码" forState:UIControlStateNormal];
        [_geoButton addTarget:self action:@selector(geoCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _geoButton;
}
-(UIButton *)reverseGeoButton {
    if (!_reverseGeoButton) {
        _reverseGeoButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _reverseGeoButton.backgroundColor =[UIColor redColor];
        [_reverseGeoButton setTitle:@"反编码" forState:UIControlStateNormal];
        [_reverseGeoButton addTarget:self action:@selector(reverseGeoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reverseGeoButton;
}
-(BMKMapView *)mapView {
    if (!_mapView) {
        _mapView =[[BMKMapView alloc]init];
    }
    return _mapView;
}
-(BMKGeoCodeSearch *)geoSearch {
    if (!_geoSearch) {
        _geoSearch =[[BMKGeoCodeSearch alloc]init];
    }
    return _geoSearch;
}

@end
