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
@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UIView *tableSeparatorView;
@end

@implementation SettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = NO;
        //navigation bar init
        self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage new];
        self.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:0.7];
        self.navigationBar.translucent = YES;
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                     NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:22]}];
        CALayer *border = [CALayer new];
        border.frame = CGRectMake(0, CGRectGetHeight(self.navigationBar.frame)-0.5, CGRectGetWidth(self.navigationBar.frame), 0.5);
        border.backgroundColor = [UIColor whiteColor].CGColor;
        [self.navigationBar.layer addSublayer:border];
        [self.view addSubview:self.navigationBar];
        //done button init
        self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"Settings"];
        [navigationItem setRightBarButtonItem:self.doneButton];
        self.navigationBar.items = @[navigationItem];
        
        //table view init
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.9*self.view.center.y, CGRectGetWidth(self.view.frame), self.view.center.y) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.tableView];
        
        //segment control
        self.tempTypeControl = [[UISegmentedControl alloc] initWithItems:@[@"F°", @"C°"]];
        [self.tempTypeControl addTarget:self action:@selector(tempTypeControlChanged) forControlEvents:UIControlEventValueChanged];
        [self.tempTypeControl setSelectedSegmentIndex:[ZJLDataManager tempScale]];
        self.tempTypeControl.tintColor = [UIColor whiteColor];
        [self.view addSubview:self.tempTypeControl];
        [self.tempTypeControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CGRectGetWidth(self.view.frame)*0.8);
            make.height.mas_equalTo(45);
            make.top.equalTo(self.navigationBar.mas_bottom).with.offset(CGRectGetWidth(self.view.frame)*0.1);
            make.centerX.equalTo(self.view);
        }];
        
        //owner label
        static const CGFloat fontSize = 14;
        self.creditLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 2.0 * fontSize,self.view.bounds.size.width, 1.5 * fontSize)];
        [self.creditLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]];
        [self.creditLabel setTextColor:[UIColor whiteColor]];
        [self.creditLabel setTextAlignment:NSTextAlignmentCenter];
        [self.creditLabel setText:@"Created by Zhenjiang Liu"];
        [self.view addSubview:self.creditLabel];
        
        //location label
        UILabel *locationLabel = [[UILabel alloc] init];
        locationLabel.textAlignment = NSTextAlignmentCenter;
        locationLabel.textColor = [UIColor whiteColor];
        locationLabel.backgroundColor = [UIColor clearColor];
        locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        [self.view addSubview:locationLabel];
        [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CGRectGetWidth(self.view.frame)*0.5);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(35);
            make.bottom.equalTo(self.tableView.mas_top).with.offset(20);
        }];
        
        self.tableSeparatorView = [[UIView alloc]initWithFrame:CGRectMake(16, 0, CGRectGetWidth(self.view.bounds) - 32, 0.5)];
        self.tableSeparatorView.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y);
        self.tableSeparatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.view addSubview:self.tableSeparatorView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView setEditing:YES animated:YES];
    [self.tableView reloadData];
}

#pragma mark - table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - table view data source 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    // Dequeue a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        // Initialize new cell if cell is null
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set cell's label text
    NSArray *location = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = [location firstObject];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Remove the location with the associated tag, alert the delegate
        NSNumber *weatherViewTag = [[self.locations objectAtIndex:indexPath.row]lastObject];
        [self.delegate didRemoveViewWithTag:weatherViewTag.integerValue];
        [self.locations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSArray *locationMetaData = [self.locations objectAtIndex:sourceIndexPath.row];
    [self.locations removeObjectAtIndex:sourceIndexPath.row];
    [self.locations insertObject:locationMetaData atIndex:destinationIndexPath.row];
    [self.delegate didMoveViewFromSource:sourceIndexPath.row to:destinationIndexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locations count];
}

#pragma mark - temp type changed

- (void)tempTypeControlChanged
{
    ZJLTempScale tempType = (ZJLTempScale)[self.tempTypeControl selectedSegmentIndex];
    [ZJLDataManager setTempScale:tempType];
    [self.delegate didChangeTempTypeTo:tempType];
}

#pragma mark - done button clicked

- (void)doneButtonClicked
{
    [self.delegate dismissSettingVC];
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
