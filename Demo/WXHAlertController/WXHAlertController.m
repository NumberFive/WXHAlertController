//
//  WXHAlertController.m
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHAlertController.h"

@interface WXHAlertController ()<WXHAlertMaskViewDelegate,CAAnimationDelegate>
@property (nonatomic, strong) UIWindow *frontWindow;

@property (nonatomic, copy) WXHAlertBlock didAppearBlock;
@property (nonatomic, copy) WXHAlertBlock didDisappearBlock;

@property (nonatomic, assign) NSTimeInterval appearAnimationTimeInterval;
@property (nonatomic, assign) NSTimeInterval disappearAnimationTimeInterval;

@property (nonatomic, strong) CAAnimation *appearAnimation;
@property (nonatomic, strong) CAAnimation *disappearAnimation;

@property (nonatomic, strong) UIView<WXHAlertContainerDelegate> *containerView;
@property (nonatomic, strong) WXHAlertMaskView *maskView;

@property (nonatomic, weak) id<WXHAlertContainerDelegate> delegate;
@property (nonatomic, copy) WXHAlertBlock maskViewDidTapBlock;
@end
@implementation WXHAlertController

- (instancetype)initWithContainer:(UIView<WXHAlertContainerDelegate> *)container
{
    self = [super init];
    if (self) {
        self.containerView = container;
        
        self.contentSize = CGSizeMake(100, 100);
        self.appearAnimationTimeInterval = 0.15;
        self.disappearAnimationTimeInterval = 0.15;
        self.dismisWhenMaskViewDidTap = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLayout)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateLayout
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateLayout)]) {
        [self.delegate updateLayout];
    }
    self.maskView.frame = self.containerView.superview.bounds;
}

- (void)show:(WXHAlertBlock)finished
{
    self.didAppearBlock = finished;
    if (!self.isShow) {
        [self addToContainerView:self.frontWindow];
    }
}
- (void)showOnView:(UIView *)view complete:(WXHAlertBlock)finished
{
    self.didAppearBlock = finished;
    if (!self.isShow) {
        [self addToContainerView:view];
    }
}
- (void)showOnView:(UIView *)view
      aboveSubview:(UIView *)subview
          complete:(WXHAlertBlock)finished
{
    self.didAppearBlock = finished;
    if (!self.isShow) {
        self.maskView.alertController = self;
        [view insertSubview:self.containerView aboveSubview:subview];
        [view insertSubview:self.maskView belowSubview:self.containerView];
        [self updateLayout];
        [self appearWithAnimation];
        _isShow = YES;
    }
}
- (void)showOnView:(UIView *)view
      belowSubview:(UIView *)subview
          complete:(WXHAlertBlock)finished
{
    self.didAppearBlock = finished;
    if (!self.isShow) {
        self.maskView.alertController = self;
        [view insertSubview:self.containerView belowSubview:subview];
        [view insertSubview:self.maskView belowSubview:self.containerView];
        [self updateLayout];
        [self appearWithAnimation];
        _isShow = YES;
    }
}
- (void)addToContainerView:(UIView *)view
{
    self.maskView.alertController = self;
    [view addSubview:self.containerView];
    [view insertSubview:self.maskView belowSubview:self.containerView];
    [self updateLayout];
    [self appearWithAnimation];
    _isShow = YES;
}

- (void)dismiss:(WXHAlertBlock)finished
{
    self.didDisappearBlock = finished;
    [self disappearWithAnimation];
}

- (void)appearWithAnimation
{
    if (!self.isShow && !self.isAppearAnimationing) {
        _isAppearAnimationing = YES;
        [self.maskView.layer addAnimation:self.maskView.appearAnimation forKey:@"appearAnimation"];
        [self.containerView.layer addAnimation:self.appearAnimation forKey:@"appearAnimation"];
    }
}
- (void)disappearWithAnimation
{
    if (self.isShow && !self.isDisappearAnimationing) {
        _isDisappearAnimationing = YES;
        [self.maskView.layer addAnimation:self.maskView.disappearAnimation forKey:@"disappearAnimation"];
        [self.containerView.layer addAnimation:self.disappearAnimation forKey:@"disappearAnimation"];
    }
}
- (void)didAppear
{
    _isAppearAnimationing = NO;
    
    [self.maskView.layer removeAnimationForKey:@"appearAnimation"];
    [self.containerView.layer removeAnimationForKey:@"appearAnimation"];
    if (self.didAppearBlock) {
        self.didAppearBlock();
    }
}
- (void)didDisappear
{
    _isShow = NO;
    _isDisappearAnimationing = NO;
    [self.containerView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self.maskView.layer removeAnimationForKey:@"disappearAnimation"];
    [self.containerView.layer removeAnimationForKey:@"disappearAnimation"];
    
    if (self.didDisappearBlock) {
        self.didDisappearBlock();
    }
    self.didAppearBlock = nil;
    self.didDisappearBlock = nil;
    self.maskViewDidTapBlock = nil;
    self.maskView.alertController = nil;
}

- (void)setContentView:(UIView *)contentView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setContentView:)]) {
        [self.delegate setContentView:contentView];
    }
}
- (void)setContentSize:(CGSize)contentSize
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setContentSize:)]) {
        [self.delegate setContentSize:contentSize];
    }
}
#pragma mark - WXHAlertMaskViewDelegate
- (void)alertMaskViewDidTap
{
    if (self.maskViewDidTapBlock) {
        self.maskViewDidTapBlock();
    }
    if (self.dismisWhenMaskViewDidTap) {
        [self dismiss:nil];
    }
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString *animationKey = [anim valueForKey:@"AnimationKey"];
    if ([animationKey isEqualToString:@"disappearAnimation"]) {
        [self didDisappear];
    } else if ([animationKey isEqualToString:@"appearAnimation"]) {
        [self didAppear];
    }
}
#pragma mark - Setter / Getter
- (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {
            return window;
        }
    }
    return nil;
}

- (WXHAlertMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[WXHAlertMaskView alloc] init];
        _maskView.delegate = self;
    }
    return _maskView;
}
- (void)setContainerView:(UIView<WXHAlertContainerDelegate> *)containerView
{
    if (_containerView != containerView) {
        _containerView = containerView;
        self.delegate = containerView;
    }
}
- (void)setMaskViewType:(WXHAlertMaskViewType)maskViewType
{
    self.maskView.type = maskViewType;
}
- (void)setMaskViewColor:(UIColor *)maskViewColor
{
    self.maskView.color = maskViewColor;
}
- (CAAnimation *)appearAnimation
{
    CAAnimation *animation;
    if (self.delegate && [self.delegate respondsToSelector:@selector(appearAnimation)]) {
        animation = [self.delegate appearAnimation];
    } else {
        CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animatOpacity.fromValue = @(0);
        animatOpacity.toValue = @(1);
        animatOpacity.duration = self.appearAnimationTimeInterval;
        animatOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animatOpacity.fillMode = kCAFillModeForwards;
        animatOpacity.removedOnCompletion = NO;
        animation = animatOpacity;
    }
    return animation;
}
- (CAAnimation *)disappearAnimation
{
    CAAnimation *animation;
    if (self.delegate && [self.delegate respondsToSelector:@selector(disappearAnimation)]) {
        animation = [self.delegate disappearAnimation];
    } else {
        CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animatOpacity.toValue = @(0);
        animatOpacity.duration = self.disappearAnimationTimeInterval;
        animatOpacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animatOpacity.fillMode = kCAFillModeForwards;
        animatOpacity.removedOnCompletion = NO;
        animation = animatOpacity;
    }
    animation.delegate = self;
    [animation setValue:@"disappearAnimation" forKey:@"AnimationKey"];
    return animation;
}

@end
