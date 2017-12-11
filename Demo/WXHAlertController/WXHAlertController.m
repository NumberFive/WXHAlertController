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
@property (nonatomic, weak) UIView *alertSuperView;

@property (nonatomic, copy) WXHAlertBlock didAppearBlock;
@property (nonatomic, copy) WXHAlertBlock didDisappearBlock;

@property (nonatomic, assign) NSTimeInterval appearAnimationTimeInterval;
@property (nonatomic, assign) NSTimeInterval disappearAnimationTimeInterval;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) BOOL isAppearAnimationing;
@property (nonatomic, assign) BOOL isDisappearAnimationing;

@end
@implementation WXHAlertController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNotification];
        self.contentSize = CGSizeMake(100, 100);
        self.arrowSize = CGSizeMake(30, 15);
        self.margin = 10;
        self.appearAnimationTimeInterval = 0.15;
        self.disappearAnimationTimeInterval = 0.15;
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"WXHAlertController dealloc");
}
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLayout)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(positionHUD:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(positionHUD:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(positionHUD:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(positionHUD:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
}



- (void)updateLayout
{
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect alertViewFrame = CGRectZero;
    
    if (self.alertSuperView) {
        screenFrame = self.alertSuperView.bounds;
    }
    self.maskView.frame = screenFrame;
    self.alertView.arrowView.arrowDirection = WXHAlertViewArrowDirectionNone;
    
    if (self.style == WXHAlertControllerStyleAlert) {
        alertViewFrame = CGRectMake((screenFrame.size.width-self.contentSize.width)/2.0,
                                           (screenFrame.size.height-self.contentSize.height)/2.0 + self.alertOffset,
                                           self.contentSize.width, self.contentSize.height);
        self.alertView.frame = alertViewFrame;
    } else if (self.style == WXHAlertControllerStyleActionSheet){
        alertViewFrame = CGRectMake(0,
                                    screenFrame.size.height-self.contentSize.height,
                                    screenFrame.size.width, self.contentSize.height);
        self.alertView.frame = alertViewFrame;
    } else if (self.style == WXHAlertControllerStylePopover){
        CGRect popverSourceViewFrame;
        CGRect arrowViewFrame = CGRectMake(0, 0, self.arrowSize.width, self.arrowSize.height);
        
        CGRect popoverSourceFrame = CGRectEqualToRect(self.popoverSourceFrame, CGRectZero) ? self.popverSourceView.frame : self.popoverSourceFrame;
        if (self.alertSuperView) {
            popverSourceViewFrame = [self.alertSuperView convertRect:popoverSourceFrame
                                            fromView:self.popverSourceView.superview];
        } else {
            popverSourceViewFrame = [self.frontWindow convertRect:popoverSourceFrame
                                                         fromView:self.popverSourceView.superview];
        }
        alertViewFrame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        //先判断上下
        if (popverSourceViewFrame.origin.y + popverSourceViewFrame.size.height + alertViewFrame.size.height + self.arrowSize.height < screenFrame.size.height) {//下方
            alertViewFrame.origin.y = popverSourceViewFrame.origin.y + popverSourceViewFrame.size.height + self.arrowSize.height;
            arrowViewFrame.origin.y = popverSourceViewFrame.origin.y + popverSourceViewFrame.size.height;
            self.alertView.arrowView.arrowDirection = WXHAlertViewArrowDirectionUp;
        } else {//上方
            alertViewFrame.origin.y = popverSourceViewFrame.origin.y - alertViewFrame.size.height - self.arrowSize.height;
            arrowViewFrame.origin.y = popverSourceViewFrame.origin.y - arrowViewFrame.size.height;
            self.alertView.arrowView.arrowDirection = WXHAlertViewArrowDirectionDown;
        }
        //再判断左右
        if (popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 < alertViewFrame.size.width/2.0) {//左边出界
            alertViewFrame.origin.x = self.margin;
        } else if (popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 + alertViewFrame.size.width/2.0 > screenFrame.size.width) {//右边出界
            alertViewFrame.origin.x = screenFrame.size.width - alertViewFrame.size.width - self.margin;
        } else {//居中
            alertViewFrame.origin.x = popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 - alertViewFrame.size.width/2.0;
        }
        arrowViewFrame.origin.x = popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 - arrowViewFrame.size.width/2.0;
        self.alertView.frame = alertViewFrame;
        
        if (self.alertSuperView) {
            alertViewFrame = [self.alertView convertRect:arrowViewFrame fromView:self.alertSuperView];
        } else {
            alertViewFrame = [self.alertView convertRect:arrowViewFrame fromView:self.frontWindow];
        }
        
        self.alertView.arrowView.frame = alertViewFrame;
        [self.alertView.arrowView setNeedsDisplay];
    }
}

- (void)show:(WXHAlertBlock)finished
{
    self.didAppearBlock = finished;
    if (!self.isShow) {
        [self addToView:self.frontWindow];
    }
}
- (void)showOnView:(UIView *)view complete:(WXHAlertBlock)finished
{
    self.didAppearBlock = finished;
    if (!self.isShow) {
        self.alertSuperView = view;
        [self addToView:view];
    }
}
- (void)addToView:(UIView *)view
{
    self.alertView.alertController = self;
    [view addSubview:self.alertView];
    [view insertSubview:self.maskView belowSubview:self.alertView];
    [self updateLayout];
    if (!self.isShow && !self.isAppearAnimationing) {
        [self appearWithAnimation];
    }
    _isShow = YES;
}

- (void)dismiss:(WXHAlertBlock)finished
{
    self.didDisappearBlock = finished;
    if (self.isShow && !self.isDisappearAnimationing) {
        [self disappearWithAnimation];
    }
}

- (void)appearWithAnimation
{
    self.isAppearAnimationing = YES;
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.fromValue = @(0.0);
    animatOpacity.toValue = @(1.0);
    [self.maskView.layer addAnimation:animatOpacity forKey:@"appearAnimation"];
    
    [self.alertView.layer addAnimation:self.appearAnimation forKey:@"appearAnimation"];
}
- (void)disappearWithAnimation
{
    self.isDisappearAnimationing = YES;
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.toValue = @(0);
    [self.maskView.layer addAnimation:animatOpacity forKey:@"disappearAnimation"];
    [self.alertView.layer addAnimation:self.disappearAnimation forKey:@"disappearAnimation"];
}
- (void)didAppear
{
    self.isAppearAnimationing = NO;
    
    [self.maskView.layer removeAnimationForKey:@"appearAnimation"];
    [self.alertView.layer removeAnimationForKey:@"appearAnimation"];
    if (self.didAppearBlock) {
        self.didAppearBlock();
    }
}
- (void)didDisappear
{
    _isShow = NO;
    self.isDisappearAnimationing = NO;
    [self.alertView removeFromSuperview];
    [self.maskView removeFromSuperview];
    [self.maskView.layer removeAnimationForKey:@"disappearAnimation"];
    [self.alertView.layer removeAnimationForKey:@"disappearAnimation"];
    
    if (self.didDisappearBlock) {
        self.didDisappearBlock();
    }
    self.alertView.alertController = nil;
}
#pragma mark - WXHAlertMaskViewDelegate
- (void)alertMaskViewDidTap
{
    if (self.maskViewDidTapBlock) {
        self.maskViewDidTapBlock();
    }
    [self dismiss:nil];
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
- (WXHAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [[WXHAlertView alloc] init];
    }
    return _alertView;
}
- (void)setContentView:(UIView *)contentView
{
    self.alertView.contentView = contentView;
}

- (void)setArrowColor:(UIColor *)arrowColor
{
    _arrowColor = arrowColor;
    self.alertView.arrowView.arrowColor = arrowColor;
}

- (WXHAlertMaskView *)maskView
{
    if (!_maskView) {
        _maskView = [[WXHAlertMaskView alloc] init];
        _maskView.delegate = self;
    }
    return _maskView;
}

- (void)setMaskViewType:(WXHAlertMaskViewType)maskViewType
{
    _maskViewType = maskViewType;
    self.maskView.type = maskViewType;
}
- (void)setMaskViewColor:(UIColor *)maskViewColor
{
    _maskViewColor = maskViewColor;
    self.maskView.color = maskViewColor;
}
- (CAAnimation *)appearAnimation
{
    CAAnimation *animation = _disappearAnimation;
    if (!animation) {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        UIView *superview = self.frontWindow;
        if (self.alertSuperView) {
            superview = self.alertSuperView;
            screenFrame = self.alertSuperView.bounds;
        }
        CAAnimationGroup *animatGroup;
        if (self.style == WXHAlertControllerStyleActionSheet) {
            CGPoint fromCenter = self.alertView.center;
            CGPoint toCenter = self.alertView.center;
            fromCenter.y = screenFrame.size.height + self.alertView.frame.size.height/2.0;
            toCenter.y = screenFrame.size.height - self.alertView.frame.size.height/2.0;
            
            animatGroup = [CAAnimationGroup animation];
            CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animatOpacity.fromValue = @(0.0);
            animatOpacity.toValue = @(1.0);
            
            CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
            animatPosition.fromValue = [NSValue valueWithCGPoint:fromCenter];
            animatPosition.toValue = [NSValue valueWithCGPoint:toCenter];
            
            animatGroup.animations = @[animatOpacity,animatPosition];
            
        } else if (self.style == WXHAlertControllerStylePopover) {
            CGPoint center = self.alertView.center;
            CGPoint arrowCenter = [superview convertPoint:self.alertView.arrowView.center
                                                 fromView:self.alertView.arrowView.superview];
            
            animatGroup = [CAAnimationGroup animation];
            CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animatScale.fromValue = @(0.0);
            animatScale.toValue = @(1.0);
            
            CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animatOpacity.fromValue = @(0.0);
            animatOpacity.toValue = @(1.0);
            
            CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
            animatPosition.fromValue = [NSValue valueWithCGPoint:arrowCenter];
            animatPosition.toValue = [NSValue valueWithCGPoint:center];
            
            animatGroup.animations = @[animatScale,animatOpacity,animatPosition];
        } else {
            animatGroup = [CAAnimationGroup animation];
            
            CAKeyframeAnimation *animatScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animatScale.values = @[@(0.0),@(0.5),@(1.0),@(1.2),@(1.1),@(1.0)];
            
            CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animatOpacity.fromValue = @(0.0);
            animatOpacity.toValue = @(1.0);
            
            animatGroup.animations = @[animatScale,animatOpacity];
        }
        
        animatGroup.duration = self.appearAnimationTimeInterval;
        animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animatGroup.fillMode = kCAFillModeForwards;
        animatGroup.removedOnCompletion = NO;
        animation = animatGroup;
    }
    animation.delegate =  self;
    [animation setValue:@"appearAnimation" forKey:@"AnimationKey"];
    
    return animation;
}
- (CAAnimation *)disappearAnimation
{
    CAAnimation *animation = _disappearAnimation;
    if (!animation) {
        CGRect screenFrame = [UIScreen mainScreen].bounds;
        UIView *superview = self.frontWindow;
        if (self.alertSuperView) {
            superview = self.alertSuperView;
            screenFrame = self.alertSuperView.bounds;
        }
        CAAnimationGroup *animatGroup;
        if (self.style == WXHAlertControllerStyleActionSheet) {
            CGPoint center = self.alertView.center;
            center.y = screenFrame.size.height+self.alertView.frame.size.height/2.0;
            
            animatGroup = [CAAnimationGroup animation];
            CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animatOpacity.toValue = @(0);
            
            CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
            animatPosition.toValue = [NSValue valueWithCGPoint:center];
            
            animatGroup.animations = @[animatOpacity,animatPosition];
        } else if (self.style == WXHAlertControllerStylePopover) {
            CGPoint arrowCenter = [superview convertPoint:self.alertView.arrowView.center
                                                 fromView:self.alertView.arrowView.superview];
            
            animatGroup = [CAAnimationGroup animation];
            CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animatScale.toValue = @(0.1);
            
            CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animatOpacity.toValue = @(0);
            
            CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
            animatPosition.toValue = [NSValue valueWithCGPoint:arrowCenter];
            
            animatGroup.animations = @[animatScale,animatOpacity,animatPosition];
        } else {
            animatGroup = [CAAnimationGroup animation];
            CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animatScale.toValue = @(0.1);
            animatScale.autoreverses = YES;
            CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animatOpacity.toValue = @(0);
            
            animatGroup.animations = @[animatScale,animatOpacity];
        }
        animatGroup.duration = self.appearAnimationTimeInterval;
        animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animatGroup.fillMode = kCAFillModeForwards;
        animatGroup.removedOnCompletion = NO;
        animation = animatGroup;
    }
    animation.delegate = self;
    [animation setValue:@"disappearAnimation" forKey:@"AnimationKey"];
    
    return animation;
}

@end
