//
//  ZJLDataManager.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJLWeatherData;

typedef NS_ENUM(NSInteger, ZJLTempScale){
    ZJLFa = 0,
    ZJLCe
};

@interface ZJLDataManager : NSObject
+ (ZJLTempScale)tempScale;
+ (void)setTempScale:(ZJLTempScale)tempScale;
+ (NSDictionary *)weatherData;
+ (void)setWeatherData:(NSDictionary *)weatherData;
+ (NSArray *)weatherTag;
+ (void)setWeatherTag:(NSArray *)weatherTag;
@end
