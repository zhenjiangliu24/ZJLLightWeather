//
//  IntroductionViewController.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/21.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "IntroductionViewController.h"
#import "SMPageControl.h"
#import "UIColor+expanded.h"
#import "UIImage+Resizing.h"

@interface IntroductionViewController ()
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) SMPageControl *pageControl;

@property (nonatomic, strong) UIImageView *planeView;
@property (nonatomic, strong) CAShapeLayer *planePathLayer;
@property (nonatomic, strong) UIImageView *planePathView;
@end

@implementation IntroductionViewController

- (NSUInteger)numberOfPages
{
    return 3;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configure view

- (void)configureViews
{
    UIColor *darkColor = [UIColor colorWithHexString:@"0x28303b"];
    CGFloat buttonWidth = kScreen_Width * 0.4;
    CGFloat buttonHeight = kScaleFrom_iPhone5_Desgin(38);
    CGFloat paddingToBottom = kScaleFrom_iPhone5_Desgin(20);
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.backgroundColor = darkColor;
    [self.startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startButton.layer.masksToBounds = YES;
    self.startButton.layer.cornerRadius = buttonHeight/2;
    [self.view addSubview:self.startButton];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(buttonWidth, buttonHeight));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-paddingToBottom);
    }];
    
    UIImage *pageIndicatorImage = [UIImage imageNamed:@"intro_dot_unselected"];
    UIImage *currentPageIndicatorImage = [UIImage imageNamed:@"intro_dot_selected"];
    
    if (!kDevice_Is_iPhone6 && !kDevice_Is_iPhone6Plus) {
        CGFloat desginWidth = 375.0;//iPhone6 的设计尺寸
        CGFloat scaleFactor = kScreen_Width/desginWidth;
        pageIndicatorImage = [pageIndicatorImage scaleByFactor:scaleFactor];
        currentPageIndicatorImage = [currentPageIndicatorImage scaleByFactor:scaleFactor];
    }
    self.pageControl = [[SMPageControl alloc] init];
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.currentPageIndicatorImage = currentPageIndicatorImage;
    self.pageControl.pageIndicatorImage = pageIndicatorImage;
    self.pageControl.userInteractionEnabled = NO;
    [self.pageControl sizeToFit];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScaleFrom_iPhone5_Desgin(20)));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.startButton.mas_top).offset(-kScaleFrom_iPhone5_Desgin(20));
    }];
    
}

#pragma mark - start button clicked
- (void)startButtonClicked
{
    
}

#pragma mark - phone orientation
- (BOOL)shouldAutorotate{
    return UIInterfaceOrientationIsLandscape(self.interfaceOrientation);
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)forceChangeToOrientation:(UIInterfaceOrientation)interfaceOrientation{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
}

#pragma mark - iOS8+ Resizing

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //[self scaleAirplanePathToSize:size];
    } completion:nil];
}

#pragma mark - iOS7 Orientation Change Resizing

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGSize newPageSize;
    
    if ((UIInterfaceOrientationIsLandscape(self.interfaceOrientation)
         && UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
        || (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)
            && UIInterfaceOrientationIsLandscape(toInterfaceOrientation))) {
            
            newPageSize = CGSizeMake(CGRectGetHeight(self.scrollView.frame), CGRectGetWidth(self.scrollView.frame));
        } else {
            newPageSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        }
    
    [UIView animateWithDuration:duration animations:^{
        //[self scaleAirplanePathToSize:newPageSize];
    } completion:nil];
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
