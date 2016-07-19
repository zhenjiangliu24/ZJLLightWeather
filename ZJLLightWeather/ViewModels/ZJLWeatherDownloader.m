//
//  ZJLWeatherDownloader.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/15.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLWeatherDownloader.h"
#import "AFNetworking.h"
#import "ZJLWeatherData.h"
#import "NSString+Substring.h"
#import "Climacons.h"

NSString *const API = @"d5fda838420e3f7f";

@interface ZJLWeatherDownloader()
@property (nonatomic, copy) NSString *API_KEY;
@property (nonatomic) CLGeocoder    *geocoder;
@end

@implementation ZJLWeatherDownloader

- (instancetype)init
{
    //  Instances of SOLWundergroundDownloader should be impossible to make using init
    [NSException raise:@"ZJLingletonException" format:@"Downloader cannot be initialized using init"];
    return nil;
}

- (instancetype)initWithAPIKEY:(NSString *)API_KEY
{
    if (self = [super init]) {
        _API_KEY = API_KEY;
        _geocoder = [[CLGeocoder alloc]init];
    }
    return self;
}

- (void)dataForLocation:(CLLocation *)location placemark:(CLPlacemark *)placemark withTag:(NSInteger)tag complete:(ZJLDownloadCompleteHandler)complete
{
    if (!location) {
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [self urlForLocation:location];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            //NSData *data = (NSData *)responseObject;
            @try {
                NSDictionary *json = (NSDictionary *)responseObject;
                ZJLWeatherData *weather = [self dataFromJSON:json];
                if (placemark) {
                    weather.place = placemark;
                    complete(weather,error);
                }else{
                    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                        if (placemarks) {
                            weather.place = [placemarks lastObject];
                            complete(weather,error);
                        }else if(error){
                            complete(nil,error);
                        }
                    }];
                }
            } @catch (NSException *exception) {
                complete(nil, [NSError errorWithDomain:@"Downloader Internal State Error" code:-1 userInfo:nil]);
            } @finally {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        }
    }];
    [dataTask resume];
}

- (void)dataForPlaceMark:(CLPlacemark *)placeMark withTag:(NSInteger)tag complete:(ZJLDownloadCompleteHandler )complete
{
    [self dataForLocation:placeMark.location placemark:placeMark withTag:tag complete:complete];
}

- (void)dataForLocation:(CLLocation *)location withTag:(NSInteger)tag complete:(ZJLDownloadCompleteHandler)complete
{
    [self dataForLocation:location placemark:nil withTag:tag complete:complete];
}

- (NSDictionary *)serializedData:(NSData *)data
{
    NSError *JSONSerializationError;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&JSONSerializationError];
    if(JSONSerializationError) {
        [NSException raise:@"JSON Serialization Error" format:@"Failed to parse weather data"];
    }
    return JSON;
}

- (ZJLWeatherData *)dataFromJSON:(NSDictionary *)JSON
{
    NSArray *currentObservation                 = [JSON             objectForKey:@"current_observation"];
    NSArray *forecast                           = [JSON             objectForKey:@"forecast"];
    NSArray *simpleforecast                     = [forecast         valueForKey:@"simpleforecast"];
    NSArray *forecastday                        = [simpleforecast   valueForKey:@"forecastday"];
    NSArray *forecastday0                       = [forecastday      objectAtIndex:0];
    NSArray *forecastday1                       = [forecastday      objectAtIndex:1];
    NSArray *forecastday2                       = [forecastday      objectAtIndex:2];
    NSArray *forecastday3                       = [forecastday      objectAtIndex:3];
    
    ZJLWeatherData *data = [[ZJLWeatherData alloc]init];
    
    CGFloat currentHighTemperatureF             = [[[forecastday0 valueForKey:@"high"]  valueForKey:@"fahrenheit"]doubleValue];
    CGFloat currentHighTemperatureC             = [[[forecastday0 valueForKey:@"high"]  valueForKey:@"celsius"]doubleValue];
    CGFloat currentLowTemperatureF              = [[[forecastday0 valueForKey:@"low"]   valueForKey:@"fahrenheit"]doubleValue];
    CGFloat currentLowTemperatureC              = [[[forecastday0 valueForKey:@"low"]   valueForKey:@"celsius"]doubleValue];
    CGFloat currentTemperatureF                 = [[currentObservation valueForKey:@"temp_f"] doubleValue];
    CGFloat currentTemperatureC                 = [[currentObservation valueForKey:@"temp_c"] doubleValue];
    
    data.currentDayWeather.dayOfWeek              = [[forecastday0 valueForKey:@"date"] valueForKey:@"weekday"];
    data.currentDayWeather.conditionDescription   = [currentObservation valueForKey:@"weather"];
    data.currentDayWeather.icon                   = [self iconForCondition:data.currentDayWeather.conditionDescription];
    data.currentDayWeather.highTemperature        = ZJLTemperatureMake(currentHighTemperatureF,   currentHighTemperatureC);
    data.currentDayWeather.lowTemperature         = ZJLTemperatureMake(currentLowTemperatureF,    currentLowTemperatureC);
    data.currentDayWeather.currentTemperature     = ZJLTemperatureMake(currentTemperatureF,       currentTemperatureC);
    
    ZJLWeatherDay *forecastOne             = [[ZJLWeatherDay alloc]init];
    forecastOne.conditionDescription            = [forecastday1 valueForKey:@"conditions"];
    forecastOne.icon                            = [self iconForCondition:forecastOne.conditionDescription];
    forecastOne.dayOfWeek                       = [[forecastday1 valueForKey:@"date"] valueForKey:@"weekday"];
    [data.followingWeather addObject:forecastOne];
    
    ZJLWeatherDay *forecastTwo             = [[ZJLWeatherDay alloc]init];
    forecastTwo.conditionDescription            = [forecastday2 valueForKey:@"conditions"];
    forecastTwo.icon                            = [self iconForCondition:forecastTwo.conditionDescription];
    forecastTwo.dayOfWeek                       = [[forecastday2 valueForKey:@"date"] valueForKey:@"weekday"];
    [data.followingWeather addObject:forecastTwo];
    
    ZJLWeatherDay *forecastThree           = [[ZJLWeatherDay alloc]init];
    forecastThree.conditionDescription          = [forecastday3 valueForKey:@"conditions"];
    forecastThree.icon                          = [self iconForCondition:forecastThree.conditionDescription];
    forecastThree.dayOfWeek                     = [[forecastday3 valueForKey:@"date"] valueForKey:@"weekday"];
    [data.followingWeather addObject:forecastThree];
    
    data.date = [NSDate date];
    
    return data;
}


+ (ZJLWeatherDownloader *)sharedDownloader
{
    static ZJLWeatherDownloader *share = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        share = [[ZJLWeatherDownloader alloc] initWithAPIKEY:API];
    });
    return share;
}

- (NSString *)iconForCondition:(NSString *)condition
{
    NSString *iconName = [NSString stringWithFormat:@"%c", ClimaconSun];
    NSString *lowercaseCondition = [condition lowercaseString];
    
    if([lowercaseCondition contains:@"clear"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconSun];
    } else if([lowercaseCondition contains:@"cloud"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconCloud];
    } else if([lowercaseCondition contains:@"drizzle"]  ||
              [lowercaseCondition contains:@"rain"]     ||
              [lowercaseCondition contains:@"thunderstorm"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconRain];
    } else if([lowercaseCondition contains:@"snow"]     ||
              [lowercaseCondition contains:@"hail"]     ||
              [lowercaseCondition contains:@"ice"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconSnow];
    } else if([lowercaseCondition contains:@"fog"]      ||
              [lowercaseCondition contains:@"overcast"] ||
              [lowercaseCondition contains:@"smoke"]    ||
              [lowercaseCondition contains:@"dust"]     ||
              [lowercaseCondition contains:@"ash"]      ||
              [lowercaseCondition contains:@"mist"]     ||
              [lowercaseCondition contains:@"haze"]     ||
              [lowercaseCondition contains:@"spray"]    ||
              [lowercaseCondition contains:@"squall"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconHaze];
    }
    return iconName;
}

- (NSURL *)urlForLocation:(CLLocation *)location
{
    static NSString *baseURL =  @"http://api.wunderground.com/api/";
    static NSString *parameters = @"/forecast/conditions/q/";
    CLLocationCoordinate2D coordinates = location.coordinate;
    NSString *requestURL = [NSString stringWithFormat:@"%@%@%@%f,%f.json", baseURL, self.API_KEY, parameters,coordinates.latitude, coordinates.longitude];
    NSURL *url = [NSURL URLWithString:requestURL];
    return url;
}

- (NSURLRequest *)urlRequestForLocation:(CLLocation *)location
{
    NSURL *url = [self urlForLocation:location];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}
@end
