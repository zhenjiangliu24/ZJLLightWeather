//
//  ZJLWeatherScrollView.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLWeatherScrollView : UIScrollView
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index;
- (void)addSubview:(UIView *)view show:(BOOL)isShow;
- (void)removeSubView:(UIView *)view;
@end
