//
//  BMKPoiSearchViewController.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/8.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import "BMKPoiSearchViewController.h"

@interface BMKPoiSearchViewController ()

// 检索的条件（以lable代替）
@property(nonatomic,strong)UILabel *detailLable;
// 开始检索按钮
@property(nonatomic,strong)UIButton *startSearchButton;
// 搜索到信息后的下一组数据
@property(nonatomic,strong)UIButton *nextDataButton;

@property(nonatomic,strong)BMKMapView *mapView;

//百度地图提供的poi搜索对象
@property(nonatomic,strong)BMKPoiSearch *poiSearch;

@property(nonatomic,copy)NSString *cityStr;
@property(nonatomic,copy)NSString *keyword;

@property(nonatomic,assign)int currentPage;

@end

@implementation BMKPoiSearchViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mapView setZoomLevel:18];
    self.nextDataButton.enabled =NO;
    self.mapView.isSelectedAnnotationViewFront =YES;
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.detailLable];
    [self.view addSubview:self.startSearchButton];
    [self.view addSubview:self.nextDataButton];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.poiSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.cityStr =@"郑州";
    self.keyword =@"酒店";
    self.detailLable.text =[NSString stringWithFormat:@"在  %@    市内查找   %@    ",self.cityStr,self.keyword];
    
    self.detailLable.frame =CGRectMake(0, 64, SCREEN_WIDTH, 40);
    self.startSearchButton.frame =CGRectMake(20, 64 +40, 120, 50);
    self.nextDataButton.frame =CGRectMake(SCREEN_WIDTH -20 -120, 64 +40, 120, 50);
    self.mapView.frame =CGRectMake(0, 64 +40 +50, SCREEN_WIDTH, SCREEN_HEIGHT -(64 +40 +50));

}


-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    self.poiSearch.delegate = nil; // 不用时，置nil
}
- (void)dealloc {
    if (_poiSearch != nil) {
        _poiSearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}

#pragma mark - Private Methods

#pragma mark - Action Methods

-(void)startButtonSearchClick:(UIButton *)button {
    
    self.currentPage =0;
    BMKCitySearchOption *cityOption =[[BMKCitySearchOption alloc]init];
    cityOption.pageIndex =self.currentPage;
    cityOption.city =self.cityStr;
    cityOption.keyword =self.keyword;
    
    BOOL flag =[self.poiSearch poiSearchInCity:cityOption];
    if (flag) {
        self.nextDataButton.enabled =YES;
        NSLog(@"城市内检索发送成功");
        
    }else {
        self.nextDataButton.enabled =NO;
        NSLog(@"城市内检索发送失败");

    }
    
}

-(void)nextDataClick:(UIButton *)button {
    self.currentPage ++;
    
    //城市内检索，请求发送成功返回YES，请求发送失败返回NO
    BMKCitySearchOption *cityOption =[[BMKCitySearchOption alloc]init];
    cityOption.pageIndex =self.currentPage;
    cityOption.pageCapacity =10;
    cityOption.city =self.cityStr;
    cityOption.keyword =self.keyword;
    
    BOOL flag =[self.poiSearch poiSearchInCity:cityOption];
    if (flag) {
        self.nextDataButton.enabled =YES;
        NSLog(@"城市内检索发送成功");
        
    }else {
        self.nextDataButton.enabled =NO;
        NSLog(@"城市内检索发送失败");
        
    }
}


#pragma mark - BMKMapViewDelegate
// 根据传过来的模型对象生成对应的大头针View
// 其中BMKPinAnnotationView 继承BMKAnnotationView，BMKPinAnnotationView 多了可以定制大头针的颜色和动画效果
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSLog(@"根据BMKAnnotation，生成对应的BMKAnnotationView");
    NSString *annotationId =@"annotationId";
    BMKAnnotationView *annnotationView =[mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
    if (annnotationView ==nil) {
        annnotationView =[[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationId];
        // 设置大头针的颜色
        ((BMKPinAnnotationView *)annnotationView).pinColor =BMKPinAnnotationColorPurple;
        // 设置大头针出来的效果
        ((BMKPinAnnotationView *)annnotationView).animatesDrop =YES;
    }
    // 设置大头针的位置
    annnotationView.centerOffset =CGPointMake(0, -(annnotationView.frame.size.height) *0.5);
    annnotationView.annotation =annotation;
    // 单击是否可以弹出详情泡泡，前提annotation必须实现title属性
    annnotationView.canShowCallout =YES;
    //    设置是否可以拖拽前提是实现了setCoordinate:方法时
    annnotationView.draggable =NO;
    
    return annnotationView;
}
// 点击大头针的操作
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"选择对应的BMKAnnotationView");
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}
// 把生成的大头针View添加到地图上走的方法
-(void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"添加BMKAnnotationView");
}

#pragma mark - BMKSearchDelegate
-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    // 清除屏幕中所有的annotation
    NSLog(@"poiResult = %@,errorCode = %u",poiResult,errorCode);
    NSArray *array =[NSArray arrayWithArray:self.mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    // 获得到的所有搜索结果包装为模型数组
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *annotionArray =[NSMutableArray array];
        for (int index =0; index <poiResult.poiInfoList.count; index ++) {
            BMKPoiInfo *poi =poiResult.poiInfoList[index];
            BMKPointAnnotation *item =[[BMKPointAnnotation alloc]init];
            item.coordinate =poi.pt;
            item.title =@"My Name Is DaviD";
            item.subtitle =poi.name;

            [annotionArray addObject:item];
        }
        // 把大头针添加到mapView触发以下2个方法先后顺序为：
        //1.viewForAnnotation: 目的：根据传过来的annotion生成对应的View
        //2.didAddAnnotationViews: 之后添加到地图上
        [self.mapView addAnnotations:annotionArray];
        // 大头针到地图上实现的动画
        [self.mapView showAnnotations:annotionArray animated:YES];
    }else if(errorCode ==BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {
        NSLog(@"起始点有歧义");
    }else {
        NSLog(@"未知情况");
    }
    
}

#pragma mark - Setter & Getter

-(BMKMapView *)mapView {
    if (!_mapView) {
        _mapView =[[BMKMapView alloc]init];
    }
    return _mapView;
}
-(BMKPoiSearch *)poiSearch {
    if (!_poiSearch) {
        _poiSearch =[[BMKPoiSearch alloc]init];
    }
    return _poiSearch;
}
-(UILabel *)detailLable {
    if (!_detailLable) {
        _detailLable =[[UILabel alloc]init];
        _detailLable.backgroundColor =UIColorFromHexValue(0xf0f0f0);
        _detailLable.textAlignment =NSTextAlignmentCenter;
    }
    return _detailLable;
}
-(UIButton *)startSearchButton {
    if (!_startSearchButton) {
        _startSearchButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_startSearchButton setTitle:@"开始搜索" forState:UIControlStateNormal];
        [_startSearchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_startSearchButton addTarget:self action:@selector(startButtonSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startSearchButton;
}
-(UIButton *)nextDataButton {
    if (!_nextDataButton) {
        _nextDataButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_nextDataButton setTitle:@"下一组" forState:UIControlStateNormal];
        [_nextDataButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_nextDataButton addTarget:self action:@selector(nextDataClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextDataButton;
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
