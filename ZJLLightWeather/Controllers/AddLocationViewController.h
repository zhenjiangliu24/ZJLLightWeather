//
//  AddLocationViewController.h
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/18.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddLocationViewControllerDelegate <NSObject>
@required
- (void)didAddLocationWithPlaceMark:(CLPlacemark *)placemark;
- (void)dismissAddLocationVC;
@end

@interface AddLocationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>
@property (nonatomic, weak) id<AddLocationViewControllerDelegate> delegate;
@end
