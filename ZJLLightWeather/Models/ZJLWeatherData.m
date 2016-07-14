//
//  ZJLWeatherData.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLWeatherData.h"

NSString *const UD_ICON = @"icon";
NSString *const UD_DAY_OF_WEEK = @"day_of_week";
NSString *const UD_CONDITION_DES = @"condition_discription";
NSString *const UD_CURRENT_TEMP_C = @"current_temperature_c";
NSString *const UD_CURRENT_TEMP_F = @"current_temperature_f";
NSString *const UD_HIGH_TEMP_C = @"high_temperature_c";
NSString *const UD_HIGH_TEMP_F = @"high_temperature_f";
NSString *const UD_LOW_TEMP_C = @"low_temperature_c";
NSString *const UD_LOW_TEMP_F = @"low_temperature_f";

@implementation ZJLWeatherDay
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _icon = [aDecoder decodeObjectForKey:UD_ICON];
        _dayOfWeek = [aDecoder decodeObjectForKey:UD_DAY_OF_WEEK];
        _conditionDescription = [aDecoder decodeObjectForKey:UD_CONDITION_DES];
        
        _currentTemperature = ZJLTemperatureMake([aDecoder decodeFloatForKey:UD_CURRENT_TEMP_F], [aDecoder decodeFloatForKey:UD_CURRENT_TEMP_C]);
        _highTemperature = ZJLTemperatureMake([aDecoder decodeFloatForKey:UD_HIGH_TEMP_F], [aDecoder decodeFloatForKey:UD_HIGH_TEMP_C]);
        _lowTemperature = ZJLTemperatureMake([aDecoder decodeFloatForKey:UD_LOW_TEMP_F], [aDecoder decodeFloatForKey:UD_LOW_TEMP_C]);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_icon forKey:UD_ICON];
    [aCoder encodeObject:_dayOfWeek forKey:UD_DAY_OF_WEEK];
    [aCoder encodeObject:_conditionDescription forKey:UD_CONDITION_DES];
    [aCoder encodeFloat:_currentTemperature.fahrenheit forKey:UD_CURRENT_TEMP_F];
    [aCoder encodeFloat:_currentTemperature.celsius forKey:UD_CURRENT_TEMP_C];
    [aCoder encodeFloat:_highTemperature.fahrenheit forKey:UD_HIGH_TEMP_F];
    [aCoder encodeFloat:_highTemperature.celsius forKey:UD_HIGH_TEMP_C];
    [aCoder encodeFloat:_lowTemperature.fahrenheit forKey:UD_LOW_TEMP_F];
    [aCoder encodeFloat:_lowTemperature.celsius forKey:UD_LOW_TEMP_C];
}

@end

NSString *const UD_PLACE = @"place";
NSString *const UD_CURRENT_DAY = @"current_day";
NSString *const UD_FOLLOWING = @"following";
NSString *const UD_DATE = @"date";

static const NSInteger numberOfFollowing = 3;

@implementation ZJLWeatherData

- (instancetype)init
{
    if (self = [super init]) {
        _currentDayWeather = [[ZJLWeatherDay alloc] init];
        _followingWeather = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _place = [aDecoder decodeObjectForKey:UD_PLACE];
        _currentDayWeather = [aDecoder decodeObjectForKey:UD_CURRENT_DAY];
        _date = [aDecoder decodeObjectForKey:UD_DATE];
        for (int i = 0; i<numberOfFollowing; i++) {
            NSString *key = [NSString stringWithFormat:@"%@%d",UD_FOLLOWING,i];
            ZJLWeatherDay *day = [aDecoder decodeObjectForKey:key];
            if (day) {
                [_followingWeather addObject:day];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_place forKey:UD_PLACE];
    [aCoder encodeObject:_currentDayWeather forKey:UD_CURRENT_DAY];
    [aCoder encodeObject:_date forKey:UD_DATE];
    for (int i = 0; i<_followingWeather.count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@%d",UD_FOLLOWING,i];
        [aCoder encodeObject:[_followingWeather objectAtIndex:i] forKey:key];
    }
}

@end
