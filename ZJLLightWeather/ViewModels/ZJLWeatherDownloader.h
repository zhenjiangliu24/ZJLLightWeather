//
//  ZJLWeatherDownloader.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJLWeatherData;

typedef void (^ZJLDownloadCompleteHandler)(ZJLWeatherData *data, NSError *error);

@interface ZJLWeatherDownloader : NSObject
+ (ZJLWeatherDownloader *)sharedDownloader;
- (void)dataForLocation:(CLLocation *)location withTag:(NSInteger)tag complete:(ZJLDownloadCompleteHandler)complete;
- (void)dataForPlaceMark:(CLPlacemark *)placeMark withTag:(NSInteger)tag complete:(ZJLDownloadCompleteHandler)complete;
@end
