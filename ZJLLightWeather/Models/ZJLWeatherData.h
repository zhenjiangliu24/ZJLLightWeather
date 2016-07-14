//
//  ZJLWeatherData.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//



typedef struct {
    CGFloat fahrenheit;
    CGFloat celsius;
} ZJLTemperatureType;

static inline ZJLTemperatureType ZJLTemperatureMake(CGFloat fahrenheit, CGFloat celsius) {
    return (ZJLTemperatureType){fahrenheit, celsius};
}

@interface ZJLWeatherDay : NSObject<NSCoding>
//  Icon representing the day's conditions
@property (nonatomic,strong) NSString      *icon;

//  Name of the day of week
@property (nonatomic,strong) NSString      *dayOfWeek;

//  Description of the day's conditions
@property (nonatomic,strong) NSString      *conditionDescription;

//  Day's current temperature, if applicable
@property (nonatomic, assign) ZJLTemperatureType currentTemperature;

//  Day's high temperature
@property (nonatomic, assign) ZJLTemperatureType highTemperature;

//  Day's low temperature
@property (nonatomic, assign) ZJLTemperatureType lowTemperature;
@end

@interface ZJLWeatherData : NSObject<NSCoding>

@property (nonatomic, strong) CLPlacemark *place;
@property (nonatomic, strong) ZJLWeatherDay *currentDayWeather;
@property (nonatomic, strong) NSMutableArray *followingWeather;
@property (nonatomic, strong) NSDate *date;
@end
