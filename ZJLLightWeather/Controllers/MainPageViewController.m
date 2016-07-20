//
//  MainPageViewController.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
#import "MainPageViewController.h"
#import "ZJLWeatherScrollView.h"
#import "ZJLWeatherData.h"
#import "ZJLDataManager.h"
#import "ZJLWeatherDownloader.h"
#import "UIImage+ImageEffects.h"
#import "Climacons.h"

#define LIGHT_FONT      @"HelveticaNeue-Light"
#define ULTRALIGHT_FONT @"HelveticaNeue-UltraLight"
#define kLOCAL_WEATHER_VIEW_TAG 0
#define kUPDATE_FREQ 60

@interface MainPageViewController ()
@property (nonatomic, strong) ZJLWeatherScrollView *mainScrollView;
@property (nonatomic, readwrite, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableDictionary *weatherData;
@property (nonatomic, strong) NSMutableArray *weatherList;
@property (nonatomic, assign) BOOL isScrolling;

//UI
@property (nonatomic, strong) UIView *darkBackgroundView;
@property (strong, nonatomic)  UIImageView *blurredOverlayView;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *addLocationButton;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) AddLocationViewController *addVC;
@property (nonatomic, strong) SettingViewController *settingVC;
@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZJLWeatherView *view = [[ZJLWeatherView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        NSDictionary *savedData = [ZJLDataManager weatherData];
        if (savedData) {
            self.weatherData = [NSMutableDictionary dictionaryWithDictionary:savedData];
        }else{
            self.weatherData = [NSMutableDictionary new];
        }
        NSArray *lists = [ZJLDataManager weatherTag];
        if(lists){
            self.weatherList = [NSMutableArray arrayWithArray:lists];
        }else{
            self.weatherList = [NSMutableArray new];
        }
        self.dateFormatter = [[NSDateFormatter alloc]init];
        [self.dateFormatter setDateFormat:@"EEE MMM d, h:mm a"];
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.distanceFilter = 3000;
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        
        [self initSubViews];
        [self initSettingButton];
        [self initAddButton];
//        [self initLocalWeatherView];
//        [self initUserSavedWeatherView];
        [self.view bringSubviewToFront:self.blurredOverlayView];
    }
    return self;
}

- (void)initSubViews
{
    _darkBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _darkBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:_darkBackgroundView];
    
    _iconLabel = [[UILabel alloc] init];
    _iconLabel.backgroundColor = [UIColor clearColor];
    _iconLabel.font = [UIFont fontWithName:LIGHT_FONT size:self.view.frame.size.height*0.3125];
    _iconLabel.textColor = [UIColor whiteColor];
    _iconLabel.textAlignment = NSTextAlignmentCenter;
    _iconLabel.text = [NSString stringWithFormat:@"%c", ClimaconSun];
    [self.view addSubview:_iconLabel];
    [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.3125));
        make.center.mas_equalTo(self.view).centerOffset(CGPointMake(0, -self.view.frame.size.height*0.25));
    }];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:self.view.frame.size.height*0.18];
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.textColor = [UIColor whiteColor];
    _descriptionLabel.adjustsFontSizeToFitWidth = YES;
    _descriptionLabel.numberOfLines = 1;
    [self.view addSubview:_descriptionLabel];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.75*self.view.frame.size.width);
        make.height.mas_equalTo(self.view.frame.size.height*0.18);
        make.center.mas_equalTo(self.view);
    }];
    
    _mainScrollView = [[ZJLWeatherScrollView alloc] initWithFrame:self.view.bounds];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    
    //  Initialize the blurred overlay view
    self.blurredOverlayView = [[UIImageView alloc]initWithImage:[[UIImage alloc]init]];
    self.blurredOverlayView.alpha = 0.0;
    [self.blurredOverlayView setFrame:self.view.bounds];
    [self.view addSubview:self.blurredOverlayView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-32, CGRectGetWidth(self.view.frame), 32)];
    [_pageControl setHidesForSinglePage:YES];
    [self.view addSubview:_pageControl];
}

- (void)initSettingButton
{
    self.settingButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [self.settingButton setTintColor:[UIColor whiteColor]];
    [self.settingButton setFrame:CGRectMake(4, CGRectGetHeight(self.view.bounds) - 48, 44, 44)];
    [self.settingButton setShowsTouchWhenHighlighted:YES];
    [self.settingButton addTarget:self action:@selector(settingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingButton];
}

- (void)initAddButton
{
    self.addLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *plusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [plusLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:40]];
    [plusLabel setTextAlignment:NSTextAlignmentCenter];
    [plusLabel setTextColor:[UIColor whiteColor]];
    [plusLabel setText:@"+"];
    [self.addLocationButton addSubview:plusLabel];
    [self.addLocationButton setFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 44, CGRectGetHeight(self.view.bounds) - 54, 44, 44)];
    [self.addLocationButton setShowsTouchWhenHighlighted:YES];
    [self.addLocationButton addTarget:self action:@selector(addLocationButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addLocationButton];
}

- (void)initLocalWeatherView
{
    ZJLWeatherView *localView = [[ZJLWeatherView alloc] initWithFrame:self.view.bounds];
    localView.isLocal = YES;
    localView.delegate = self;
    localView.tag = kLOCAL_WEATHER_VIEW_TAG;
    localView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient5"]];
    [self.mainScrollView insertSubview:localView atIndex:0];
    _pageControl.numberOfPages += 1;
    ZJLWeatherData *data = [self.weatherData objectForKey:[NSNumber numberWithInt:kLOCAL_WEATHER_VIEW_TAG]];
    if (data) {
        [self updateWeatherView:localView withData:data];
    }else{
        
    }
}

- (void)initUserSavedWeatherView
{
    for (NSNumber *number in self.weatherList) {
        ZJLWeatherData *data = [self.weatherData objectForKey:number];
        if (data) {
            ZJLWeatherView *view = [[ZJLWeatherView alloc] initWithFrame:self.view.bounds];
            view.delegate = self;
            view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient5"]];
            view.isLocal = NO;
            view.tag = number.integerValue;
            [self.mainScrollView addSubview:view show:NO];
            _pageControl.numberOfPages += 1;
            [self updateWeatherView:view withData:data];
        }
    }
}

- (void)updateWeatherView:(ZJLWeatherView *)weatherView withData:(ZJLWeatherData *)data
{
    if (!data) {
        return;
    }
    weatherView.hasData = YES;
    weatherView.updateTimeLabel.text = [NSString stringWithFormat:@"Updated %@", [self.dateFormatter stringFromDate:data.date]];
    weatherView.iconLabel.text = data.currentDayWeather.icon;
    weatherView.descriptionLabel.text = data.currentDayWeather.conditionDescription;
    
    NSString *city = data.place.locality;
    NSString *country = data.place.country;
    weatherView.locationLabel.text = [NSString stringWithFormat:@"%@ %@",city,country];
    ZJLTemperatureType current = data.currentDayWeather.currentTemperature;
    ZJLTemperatureType highTemp = data.currentDayWeather.highTemperature;
    ZJLTemperatureType lowTemp = data.currentDayWeather.lowTemperature;
    if ([ZJLDataManager tempScale] == ZJLFa) {
        weatherView.currentTempLabel.text = [NSString stringWithFormat:@"%.0f°",current.fahrenheit];
        weatherView.highTempLabel.text = [NSString stringWithFormat:@"H %.0f",highTemp.fahrenheit];
        weatherView.lowTempLabel.text = [NSString stringWithFormat:@"L %.0f",lowTemp.fahrenheit];
    }else{
        weatherView.currentTempLabel.text = [NSString stringWithFormat:@"%.0f℃",current.celsius];
        weatherView.highTempLabel.text = [NSString stringWithFormat:@"H %.0f",highTemp.celsius];
        weatherView.lowTempLabel.text = [NSString stringWithFormat:@"H %.0f",lowTemp.celsius];
    }
    
    ZJLWeatherDay *day1 = (ZJLWeatherDay *)[data.followingWeather objectAtIndex:0];
    ZJLWeatherDay *day2 = (ZJLWeatherDay *)[data.followingWeather objectAtIndex:1];
    ZJLWeatherDay *day3 = (ZJLWeatherDay *)[data.followingWeather objectAtIndex:2];
    
    weatherView.followingOneLabel.text = [day1.dayOfWeek substringWithRange:NSMakeRange(0, 3)];
    weatherView.followingTwoLabel.text = [day2.dayOfWeek substringWithRange:NSMakeRange(0, 3)];
    weatherView.followingThreeLabel.text = [day3.dayOfWeek substringWithRange:NSMakeRange(0, 3)];
    
    weatherView.followingOneIcon.text = day1.icon;
    weatherView.followingTwoIcon.text = day2.icon;
    weatherView.followingThreeIcon.text = day3.icon;
    
    //  Set the weather view's background color
//    CGFloat fahrenheit = MIN(MAX(0, current.fahrenheit), 99);
//    NSString *gradientImageName = [NSString stringWithFormat:@"gradient%d.png", (int)floor(fahrenheit / 10.0)];
//    weatherView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:gradientImageName]];
    [weatherView setBackgroundColorWithWeatherType:data.currentDayWeather.conditionDescription];
}

- (void)addLocationButtonPressed
{
    if (self.mainScrollView.subviews.count>0) {
        [self showBlurredOverlayView:YES];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.iconLabel.alpha = 0.0;
            self.descriptionLabel.alpha = 0.0;
        }];
    }
    if (!self.addVC) {
        self.addVC = [[AddLocationViewController alloc] init];
        self.addVC.delegate = self;
    }
    [self presentViewController:self.addVC animated:YES completion:nil];
}

- (void)settingsButtonPressed
{
    NSMutableArray *locations = [NSMutableArray new];
    for (ZJLWeatherView *view in self.mainScrollView.subviews) {
        if (view.tag != kLOCAL_WEATHER_VIEW_TAG) {
            NSArray *data = @[view.locationLabel.text,[NSNumber numberWithInt:view.tag]];
            [locations addObject:data];
        }
    }
    self.settingVC = [[SettingViewController alloc] init];
    self.settingVC.delegate = self;
    self.settingVC.locations = locations;
    [self presentViewController:self.settingVC animated:YES completion:nil];
    
}

#pragma mark - update view
- (void)updateWeatherData
{
    for (ZJLWeatherView *weatherView in self.mainScrollView.subviews) {
        if (weatherView.isLocal == NO) {
            [self downloadDataFor:weatherView];
        }
    }
}

- (void)downloadDataFor:(ZJLWeatherView *)weatherView
{
    ZJLWeatherData *data = [self.weatherData objectForKey:[NSNumber numberWithInt:weatherView.tag]];
    if ([[NSDate date] timeIntervalSinceDate:data.date]>=kUPDATE_FREQ || !weatherView.hasData) {
        if(weatherView.hasData) {
            weatherView.activityIndicator.center = CGPointMake(weatherView.center.x, 1.8 * weatherView.center.y);
        }
        [weatherView.activityIndicator startAnimating];
        [[ZJLWeatherDownloader sharedDownloader] dataForPlaceMark:data.place withTag:weatherView.tag complete:^(ZJLWeatherData *data, NSError *error) {
            if (data) {
                [self downloadDidFinishWithData:data withTag:weatherView.tag];
            }else{
                [self downloadDidFailForWeatherViewWithTag:weatherView.tag];
            }
        }];
    }
}

- (void)downloadDidFinishWithData:(ZJLWeatherData *)data withTag:(NSInteger)tag
{
    for (ZJLWeatherView *weatherView in self.mainScrollView.subviews) {
        if (weatherView.tag == tag) {
            [self.weatherData setObject:data forKey:[NSNumber numberWithInt:tag]];
            [self updateWeatherView:weatherView withData:data];
            //
            weatherView.hasData = YES;
            [weatherView.activityIndicator stopAnimating];
        }
    }
    [ZJLDataManager setWeatherData:self.weatherData];
}

- (void)downloadDidFailForWeatherViewWithTag:(NSInteger)tag
{
    for (ZJLWeatherView *weatherView in self.mainScrollView.subviews) {
        if (weatherView.tag == tag) {
            if (!weatherView.hasData) {
                weatherView.iconLabel.text = @"☹";
                weatherView.descriptionLabel.text = @"Update failed";
                weatherView.locationLabel.text = @"Please check the Network";
            }
        }
        [weatherView.activityIndicator stopAnimating];
    }
}

#pragma mark - show blur view

- (void)showBlurredOverlayView:(BOOL)show
{
    [UIView animateWithDuration:0.25 animations: ^ {
        self.blurredOverlayView.alpha = (show)? 1.0 : 0.0;;
    }];
}

- (void)setBlurredOverlayImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        
        //  Take a screen shot of this controller's view
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [self.view.layer renderInContext:context];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //  Blur the screen shot
        UIImage *blurred = [image applyBlurWithRadius:20
                                            tintColor:[UIColor colorWithWhite:0.15 alpha:0.5]
                                saturationDeltaFactor:1.5
                                            maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            //  Set the blurred overlay view's image with the blurred screenshot
            self.blurredOverlayView.image = blurred;
        });
    });
}

#pragma mark - CLlocation manager

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self initLocalWeatherView];
        [self initUserSavedWeatherView];
        [self showBlurredOverlayView:NO];
        [self setBlurredOverlayImage];
        [self updateWeatherData];
    }else if (status != kCLAuthorizationStatusNotDetermined){
        [self initLocalWeatherView];
        [self initUserSavedWeatherView];
        [self setBlurredOverlayImage];
        [self showBlurredOverlayView:NO];
        [self updateWeatherData];
    }else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
        if (self.mainScrollView.subviews.count ==0) {
            if (!self.addVC) {
                self.addVC = [[AddLocationViewController alloc] init];
                self.addVC.delegate = self;
            }
            [self presentViewController:self.addVC animated:YES completion:nil];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (ZJLWeatherView *weatherView in self.mainScrollView.subviews) {
        if (weatherView.isLocal == YES) {
            ZJLWeatherData *data = [self.weatherData objectForKey:[NSNumber numberWithInt:weatherView.tag]];
            if ([[NSDate date] timeIntervalSinceDate:data.date]>=kUPDATE_FREQ || !weatherView.hasData) {
                if(weatherView.hasData) {
                    weatherView.activityIndicator.center = CGPointMake(weatherView.center.x, 1.8 * weatherView.center.y);
                }
                [weatherView.activityIndicator startAnimating];
                [[ZJLWeatherDownloader sharedDownloader] dataForLocation:[locations lastObject] withTag:weatherView.tag complete:^(ZJLWeatherData *data, NSError *error) {
                    if (data) {
                        [self downloadDidFinishWithData:data withTag:weatherView.tag];
                    }else{
                        [self downloadDidFailForWeatherViewWithTag:weatherView.tag];
                    }
                }];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    for (ZJLWeatherView *weatherView in self.mainScrollView.subviews) {
        if (weatherView.isLocal == YES && !weatherView.hasData) {
            weatherView.iconLabel.text = @"☹";
            weatherView.descriptionLabel.text = @"Update failed";
            weatherView.locationLabel.text = @"Please check the Network";
        }
    }
}

#pragma mark - add location view controller delegate
- (void)didAddLocationWithPlaceMark:(CLPlacemark *)placemark
{
    ZJLWeatherData *data = [self.weatherData objectForKey:[NSNumber numberWithInteger:placemark.locality.hash]];
    if (!data) {
        ZJLWeatherView *newView = [[ZJLWeatherView alloc] initWithFrame:self.view.bounds];
        newView.delegate = self;
        newView.tag = placemark.locality.hash;
        newView.isLocal = NO;
        newView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient4"]];
        [self.mainScrollView addSubview:newView show:NO];
        _pageControl.numberOfPages += 1;
        [newView.activityIndicator startAnimating];
        [self.weatherList addObject:[NSNumber numberWithInt:placemark.locality.hash]];
        [ZJLDataManager setWeatherTag:self.weatherList];
        [[ZJLWeatherDownloader sharedDownloader] dataForPlaceMark:placemark withTag:newView.tag complete:^(ZJLWeatherData *data, NSError *error) {
            if (data) {
                [self downloadDidFinishWithData:data withTag:newView.tag];
            }else{
                [self downloadDidFailForWeatherViewWithTag:newView.tag];
            }
            [self setBlurredOverlayImage];
        }];
    }
}

- (void)dismissAddLocationVC
{
    [self showBlurredOverlayView:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.iconLabel.alpha = 1.0;
        self.descriptionLabel.alpha = 1.0;
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setting vc delegate
- (void)didMoveViewFromSource:(NSInteger)sourceIndex to:(NSInteger)destinationIndex
{
    NSNumber *tag = [self.weatherList objectAtIndex:sourceIndex];
    [self.weatherList removeObjectAtIndex:sourceIndex];
    [self.weatherList insertObject:tag atIndex:destinationIndex];
    [ZJLDataManager setWeatherTag:self.weatherList];
    if ([self.weatherData objectForKey:[NSNumber numberWithInteger:kLOCAL_WEATHER_VIEW_TAG]]) {
        destinationIndex += 1;
    }
    for (ZJLWeatherView *view in self.mainScrollView.subviews) {
        if (view.tag == tag.integerValue) {
            [self.mainScrollView removeSubView:view];
            [self.mainScrollView insertSubview:view atIndex:destinationIndex];
            break;
        }
    }
    
}

- (void)didRemoveViewWithTag:(NSInteger)tag
{
    for (ZJLWeatherView *view in self.mainScrollView.subviews) {
        if (view.tag == tag) {
            [self.mainScrollView removeSubView:view];
            self.pageControl.numberOfPages -= 1;
        }
    }
    [self.weatherList removeObject:[NSNumber numberWithInt:tag]];
    [self.weatherData removeObjectForKey:[NSNumber numberWithInt:tag]];
    [ZJLDataManager setWeatherTag:self.weatherList];
    [ZJLDataManager setWeatherData:self.weatherData];
}

- (void)dismissSettingVC
{
    [self showBlurredOverlayView:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.iconLabel.alpha = 1.0;
        self.descriptionLabel.alpha = 1.0;
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didChangeTempTypeTo:(ZJLTempScale)tempScale
{
    for (ZJLWeatherView *view in self.mainScrollView.subviews) {
        ZJLWeatherData *data = [self.weatherData objectForKey:[NSNumber numberWithInt:view.tag]];
        [self updateWeatherView:view withData:data];
    }
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScrolling = NO;
    [self setBlurredOverlayImage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.isScrolling = YES;
    
    //  Update the current page for the page control
    float fractionalPage = self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width;
    _pageControl.currentPage = lround(fractionalPage);
}

- (BOOL)shouldPanWeatherView:(ZJLWeatherView *)weatherView
{
    return !self.isScrolling;
}

- (void)didBeginPanWeatherView:(ZJLWeatherView *)weatherView
{
    self.mainScrollView.scrollEnabled = NO;
}

- (void)didFinishPanWeatherView:(ZJLWeatherView *)weatherView
{
    self.mainScrollView.scrollEnabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
