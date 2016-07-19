//
//  AddLocationViewController.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/18.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "AddLocationViewController.h"

@interface AddLocationViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) UISearchController *searchController;
// Navigation bar at the top of the view
@property (strong, nonatomic) UINavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;
// Done button inside navigation bar
@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation AddLocationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor clearColor];
        self.view.opaque = NO;
        
        self.geocoder = [[CLGeocoder alloc]init];
        self.searchResult = [[NSMutableArray alloc]initWithCapacity:5];
        
        self.navigationBar =[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
        
        [self.view addSubview:self.navigationBar];
        
        self.doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                       target:self
                                                                    action:@selector(doneButtonPressed)];
        
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = NO;
        self.searchController.hidesNavigationBarDuringPresentation = NO;
        self.searchController.searchBar.backgroundColor = [UIColor lightGrayColor];
        self.searchController.searchBar.placeholder = @"Please input the city name";
        self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        self.searchController.searchBar.delegate = self;
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        self.tableView.tableHeaderView = self.searchController.searchBar;
        [self.searchController.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchController.searchBar;
        self.definesPresentationContext = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.searchController.active) {
        self.searchController.active = NO;
        [self.searchController.searchBar removeFromSuperview];
    }
}

#pragma mark - search controller
- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    // Dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Configure cell for the search results table view
    if(tableView == self.tableView) {
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
        CLPlacemark *placemark = [self.searchResult objectAtIndex:indexPath.row];
        NSString *city = placemark.locality;
        NSString *country = placemark.country;
        NSString *cellText = [NSString stringWithFormat:@"%@, %@", city, country];
        cell.textLabel.text = cellText;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView cellForRowAtIndexPath:indexPath].selected = NO;
    CLPlacemark *placemark = [self.searchResult objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAddLocationWithPlaceMark:)] && [self.delegate respondsToSelector:@selector(dismissAddLocationVC)]) {
        [self.delegate didAddLocationWithPlaceMark:placemark];
        [self.delegate dismissAddLocationVC];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResult count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - search bar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissAddLocationVC)]) {
        [self.delegate dismissAddLocationVC];
    }
}

#pragma mark - search view controller delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [searchController.searchBar text];
    [self.geocoder geocodeAddressString:searchString completionHandler: ^ (NSArray *placemarks, NSError *error) {
        [self.searchResult removeAllObjects];
        for(CLPlacemark *placemark in placemarks) {
            if(placemark.locality) {
                [self.searchResult addObject:placemark];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)doneButtonPressed
{
    
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
