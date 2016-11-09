//
//  BMKBaseMapViewController.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/8.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "BMKBaseMapViewController.h"

@interface BMKBaseMapViewController ()

@property(nonatomic,assign)BOOL isAutoMap;

@property(nonatomic,strong)BMKLocationService *locService;

@end

@implementation BMKBaseMapViewController

#pragma mark - Init

+ (void)initialize {
    
    // 设置必须在BMKMapView初始化之前（会影响所有地图示例）
    NSString *path =[[NSBundle mainBundle] pathForResource:@"custom_config_黑夜" ofType:@""];
    [BMKMapView customMapStyle:path];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
    [self creatSegement];
    
    self.locService =[[BMKLocationService alloc]init];
    
    [self startLocation];

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate =self;
    [BMKMapView enableCustomMapStyle:self.isAutoMap];
}

-(void)viewWillDisappear:(BOOL)animated {
    [BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.locService.delegate =nil;
}

-(void)dealloc {
    if (_mapView) {
        _mapView =nil;
    }
}

#pragma mark - Private Methods
-(void)startLocation {
    [self.locService startUserLocationService];
    self.mapView.showsUserLocation =NO;
    self.mapView.userTrackingMode =BMKUserTrackingModeFollow;
    self.mapView.showsUserLocation =YES;

}
-(void)creatSegement {
    UISegmentedControl *segment =[[UISegmentedControl alloc]initWithItems:@[@"正常",@"夜间"]];
    segment.selectedSegmentIndex =0;
    [segment addTarget:self action:@selector(segementToChangeIndex:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:segment];
    self.isAutoMap =NO;
    
}
#pragma mark - BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


#pragma mark - Action Methods

-(void)segementToChangeIndex:(UISegmentedControl *)segment {
    
    self.isAutoMap = segment.selectedSegmentIndex == 1;
    
    [BMKMapView enableCustomMapStyle:self.isAutoMap];
}

#pragma mark - Setter & Getter

-(BMKMapView *)mapView {
    if (!_mapView) {
        _mapView =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
    }
    return _mapView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
