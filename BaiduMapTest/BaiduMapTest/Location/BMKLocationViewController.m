//
//  BMKLocationViewController.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/9.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "BMKLocationViewController.h"

@interface BMKLocationViewController ()
// 定位类
@property(nonatomic,strong)BMKLocationService *locService;
// 地图类
@property(nonatomic,strong)BMKMapView *mapView;
// 定位图层的样式
@property(nonatomic,strong)BMKLocationViewDisplayParam *locViewParam;

@property(nonatomic,strong)NSMutableArray *allButtonArray;

@end

@implementation BMKLocationViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatAllButton];
    [self creatRightBarButtonItem];
    [self.view addSubview:self.mapView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - Private Methods

-(void)creatRightBarButtonItem {
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:@"自定义图层" style:UIBarButtonItemStyleDone target:self action:@selector(changeMapYangShi:)];
    self.navigationItem.rightBarButtonItem =item;
}

-(void)creatAllButton {
    CGFloat buttonW =SCREEN_WIDTH /4.0;
    CGFloat buttonH =40;
    
    NSArray *buttonTitleArray =@[@"开始定位",@"使用跟随",@"使用罗盘",@"停止定位"];
    
    for (int i =0; i<4; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =i;
        button.backgroundColor =[UIColor redColor];
        button.layer.borderColor =[UIColor blackColor].CGColor;
        button.layer.borderWidth =2;
        [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
        button.frame =CGRectMake(buttonW *i, 64, buttonW, buttonH);
        [button addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHexValue(0xf0f0f0) forState:UIControlStateSelected];
        [self.view addSubview:button];
        [self.allButtonArray addObject:button];
        
        // 设置button的状态
//        if (button.tag !=0) {
//            button.selected =YES;
//            button.userInteractionEnabled =NO;
//        }
    }
}

#pragma mark - Action Methods
 // 自定义图层的样式（包括颜色和位置等）
-(void)changeMapYangShi:(UIBarButtonItem *)item {
   
    // 改变定位图层系统的默认参数
    self.locViewParam.accuracyCircleFillColor =[UIColor redColor];
    self.locViewParam.locationViewOffsetX =100;
    self.locViewParam.locationViewOffsetY =200;
    
    // 更新到设置的参数
    [self.mapView updateLocationViewWithParam:self.locViewParam];
}
-(void)selectButtonClick:(UIButton *)button {
    switch (button.tag) {
        case 0:
            NSLog(@"进入普通定位状态");
            // 开启定位状态
            [self.locService startUserLocationService];
            // 设置定位图层特点（每次修改图层属性，都要先关闭，再设置，最后再打开）
            self.mapView.showsUserLocation =NO;
            self.mapView.userTrackingMode =BMKUserTrackingModeNone;
            self.mapView.showsUserLocation =YES;
            
//            button.selected =YES;
//            button.userInteractionEnabled =NO;

            break;
        case 1:
            NSLog(@"进入跟随状态");
            // 设置定位图层特点（每次修改图层属性，都要先关闭，再设置，最后再打开）
            self.mapView.showsUserLocation =NO;
            self.mapView.userTrackingMode =BMKUserTrackingModeFollow;
            self.mapView.showsUserLocation =YES;

            break;
        case 2:
            NSLog(@"进入罗盘状态");
            // 设置定位图层特点（每次修改图层属性，都要先关闭，再设置，最后再打开）
            self.mapView.showsUserLocation =NO;
            self.mapView.userTrackingMode =BMKUserTrackingModeFollowWithHeading;
            self.mapView.showsUserLocation =YES;

            
            break;
        case 3:
            NSLog(@"停止定位状态");
            [self.locService stopUserLocationService];
            self.mapView.showsUserLocation =NO;

            
            break;
            
        default:
            NSLog(@"未知状态");

            break;
    }
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
    [self.mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
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



#pragma mark - Setter & Getter
-(NSMutableArray *)allButtonArray {
    if (!_allButtonArray) {
        _allButtonArray =[NSMutableArray array];
    }
    return _allButtonArray;
}
-(BMKMapView *)mapView {
    
    if (!_mapView) {
        _mapView =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 40 +64, SCREEN_WIDTH, SCREEN_HEIGHT -40)];
    }
    return _mapView;
}
-(BMKLocationService *)locService {
    if (!_locService) {
        _locService =[[BMKLocationService alloc]init];
    }
    return _locService;
}

-(BMKLocationViewDisplayParam *)locViewParam {
    if (!_locViewParam) {
        _locViewParam = [[BMKLocationViewDisplayParam alloc]init];
    }
    return _locViewParam;
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
