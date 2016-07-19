//
//  ZJLWeatherScrollView.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLWeatherScrollView.h"

@implementation ZJLWeatherScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        
    }
    return self;
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    [view setFrame:CGRectMake(CGRectGetWidth(self.frame)*index, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    for (int i = index+1; i<[self.subviews count]; i++) {
        UIView *sView = [self.subviews objectAtIndex:i];
        [sView setFrame:CGRectMake(CGRectGetWidth(self.frame)*i, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }
    [self setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*[self.subviews count], CGRectGetHeight(self.frame))];
}

- (void)addSubview:(UIView *)view show:(BOOL)isShow
{
    [self addSubview:view];
    NSUInteger number = [self.subviews count];
    [view setFrame:CGRectMake(CGRectGetWidth(self.frame)*(number-1), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*number, CGRectGetHeight(self.frame))];
    if (isShow) {
        [self setContentOffset:CGPointMake(CGRectGetWidth(self.frame)*(number-1), CGRectGetHeight(self.frame)) animated:YES];
    }
}

- (void)removeSubView:(UIView *)view
{
    NSUInteger index = [self.subviews indexOfObject:view];
    if(index != NSNotFound) {
        NSUInteger numSubviews = [self.subviews count];
        for(NSInteger i = index + 1; i < numSubviews; ++i) {
            UIView *view = [self.subviews objectAtIndex:i];
            [view setFrame:CGRectOffset(view.frame, -1.0 * CGRectGetWidth(view.bounds), 0)];
        }
        [view removeFromSuperview];
        [self setContentSize:CGSizeMake(CGRectGetWidth(self.bounds) * (numSubviews - 1), self.contentSize.height)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
