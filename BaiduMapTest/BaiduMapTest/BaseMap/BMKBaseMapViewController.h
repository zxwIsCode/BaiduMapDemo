//
//  BMKBaseMapViewController.h
//  BaiduMapTest
//
//  Created by 李保东 on 16/11/8.
//  Copyright © 2016年 DaviD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKSuperViewController.h"


@interface BMKBaseMapViewController : BMKSuperViewController<BMKMapViewDelegate>

@property(nonatomic,strong)BMKMapView *mapView;

@end
