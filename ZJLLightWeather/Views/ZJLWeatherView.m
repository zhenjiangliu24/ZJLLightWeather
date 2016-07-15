//
//  ZJLWeatherView.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLWeatherView.h"

#define LIGHT_FONT      @"HelveticaNeue-Light"
#define ULTRALIGHT_FONT @"HelveticaNeue-UltraLight"

@interface ZJLWeatherView()
@property (nonatomic, readwrite, strong) UILabel *dateLabel;
@property (nonatomic, readwrite, strong) UILabel *iconLabel;
@property (nonatomic, readwrite, strong) UILabel *descriptionLabel;
@property (nonatomic, readwrite, strong) UILabel *locationLabel;
@property (nonatomic, readwrite, strong) UILabel *currentTempLabel;
@property (nonatomic, readwrite, strong) UILabel *highTempLabel;
@property (nonatomic, readwrite, strong) UILabel *lowTempLabel;
@property (nonatomic, readwrite, strong) UILabel *followingOneLabel;
@property (nonatomic, readwrite, strong) UILabel *followingOneIcon;
@property (nonatomic, readwrite, strong) UILabel *followingTwoLabel;
@property (nonatomic, readwrite, strong) UILabel *followingTwoIcon;
@property (nonatomic, readwrite, strong) UILabel *followingThreeLabel;
@property (nonatomic, readwrite, strong) UILabel *followingThreeIcon;
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *loadingView;

@property (nonatomic, strong) UIView *mainContainer;
@property (nonatomic, strong) UIView *subContainer;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;


@end

@implementation ZJLWeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _mainContainer = [[UIView alloc] initWithFrame:self.bounds];
        _mainContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_mainContainer];
        
        _subContainer = [[UIView alloc] init];
        _subContainer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        [_mainContainer addSubview:_subContainer];
        
        
        _iconLabel = [[UILabel alloc] init];
        _iconLabel.backgroundColor = [UIColor clearColor];
        _iconLabel.font = [UIFont fontWithName:LIGHT_FONT size:self.frame.size.height*0.3125];
        _iconLabel.textColor = [UIColor whiteColor];
        _iconLabel.textAlignment = NSTextAlignmentCenter;
        [_mainContainer addSubview:_iconLabel];
        
        
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:self.frame.size.height*0.18];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.adjustsFontSizeToFitWidth = YES;
        _descriptionLabel.numberOfLines = 1;
        [_mainContainer addSubview:_descriptionLabel];
        
        
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.textColor = [UIColor whiteColor];
        _locationLabel.adjustsFontSizeToFitWidth = YES;
        _locationLabel.numberOfLines = 1;
        [_mainContainer addSubview:_locationLabel];
        
    }
    return self;
}

- (void)updateConstraints
{
    [_subContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.height/6));
        make.center.mas_equalTo(_mainContainer).centerOffset(CGPointMake(0, self.frame.size.height*0.3));
    }];
    
    [_iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.height*0.3125));
        make.center.mas_equalTo(_mainContainer).centerOffset(CGPointMake(0, -self.frame.size.height*0.25));
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.75*self.frame.size.width);
        make.height.mas_equalTo(self.frame.size.height*0.18);
        make.center.mas_equalTo(_mainContainer);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_mainContainer);
        make.top.equalTo(_descriptionLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(_subContainer.mas_top).with.offset(-10);
        make.centerX.mas_equalTo(_mainContainer.mas_centerX);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
