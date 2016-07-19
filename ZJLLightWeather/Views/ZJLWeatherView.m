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
@property (nonatomic, readwrite, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) UIView *mainContainer;
@property (nonatomic, strong) UIView *subContainer;


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
        
        _currentTempLabel = [[UILabel alloc] init];
        _currentTempLabel.backgroundColor = [UIColor clearColor];
        _currentTempLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:self.frame.size.height/12];
        _currentTempLabel.textColor = [UIColor whiteColor];
        _currentTempLabel.textAlignment = NSTextAlignmentCenter;
        [_subContainer addSubview:_currentTempLabel];
        
        _highTempLabel = [[UILabel alloc] init];
        _highTempLabel.backgroundColor = [UIColor clearColor];
        _highTempLabel.textColor = [UIColor whiteColor];
        _highTempLabel.textAlignment = NSTextAlignmentCenter;
        _highTempLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:20];
        [_subContainer addSubview:_highTempLabel];
        
        _lowTempLabel = [[UILabel alloc] init];
        _lowTempLabel.backgroundColor = [UIColor clearColor];
        _lowTempLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:20];
        _lowTempLabel.textColor = [UIColor whiteColor];
        _lowTempLabel.textAlignment = NSTextAlignmentCenter;
        [_subContainer addSubview:_lowTempLabel];
        
        _followingOneLabel = [[UILabel alloc] init];
        _followingOneLabel.backgroundColor = [UIColor clearColor];
        _followingOneLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        _followingOneLabel.textColor = [UIColor whiteColor];
        _followingOneLabel.textAlignment = NSTextAlignmentCenter;
        [_subContainer addSubview:_followingOneLabel];
        
        _followingTwoLabel = [[UILabel alloc] init];
        _followingTwoLabel.backgroundColor = [UIColor clearColor];
        _followingTwoLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        _followingTwoLabel.textColor = [UIColor whiteColor];
        _followingTwoLabel.textAlignment = NSTextAlignmentCenter;
        [_subContainer addSubview:_followingTwoLabel];
        
        _followingThreeLabel = [[UILabel alloc] init];
        _followingThreeLabel.backgroundColor = [UIColor clearColor];
        _followingThreeLabel.textColor = [UIColor whiteColor];
        _followingThreeLabel.textAlignment = NSTextAlignmentCenter;
        _followingThreeLabel.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        [_subContainer addSubview:_followingThreeLabel];
        
        _followingOneIcon = [[UILabel alloc] init];
        _followingOneIcon.backgroundColor = [UIColor clearColor];
        _followingOneIcon.textColor = [UIColor whiteColor];
        _followingOneIcon.textAlignment = NSTextAlignmentCenter;
        _followingOneIcon.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        [_subContainer addSubview:_followingOneIcon];
        
        _followingTwoIcon = [[UILabel alloc] init];
        _followingTwoIcon.backgroundColor = [UIColor clearColor];
        _followingTwoIcon.textColor = [UIColor whiteColor];
        _followingTwoIcon.textAlignment = NSTextAlignmentCenter;
        _followingTwoIcon.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        [_subContainer addSubview:_followingTwoIcon];
        
        _followingThreeIcon = [[UILabel alloc] init];
        _followingThreeIcon.backgroundColor = [UIColor clearColor];
        _followingThreeIcon.textColor = [UIColor whiteColor];
        _followingThreeIcon.textAlignment = NSTextAlignmentCenter;
        _followingThreeIcon.font = [UIFont fontWithName:ULTRALIGHT_FONT size:18];
        [_subContainer addSubview:_followingThreeIcon];
        
        [self initializeMotionEffects];
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _pan.minimumNumberOfTouches = 1;
        _pan.delegate = self;
        [_mainContainer addGestureRecognizer:_pan];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = self.center;
        [_mainContainer addSubview:self.activityIndicator];
    }
    return self;
}

#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        //  We only want to register vertial pans
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocity = [panGestureRecognizer velocityInView:_mainContainer];
        return fabsf(velocity.y) > fabsf(velocity.x);
    }
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark pan action

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    static CGFloat initialCenterY = 0.0;
    CGPoint translatedPoint = [pan translationInView:self.mainContainer];
    if (pan.state == UIGestureRecognizerStateBegan) {
        initialCenterY = _mainContainer.center.y;
        [self.delegate didBeginPanWeatherView:self];
    }else if (pan.state == UIGestureRecognizerStateEnded){
        [self.delegate didFinishPanWeatherView:self];
        [UIView animateWithDuration:0.3 animations:^{
            _mainContainer.center = CGPointMake(_mainContainer.center.x, initialCenterY);
        }];
    }else if (translatedPoint.y>0 && translatedPoint.y<=50){
        _mainContainer.center = CGPointMake(_mainContainer.center.x, self.center.y + translatedPoint.y);
    }
}

#pragma mark Motion Effects

- (void)initializeMotionEffects
{
    UIInterpolatingMotionEffect *verticalInterpolation = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalInterpolation.minimumRelativeValue = @(-15);
    verticalInterpolation.maximumRelativeValue = @(15);
    
    UIInterpolatingMotionEffect *horizontalInterpolation = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalInterpolation.minimumRelativeValue = @(-15);
    horizontalInterpolation.maximumRelativeValue = @(15);
    
    [self.iconLabel addMotionEffect:verticalInterpolation];
    [self.iconLabel addMotionEffect:horizontalInterpolation];
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
    
    [_currentTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.4*self.frame.size.width);
        make.left.equalTo(_subContainer.mas_left).with.offset(10);
        make.top.equalTo(_subContainer.mas_top).with.offset(5);
        make.height.mas_equalTo(self.frame.size.height/12);
    }];
    
    [_highTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentTempLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_subContainer.mas_left).with.offset(10);
        make.bottom.equalTo(_subContainer.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(self.frame.size.width*0.2);
    }];
    
    [_lowTempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentTempLabel.mas_bottom).with.offset(5);
        make.left.equalTo(_highTempLabel.mas_right).with.offset(0);
        make.bottom.equalTo(_subContainer.mas_bottom).with.offset(-5);
        make.width.mas_equalTo(self.frame.size.width*0.2);
    }];
    
    [_followingOneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.frame.size.width*0.2);
        make.top.equalTo(_subContainer.mas_top).with.offset(0);
        make.left.equalTo(_currentTempLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(self.frame.size.height/12);
    }];
    
    [_followingTwoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.frame.size.width*0.2);
        make.top.equalTo(_subContainer.mas_top).with.offset(0);
        make.left.equalTo(_followingOneLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(self.frame.size.height/12);
    }];
    
    [_followingThreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.frame.size.width*0.2);
        make.top.equalTo(_subContainer.mas_top).with.offset(0);
        make.left.equalTo(_followingTwoLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(self.frame.size.height/12);
    }];
    
    [_followingOneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.frame.size.width*0.2);
        make.top.equalTo(_followingOneLabel.mas_bottom).with.offset(0);
        make.left.equalTo(_currentTempLabel.mas_right).with.offset(0);
        make.height.mas_equalTo(self.frame.size.height/12);
    }];
    
    [_followingTwoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.frame.size.width*0.2);
        make.top.equalTo(_followingTwoLabel.mas_bottom).with.offset(0);
        make.left.equalTo(_followingOneIcon.mas_right).with.offset(0);
        make.height.mas_equalTo(self.frame.size.height/12);
    }];
    
    [_followingThreeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.frame.size.width*0.2);
        make.top.equalTo(_followingThreeLabel.mas_bottom).with.offset(0);
        make.left.equalTo(_followingTwoIcon.mas_right).with.offset(0);
        make.height.mas_equalTo(self.frame.size.height/12);
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
