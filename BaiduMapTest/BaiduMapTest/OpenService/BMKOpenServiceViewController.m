//
//  BMKOpenServiceViewController.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/10.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "BMKOpenServiceViewController.h"

@interface BMKOpenServiceViewController ()<BMKOpenPanoramaDelegate>

@property(nonatomic,strong)NSArray *dataSourceArray;

// 调启百度地图的全景类
@property(nonatomic,strong)BMKOpenPanorama *openPanorama;

@end

@implementation BMKOpenServiceViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.navTitle;
    self.view.backgroundColor =[UIColor whiteColor];
    self.dataSourceArray = @[@"调启驾车客户端",@"启动POI详情检索",@"调启公交规划",@"启动百度地图步行导航",@"调启百度地图前景"];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    self.openPanorama.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    _openPanorama.delegate = nil;
}

#pragma mark - UITableViewDelegate

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"BaiduMapApiDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    self.dataSourceArray = @[@"调启驾车客户端",@"启动POI详情检索",@"调启公交规划",@"启动百度地图步行导航",@"调启百度地图前景"];

    switch (indexPath.row) {
        case 0:
            
            [self openDriverService];
            break;
        case 1:
            [self openPOiDetailSearch];
            break;
        case 2:
            [self openBusRout];
            break;
        case 3:
            [self openWalkRout];
            break;
        case 4:
            [self openMapPanorama];
            break;
    
            
        default:
            break;
    }
}

#pragma mark -BMKOpenPanoramaDelegate
- (void)onGetOpenPanoramaStatus:(BMKOpenErrorCode) ecode {
    
    if (ecode ==BMK_OPEN_NO_ERROR) {
        mAlertView(@"提示", @"调启百度客户端成功");
    }else if(ecode ==BMK_OPEN_PANORAMA_UID_ERROR){
        mAlertView(@"提示", @"调启百度客户端UId不正确");
    }else {
         mAlertView(@"提示", @"调启百度客户端失败");
    }
}

//调启驾车客户端
-(void)openDriverService {
    // 初始化导航时的参数类
    BMKNaviPara *para =[[BMKNaviPara alloc]init];
    //初始化起点参数
    BMKPlanNode *start =[[BMKPlanNode alloc]init];
    
    CLLocationCoordinate2D startCoor =(CLLocationCoordinate2D){34.890,113.38};
    start.pt =startCoor;
    start.name =@"我的位置";
    
    // 初始化终点
    BMKPlanNode *end =[[BMKPlanNode alloc]init];
    CLLocationCoordinate2D endCoor =(CLLocationCoordinate2D ){34.039,113.89};
    end.pt =endCoor;
    end.name =@"花园口";
    
    // 起点终点参数包装
    para.startPoint =start;
    para.endPoint =end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
    return;
}
//启动POI详情检索
-(void)openPOiDetailSearch {
    BMKOpenPoiDetailOption *opt = [[BMKOpenPoiDetailOption alloc] init];
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    opt.poiUid = @"65e1ee886c885190f60e77ff";
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiDetailPage:opt];
    NSLog(@"%d", code);
    return;

}
//调启公交规划
-(void)openBusRout {
    
    BMKOpenTransitRouteOption *opt = [[BMKOpenTransitRouteOption alloc] init];
    //    opt.appName = @"SDK调起Demo";
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
//    coor1.latitude = 39.90868;
//    coor1.longitude = 116.204;
    //指定起点名称
    start.name = @"郑州东站";
    start.pt = coor1;
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
//    coor2.latitude = 39.90868;
//    coor2.longitude = 116.3956;
    end.pt = coor2;
    //指定终点名称
    end.name = @"紫荆山公园";
    opt.endPoint = end;
    
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapTransitRoute:opt];
    NSLog(@"%d", code);
    return;

}
//启动百度地图步行导航
-(void)openWalkRout {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    end.pt = CLLocationCoordinate2DMake(34.3968, 113.8456);
    //指定终点名称
    end.name = @"动物园";
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端
    BMKOpenErrorCode code = [BMKNavigation openBaiduMapWalkNavigation:para];
    NSLog(@"调起步行导航：errorcode=%d", code);
}
//调启百度地图前景
-(void)openMapPanorama {
    BMKOpenPanoramaOption *option = [[BMKOpenPanoramaOption alloc] init];
    //指定返回自定义scheme
    option.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    option.poiUid = @"65e1ee886c885190f60e77ff";
    //调起百度地图全景页面,异步方法
    [_openPanorama openBaiduMapPanorama:option];
}


#pragma mark - Private Methods


#pragma mark - Setter & Getter
-(BMKOpenPanorama *)openPanorama {
    if (!_openPanorama) {
        _openPanorama =[[BMKOpenPanorama alloc]init];
    }
    return _openPanorama;
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
