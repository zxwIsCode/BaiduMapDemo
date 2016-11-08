//
//  BMKMainListViewController.m
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/8.
//  Copyright © 2016年 李保东. All rights reserved.
//

#import "BMKMainListViewController.h"
#import "BMKSuperViewController.h"

#define kMainListCellId @"kMainListCellId"


@interface BMKMainListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

// 所有的百度地图的功能数组（字符串）
@property(nonatomic,strong)NSMutableArray *allBaiduArray;

@property(nonatomic,strong)NSMutableArray *allBaiduTitle;



@end

@implementation BMKMainListViewController

#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"百度地图DaviD";
    [self.view addSubview:self.tableView];
    [self initWithDatas];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - Private Methods
-(void)initWithDatas {
    self.allBaiduArray =[@[@"BMKBaseMapViewController",@"BMKPoiSearchViewController"] mutableCopy];
    self.allBaiduTitle =[@[@"基本功能",@"POI搜索"] mutableCopy];
}
#pragma mark - Action Methods

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allBaiduArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:kMainListCellId forIndexPath:indexPath];
    if (cell !=nil) {
        if (self.allBaiduArray) {
            
            cell.textLabel.text =[NSString stringWithFormat:@"%@___%@",self.allBaiduTitle[indexPath.row],self.allBaiduArray[indexPath.row]];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.allBaiduArray) {
        NSString *viewClassStr =self.allBaiduArray[indexPath.row];
        BMKSuperViewController *viewController =[[NSClassFromString(viewClassStr) alloc]init];
        viewController.navTitle =self.allBaiduTitle[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark - Setter & Getter
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT ) style:UITableViewStylePlain];
        _tableView.delegate =self;
        _tableView.dataSource =self;
        _tableView.bounces =NO;
        _tableView.backgroundColor =[UIColor whiteColor];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMainListCellId];
    }
    return _tableView;
}
-(NSMutableArray *)allBaiduArray {
    if (!_allBaiduArray) {
        _allBaiduArray =[NSMutableArray array];
    }
    return _allBaiduArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
