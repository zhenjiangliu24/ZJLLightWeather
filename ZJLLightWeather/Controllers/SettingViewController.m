//
//  SettingViewController.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/19.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UISegmentedControl *tempTypeControl;

@end

@implementation SettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _locations = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
