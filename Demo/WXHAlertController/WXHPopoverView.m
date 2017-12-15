//
//  WXHPopoverView.m
//  Demo
//
//  Created by 伍小华 on 2017/12/12.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHPopoverView.h"
typedef NS_ENUM(NSInteger, WXHAlertViewArrowDirection) {
    WXHAlertViewArrowDirectionUp = 0,
    WXHAlertViewArrowDirectionDown,
};
@interface WXHAlertArrowView : UIView
@property (nonatomic, assign) WXHAlertViewArrowDirection arrowDirection;
@property (nonatomic, strong) UIColor *arrowColor;
@end

@implementation WXHAlertArrowView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arrowColor = [UIColor whiteColor];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint peakPoint;
    CGPoint point1;
    CGPoint curvePoint1;
    CGPoint point2;
    CGPoint curvePoint2;
    if (self.arrowDirection == WXHAlertViewArrowDirectionUp) {
        peakPoint = CGPointMake(rect.size.width/2.0, 0);
        
        point1 = CGPointMake(0, rect.size.height);
        curvePoint1 = CGPointMake(rect.size.width/4.0, rect.size.height/4.0*3);
        
        point2 = CGPointMake(rect.size.width, rect.size.height);
        curvePoint2 = CGPointMake(rect.size.width/4.0*3, rect.size.height/4.0*3);
    } else {
        peakPoint = CGPointMake(rect.size.width/2.0, rect.size.height);
        
        point1 = CGPointMake(0, 0);
        curvePoint1 = CGPointMake(rect.size.width/4.0, rect.size.height/4.0);
        
        point2 = CGPointMake(rect.size.width, 0);
        curvePoint2 = CGPointMake(rect.size.width/4.0*3, rect.size.height/4.0);
    }
    CGContextMoveToPoint(ctx, peakPoint.x, peakPoint.y);
    CGContextAddQuadCurveToPoint(ctx, curvePoint1.x, curvePoint1.y, point1.x, point1.y);
    CGContextAddLineToPoint(ctx, point2.x, point2.y);
    CGContextAddQuadCurveToPoint(ctx, curvePoint2.x, curvePoint2.y, peakPoint.x, peakPoint.y);
    
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.arrowColor.CGColor);
    
    CGContextFillPath(ctx);
}
@end
@interface WXHPopoverView()
@property (nonatomic, strong) WXHAlertArrowView*arrowView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGSize contentSize;

@end
@implementation WXHPopoverView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.arrowView];
        self.contentSize = CGSizeMake(200, 150);
        self.arrowSize = CGSizeMake(30, 15);
        self.margin = 10;
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

#pragma mark - WXHAlertContainerDelegate
- (void)updateLayout
{
    CGRect arrowViewFrame = CGRectMake(0, 0, self.arrowSize.width, self.arrowSize.height);
    CGRect popoverSourceFrame = CGRectEqualToRect(self.popoverSourceFrame, CGRectZero) ? self.popverSourceView.frame : self.popoverSourceFrame;
    CGRect popverSourceViewFrame = [self.superview convertRect:popoverSourceFrame fromView:self.popverSourceView.superview];
    CGRect frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);

    //先判断上下
    if (popverSourceViewFrame.origin.y + popverSourceViewFrame.size.height + frame.size.height + self.arrowSize.height < self.superview.frame.size.height) {//下方
        frame.origin.y = popverSourceViewFrame.origin.y + popverSourceViewFrame.size.height + self.arrowSize.height;
        arrowViewFrame.origin.y = popverSourceViewFrame.origin.y + popverSourceViewFrame.size.height;
        self.arrowView.arrowDirection = WXHAlertViewArrowDirectionUp;
    } else {//上方
        frame.origin.y = popverSourceViewFrame.origin.y - frame.size.height - self.arrowSize.height;
        arrowViewFrame.origin.y = popverSourceViewFrame.origin.y - arrowViewFrame.size.height;
        self.arrowView.arrowDirection = WXHAlertViewArrowDirectionDown;
    }
    //再判断左右
    if (popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 < frame.size.width/2.0) {//左边出界
        frame.origin.x = self.margin;
    } else if (popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 + self.contentSize.width/2.0 > self.superview.frame.size.width) {//右边出界
        frame.origin.x = self.superview.frame.size.width - frame.size.width - self.margin;
    } else {//居中
        frame.origin.x = popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 - frame.size.width/2.0;
    }
    self.frame = frame;
    
    arrowViewFrame.origin.x = popverSourceViewFrame.origin.x + popverSourceViewFrame.size.width/2.0 - arrowViewFrame.size.width/2.0;
    arrowViewFrame = [self convertRect:arrowViewFrame fromView:self.superview];
    
    self.arrowView.frame = arrowViewFrame;
    [self.arrowView setNeedsDisplay];
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
    CGPoint center = self.center;
    CGPoint arrowCenter = [self.superview convertPoint:self.arrowView.center
                                              fromView:self.arrowView.superview];
    
    CAAnimationGroup *animatGroup = [CAAnimationGroup animation];
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
    animatGroup.duration = 0.15;
    animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatGroup.fillMode = kCAFillModeForwards;
    animatGroup.removedOnCompletion = NO;
    return animatGroup;
}
- (CAAnimation *)disappearAnimation
{
    CGPoint arrowCenter = [self.superview convertPoint:self.arrowView.center
                                              fromView:self.arrowView.superview];
    
    CAAnimationGroup *animatGroup = [CAAnimationGroup animation];
    CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animatScale.toValue = @(0.1);
    
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.toValue = @(0);
    
    CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatPosition.toValue = [NSValue valueWithCGPoint:arrowCenter];
    
    animatGroup.animations = @[animatScale,animatOpacity,animatPosition];
    animatGroup.duration = 0.15;
    animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatGroup.fillMode = kCAFillModeForwards;
    animatGroup.removedOnCompletion = NO;
    return animatGroup;
}

#pragma mark - Setter / Getter
- (WXHAlertArrowView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[WXHAlertArrowView alloc] init];
        _arrowView.backgroundColor = [UIColor clearColor];
    }
    return _arrowView;
}
- (void)setArrowColor:(UIColor *)arrowColor
{
    if (_arrowColor != arrowColor) {
        _arrowColor = arrowColor;
        self.arrowView.arrowColor = arrowColor;
        [self.arrowView setNeedsDisplay];
    }
}
- (void)setArrowSize:(CGSize)arrowSize
{
    if (!CGSizeEqualToSize(_arrowSize, arrowSize) ) {
        _arrowSize = arrowSize;
        [self updateLayout];
    }
}
@end
