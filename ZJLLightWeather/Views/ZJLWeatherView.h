//
//  ZJLWeatherView.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJLWeatherView;
@protocol ZJLWeatherViewDelegate<NSObject>
- (BOOL)shouldPanWeatherView:(ZJLWeatherView *)weatherView;
- (void)didBeginPanWeatherView:(ZJLWeatherView *)weatherView;
- (void)didFinishPanWeatherView:(ZJLWeatherView *)weatherView;
@end

@interface ZJLWeatherView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL hasData;
@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, weak) id<ZJLWeatherViewDelegate> delegate;
@property (nonatomic, readonly, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, readonly, strong) UILabel *currentTempLabel;
@property (nonatomic, readonly, strong) UILabel *highTempLabel;
@property (nonatomic, readonly, strong) UILabel *lowTempLabel;
@property (nonatomic, readonly, strong) UILabel *followingOneLabel;
@property (nonatomic, readonly, strong) UILabel *followingOneIcon;
@property (nonatomic, readonly, strong) UILabel *followingTwoLabel;
@property (nonatomic, readonly, strong) UILabel *followingTwoIcon;
@property (nonatomic, readonly, strong) UILabel *followingThreeLabel;
@property (nonatomic, readonly, strong) UILabel *followingThreeIcon;
@property (nonatomic, readonly, strong) UILabel *updateTimeLabel;
@property (nonatomic, readonly, strong) UIActivityIndicatorView *activityIndicator;
- (void)setBackgroundColorWithWeatherType:(NSString *)weatherType;
@end
