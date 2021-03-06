//
//  IntroductionViewController.m
//  ZJLLightWeather
//
//  Created by ZhongZhongzhong on 16/7/21.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "IntroductionViewController.h"
#import "SMPageControl.h"
#import "MainPageViewController.h"

@interface IntroductionViewController ()
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) SMPageControl *pageControl;

@property (nonatomic, strong) UIImageView *plane;
@property (nonatomic, strong) CAShapeLayer *planePathLayer;
@property (nonatomic, strong) UIView *planePathView;
@property (nonatomic, strong) IFTTTPathPositionAnimation *airplaneFlyingAnimation;


@property (nonatomic, strong) UIImageView *sun;

@property (nonatomic, strong) UIImageView *bigCloud;

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
    
    [self configureViews];
    [self configureAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scaleAirplanePathToSize:self.scrollView.frame.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - configure view

- (void)configureViews
{
    //configure start button
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
    
    //configure page control
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
    
    // configure plane view
    self.planePathView = [UIView new];
    [self.contentView addSubview:self.planePathView];
    self.plane = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Airplane"]];
    
    //configure sun
    self.sun = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sun"]];
    [self.contentView addSubview:self.sun];
    
    //configure big cloud
    self.bigCloud = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BigCloud"]];
    [self.contentView addSubview:self.bigCloud];
}

#pragma mark - configure animations

- (void)configureAnimations
{
    [self configureScrollViewAnimations];
    [self configurePlaneAnimations];
    [self animateCurrentFrame];
    [self configureSun];
    [self configureBigCloud];
    [self configureStartButton];
}

- (void)configureScrollViewAnimations
{
    IFTTTBackgroundColorAnimation *backgroundColorAnimation = [IFTTTBackgroundColorAnimation animationWithView:self.scrollView];
    [backgroundColorAnimation addKeyframeForTime:0 color:[UIColor colorWithRed:174/255.0f green:130/255.0f blue:197/255.0f alpha:1.0]];
    [backgroundColorAnimation addKeyframeForTime:1 color:[UIColor colorWithRed:76/255.0f green:123/255.0f blue:188/255.0f alpha:1.f]];
    [backgroundColorAnimation addKeyframeForTime:1.1 color:[UIColor colorWithRed:0.14f green:0.8f blue:1.f alpha:1.f]];
    [self.animator addAnimation:backgroundColorAnimation];
}

- (void)configurePlaneAnimations
{
    // Set up the view that contains the airplane view and its dashed line path view
    self.planePathLayer = [self airplanePathLayer];
    [self.planePathView.layer addSublayer:self.planePathLayer];
    
    [self.planePathView addSubview:self.plane];
    [self.plane mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.planePathView.mas_centerY);
        make.right.equalTo(self.planePathView.mas_centerX);
    }];
    
    [self.planePathView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(15);
        make.width.and.height.equalTo(self.plane);
    }];
    
    // Keep the left edge of the planePathView at the center of pages 1 and 2
    [self keepView:self.planePathView onPages:@[@(0),@(1),@(2)] atTimes:@[@(0),@(1),@(2)] withAttribute:IFTTTHorizontalPositionAttributeLeft];
    
    // Fly the plane along the path
    self.airplaneFlyingAnimation = [IFTTTPathPositionAnimation animationWithView:self.plane path:self.planePathLayer.path];
    [self.airplaneFlyingAnimation addKeyframeForTime:0 animationProgress:0];
    [self.airplaneFlyingAnimation addKeyframeForTime:1 animationProgress:0.5];
    [self.airplaneFlyingAnimation addKeyframeForTime:2 animationProgress:0.95];
    [self.animator addAnimation:self.airplaneFlyingAnimation];
    
    // Change the stroke end of the dashed line airplane path to match the plane's current position
    IFTTTLayerStrokeEndAnimation *planePathAnimation = [IFTTTLayerStrokeEndAnimation animationWithLayer:self.planePathLayer];
    [planePathAnimation addKeyframeForTime:0 strokeEnd:0];
    [planePathAnimation addKeyframeForTime:2 strokeEnd:1];
    [self.animator addAnimation:planePathAnimation];
    
    // Fade the plane path view in after page 1 and fade it out again after page 2.5
    IFTTTAlphaAnimation *planeAlphaAnimation = [IFTTTAlphaAnimation animationWithView:self.planePathView];
    [planeAlphaAnimation addKeyframeForTime:0.0f alpha:1];
    [planeAlphaAnimation addKeyframeForTime:1.08f alpha:1];
    [planeAlphaAnimation addKeyframeForTime:2.5f alpha:1];
    [planeAlphaAnimation addKeyframeForTime:3.f alpha:0];
    [self.animator addAnimation:planeAlphaAnimation];
}

- (void)configureSun
{
    [self keepView:self.sun onPages:@[@(1.8),@(1.6)] atTimes:@[@(1.5),@(2)]];
    
    NSLayoutConstraint *sunVerticalConstraint = [NSLayoutConstraint constraintWithItem:self.sun
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1.f constant:0.f];
    
    [self.contentView addConstraint:sunVerticalConstraint];
    IFTTTConstraintConstantAnimation *sunVerticalAnimation = [IFTTTConstraintConstantAnimation animationWithSuperview:self.contentView constraint:sunVerticalConstraint];
    [sunVerticalAnimation addKeyframeForTime:1 constant:-200.f];
    [sunVerticalAnimation addKeyframeForTime:2 constant:20.f];
    [self.animator addAnimation:sunVerticalAnimation];
}

- (void)configureBigCloud
{
    [self.bigCloud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.lessThanOrEqualTo(self.scrollView).multipliedBy(0.58);
        make.height.lessThanOrEqualTo(self.scrollView).multipliedBy(0.2);
        make.height.equalTo(self.bigCloud.mas_width).multipliedBy(0.45);
    }];
    [self keepView:self.bigCloud onPages:@[@(1)] atTimes:@[@(0)]];
    
    // Move the big cloud down from above the screen on page 1 to near the top of the screen on page 2
    NSLayoutConstraint *bigCloudVerticalConstraint = [NSLayoutConstraint constraintWithItem:self.bigCloud
                                                                                                       attribute:NSLayoutAttributeCenterY
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1.f constant:0.f];
    
    [self.contentView addConstraint:bigCloudVerticalConstraint];
    
    IFTTTConstraintMultiplierAnimation *bigCloudVerticalAnimation = [IFTTTConstraintMultiplierAnimation animationWithSuperview:self.contentView
                                                                                                                    constraint:bigCloudVerticalConstraint
                                                                                                                     attribute:IFTTTLayoutAttributeHeight
                                                                                                                 referenceView:self.contentView];
    [bigCloudVerticalAnimation addKeyframeForTime:0.5 multiplier:-0.2f];
    [bigCloudVerticalAnimation addKeyframeForTime:1 multiplier:0.2f];
    [self.animator addAnimation:bigCloudVerticalAnimation];
    
    
}

- (void)configureStartButton
{
    IFTTTAlphaAnimation *startButtonAnimation = [[IFTTTAlphaAnimation alloc] initWithView:self.startButton];
    [startButtonAnimation addKeyframeForTime:0 alpha:0];
    [startButtonAnimation addKeyframeForTime:1 alpha:0];
    [startButtonAnimation addKeyframeForTime:2 alpha:1.0];
    [self.animator addAnimation:startButtonAnimation];
}

- (void)animateCurrentFrame
{
    [self.animator animate:self.pageOffset];
}


#pragma mark - scale plane path

- (CGPathRef)airplanePath
{
    // Create a bezier path for the airplane to fly along
    UIBezierPath *airplanePath = [UIBezierPath bezierPath];
    [airplanePath moveToPoint: CGPointMake(120, -120)];
    [airplanePath addCurveToPoint: CGPointMake(360, -400) controlPoint1: CGPointMake(260, -10) controlPoint2: CGPointMake(330, -580)];
    [airplanePath addCurveToPoint: CGPointMake(100, 0) controlPoint1: CGPointMake(400, -110) controlPoint2: CGPointMake(160, -300)];
//    [airplanePath addCurveToPoint: CGPointMake(30, -590) controlPoint1: CGPointMake(320, -430) controlPoint2: CGPointMake(130, -190)];
    
    return airplanePath.CGPath;
}

- (CAShapeLayer *)airplanePathLayer
{
    // Create a shape layer to draw the airplane's path
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [self airplanePath];
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.lineDashPattern = @[@(20), @(20)];
    shapeLayer.lineWidth = 4;
    shapeLayer.miterLimit = 4;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    
    return shapeLayer;
}

- (void)scaleAirplanePathToSize:(CGSize)pageSize
{
    // Scale the airplane path to the given page size
    CGSize scaleSize = CGSizeMake(pageSize.width / 375.f, pageSize.height / 667.f);
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scaleSize.width, scaleSize.height);
    
    CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(self.airplanePath, &scaleTransform);
    
    self.planePathLayer.path = scaledPath;
    self.airplaneFlyingAnimation.path = scaledPath;
    CGPathRelease(scaledPath);
}

#pragma mark - start button clicked
- (void)startButtonClicked
{
    MainPageViewController *mainVC = [[MainPageViewController alloc] init];
    [self presentViewController:mainVC animated:YES completion:nil];
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
        [self scaleAirplanePathToSize:size];
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
        [self scaleAirplanePathToSize:newPageSize];
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
