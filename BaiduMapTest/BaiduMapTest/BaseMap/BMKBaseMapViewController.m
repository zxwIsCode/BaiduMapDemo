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

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [BMKMapView enableCustomMapStyle:self.isAutoMap];
}

-(void)viewWillDisappear:(BOOL)animated {
    [BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
}

-(void)dealloc {
    if (_mapView) {
        _mapView =nil;
    }
}

#pragma mark - Private Methods

-(void)creatSegement {
    UISegmentedControl *segment =[[UISegmentedControl alloc]initWithItems:@[@"正常",@"夜间"]];
    segment.selectedSegmentIndex =0;
    [segment addTarget:self action:@selector(segementToChangeIndex:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:segment];
    self.isAutoMap =NO;
    
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
