//
//  ZJLDataManager.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLDataManager.h"

@implementation ZJLDataManager

+ (ZJLTempScale)tempScale
{
    return (ZJLTempScale)[[NSUserDefaults standardUserDefaults]integerForKey:@"temp_scale"];
}

+ (void)setTempScale:(ZJLTempScale)tempScale
{
    [[NSUserDefaults standardUserDefaults]setInteger:tempScale forKey:@"temp_scale"];
}

+ (NSDictionary *)weatherData
{
    NSData *encodedWeatherData = [[NSUserDefaults standardUserDefaults]objectForKey:@"weather_data"];
    if(encodedWeatherData) {
        return (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedWeatherData];
    }
    return nil;
}

+ (void)setWeatherData:(NSDictionary *)weatherData
{
    NSData *encodedWeatherData = [NSKeyedArchiver archivedDataWithRootObject:weatherData];
    [[NSUserDefaults standardUserDefaults]setObject:encodedWeatherData forKey:@"weather_data"];
}

+ (NSArray *)weatherTag
{
    NSData *encodedWeatherTags = [[NSUserDefaults standardUserDefaults]objectForKey:@"weather_tags"];
    if(encodedWeatherTags) {
        return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedWeatherTags];
    }
    return nil;
}

+ (void)setWeatherTag:(NSArray *)weatherTag
{
    NSData *encodedWeatherTags = [NSKeyedArchiver archivedDataWithRootObject:weatherTag];
    [[NSUserDefaults standardUserDefaults]setObject:encodedWeatherTags forKey:@"weather_tags"];
}
@end
