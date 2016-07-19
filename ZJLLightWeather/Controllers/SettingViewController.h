//
//  SettingViewController.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJLDataManager.h"

@protocol SettingViewControllerDelegate <NSObject>
@required
- (void)didMoveViewFromSource:(NSInteger)sourceIndex to:(NSInteger)destinationIndex;
- (void)didRemoveViewWithIndex:(NSInteger)index;
- (void)didChangeTempTypeTo:(ZJLTempScale)tempScale;
- (void)dismissSettingVC;
@end

@interface SettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, weak) id<SettingViewControllerDelegate> delegate;
@end
