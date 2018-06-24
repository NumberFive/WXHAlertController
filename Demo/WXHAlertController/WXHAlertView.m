//
//  WXHAlertView.m
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHAlertView.h"
@interface WXHAlertView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGSize contentSize;
@end
@implementation WXHAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(200, 150);
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}
//使事件透过自己
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) return nil;
    
    if (![self pointInside:point withEvent:event]) return nil;
    
    NSInteger count = self.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint childPoint = [self convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childPoint withEvent:event];
        if (fitView) {
            return fitView;
        }
    }
    return nil;
}
#pragma mark - WXHAlertContainerDelegate
- (void)updateLayout
{
    self.frame = CGRectMake((self.superview.frame.size.width-self.contentSize.width)/2.0,
                            (self.superview.frame.size.height-self.contentSize.height)/2.0,
                            self.contentSize.width, self.contentSize.height);
}
- (void)setContentSize:(CGSize)size
{
    _contentSize = size;
    [self updateLayout];
}
- (void)setContentView:(UIView *)view
{
    if (_contentView != view) {
        if (_contentView) {
            [_contentView removeFromSuperview];
        }
        _contentView = view;
        [self addSubview:_contentView];
    }
    [self updateLayout];
}
- (CAAnimation *)appearAnimation
{
    CAAnimationGroup *animatGroup = [CAAnimationGroup animation];
    
    CAKeyframeAnimation *animatScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animatScale.values = @[@(0.0),@(0.5),@(1.0),@(1.2),@(1.1),@(1.0)];
    
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.fromValue = @(0.0);
    animatOpacity.toValue = @(1.0);
    
    animatGroup.animations = @[animatScale,animatOpacity];
    animatGroup.duration = 0.1;
    animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatGroup.fillMode = kCAFillModeForwards;
    animatGroup.removedOnCompletion = NO;
    return animatGroup;
}
- (CAAnimation *)disappearAnimation
{
    CAAnimationGroup *animatGroup = [CAAnimationGroup animation];
    CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animatScale.toValue = @(0.1);
    animatScale.autoreverses = YES;
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.toValue = @(0);
    
    animatGroup.animations = @[animatScale,animatOpacity];
    animatGroup.duration = 0.1;
    animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatGroup.fillMode = kCAFillModeForwards;
    animatGroup.removedOnCompletion = NO;
    return animatGroup;
}
@end
