//
//  MainPageViewController.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJLWeatherView.h"
#import "AddLocationViewController.h"

@interface MainPageViewController : UIViewController<UIScrollViewDelegate, CLLocationManagerDelegate, ZJLWeatherViewDelegate, AddLocationViewControllerDelegate>
@property (nonatomic,readonly,strong) CLLocationManager *locationManager;
- (void)updateWeatherData;

@end
