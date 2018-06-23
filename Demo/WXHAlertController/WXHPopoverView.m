//
//  WXHPopoverView.m
//  Demo
//
//  Created by 伍小华 on 2017/12/12.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHPopoverView.h"
@interface WXHPopoverView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGPoint arrowPosition;

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) CAShapeLayer *maskShapeLayer;
@property (nonatomic, strong) UIView *maskView;
@end
@implementation WXHPopoverView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentSize = CGSizeMake(200, 150);
        self.arrowSize = CGSizeMake(16, 10);
        self.cornerRadius = 5.0;
        self.minMargin = 10.0;
        self.arrowMinMargin = 10.0;
        self.offset = 5.0;
        self.rectCorner = UIRectCornerAllCorners;        
        self.backgroundColor = [UIColor clearColor];
        self.backColor = [UIColor whiteColor];
        
        [self addSubview:self.maskView];
    }
    return self;
}
- (UIBezierPath *)bezierPathWithRect:(CGRect)rect
                          rectCorner:(UIRectCorner)rectCorner
                        cornerRadius:(CGFloat)cornerRadius
                           arrowSize:(CGSize)arrowSize
                       arrowPosition:(CGPoint)arrowPosition
                      arrowDirection:(WXHAlertViewArrowDirection)arrowDirection
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGFloat topRightRadius = 0,topLeftRadius = 0,bottomRightRadius = 0,bottomLeftRadius = 0;
    CGPoint topRightArcCenter,topLeftArcCenter,bottomRightArcCenter,bottomLeftArcCenter;
    
    if (rectCorner & UIRectCornerTopLeft) {
        topLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerTopRight) {
        topRightRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomLeft) {
        bottomLeftRadius = cornerRadius;
    }
    if (rectCorner & UIRectCornerBottomRight) {
        bottomRightRadius = cornerRadius;
    }
    
    if (arrowDirection == WXHAlertViewArrowDirectionUp) {
        topLeftArcCenter = CGPointMake(topLeftRadius + rect.origin.x,
                                       arrowSize.height + topLeftRadius + rect.origin.x);
        
        topRightArcCenter = CGPointMake(rect.size.width - topRightRadius + rect.origin.x,
                                        arrowSize.height + topRightRadius + rect.origin.x);
        
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + rect.origin.x,
                                          rect.size.height - bottomLeftRadius + rect.origin.x);
        
        bottomRightArcCenter = CGPointMake(rect.size.width - bottomRightRadius + rect.origin.x,
                                           rect.size.height - bottomRightRadius + rect.origin.x);
        
        [bezierPath moveToPoint:CGPointMake(arrowPosition.x - arrowSize.width / 2, arrowSize.height + rect.origin.x)];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition.x, rect.origin.y + rect.origin.x)];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition.x + arrowSize.width / 2, arrowSize.height + rect.origin.x)];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - topRightRadius, arrowSize.height + rect.origin.x)];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width + rect.origin.x, rect.size.height - bottomRightRadius - rect.origin.x)];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + rect.origin.x, rect.size.height + rect.origin.x)];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x, arrowSize.height + topLeftRadius + rect.origin.x)];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    } else if (arrowDirection == WXHAlertViewArrowDirectionDown) {
        
        topLeftArcCenter = CGPointMake(topLeftRadius + rect.origin.x,
                                       topLeftRadius + rect.origin.x);
        
        topRightArcCenter = CGPointMake(rect.size.width - topRightRadius + rect.origin.x,
                                        topRightRadius + rect.origin.x);
        
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + rect.origin.x,
                                          rect.size.height - bottomLeftRadius + rect.origin.x - arrowSize.height);
        
        bottomRightArcCenter = CGPointMake(rect.size.width - bottomRightRadius + rect.origin.x,
                                           rect.size.height - bottomRightRadius + rect.origin.x - arrowSize.height);

        
        [bezierPath moveToPoint:CGPointMake(arrowPosition.x + arrowSize.width / 2, rect.size.height - arrowSize.height + rect.origin.x)];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition.x, rect.size.height + rect.origin.x)];
        [bezierPath addLineToPoint:CGPointMake(arrowPosition.x - arrowSize.width / 2, rect.size.height - arrowSize.height + rect.origin.x)];
        
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + rect.origin.x, rect.size.height - arrowSize.height + rect.origin.x)];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x, topLeftRadius + rect.origin.x)];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - topRightRadius + rect.origin.x, rect.origin.x)];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width + rect.origin.x, rect.size.height - bottomRightRadius - rect.origin.x - arrowSize.height)];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    } else if (arrowDirection == WXHAlertViewArrowDirectionLeft) {
        topLeftArcCenter = CGPointMake(topLeftRadius + rect.origin.x + arrowSize.height,
                                       topLeftRadius + rect.origin.x);
        
        topRightArcCenter = CGPointMake(rect.size.width - topRightRadius + rect.origin.x,
                                        topRightRadius + rect.origin.x);
        
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + rect.origin.x + arrowSize.height,
                                          rect.size.height - bottomLeftRadius + rect.origin.x);
        
        bottomRightArcCenter = CGPointMake(rect.size.width - bottomRightRadius + rect.origin.x,
                                           rect.size.height - bottomRightRadius + rect.origin.x);

        [bezierPath moveToPoint:CGPointMake(arrowSize.height, arrowPosition.y + arrowSize.width / 2)];
        [bezierPath addLineToPoint:CGPointMake(0, arrowPosition.y)];
        [bezierPath addLineToPoint:CGPointMake(arrowSize.height, arrowPosition.y - arrowSize.width / 2)];
        
        [bezierPath addLineToPoint:CGPointMake(arrowSize.height + rect.origin.x, topLeftRadius + rect.origin.x)];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - topRightRadius, rect.origin.x)];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width + rect.origin.x, rect.size.height - bottomRightRadius - rect.origin.x)];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(arrowSize.height + bottomLeftRadius + rect.origin.x, rect.size.height + rect.origin.x)];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];

    } else if (arrowDirection == WXHAlertViewArrowDirectionRight) {
        topLeftArcCenter = CGPointMake(topLeftRadius + rect.origin.x,
                                       topLeftRadius + rect.origin.x);
        topRightArcCenter = CGPointMake(rect.size.width - topRightRadius + rect.origin.x - self.arrowSize.height,
                                        topRightRadius + rect.origin.x);
        bottomLeftArcCenter = CGPointMake(bottomLeftRadius + rect.origin.x,
                                          rect.size.height - bottomLeftRadius + rect.origin.x);
        bottomRightArcCenter = CGPointMake(rect.size.width - bottomRightRadius + rect.origin.x - arrowSize.height,
                                           rect.size.height - bottomRightRadius + rect.origin.x);

        [bezierPath moveToPoint:CGPointMake(rect.size.width - arrowSize.height, arrowPosition.y - arrowSize.width / 2)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width + rect.origin.x, arrowPosition.y)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - arrowSize.height, arrowPosition.y + arrowSize.width / 2)];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - arrowSize.height, rect.size.height - bottomRightRadius - rect.origin.x)];
        [bezierPath addArcWithCenter:bottomRightArcCenter radius:bottomRightRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(bottomLeftRadius + rect.origin.x, rect.size.height + rect.origin.x)];
        [bezierPath addArcWithCenter:bottomLeftArcCenter radius:bottomLeftRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.origin.x, arrowSize.height + topLeftRadius + rect.origin.x)];
        [bezierPath addArcWithCenter:topLeftArcCenter radius:topLeftRadius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
        
        [bezierPath addLineToPoint:CGPointMake(rect.size.width - topRightRadius + rect.origin.x - arrowSize.height, rect.origin.x)];
        [bezierPath addArcWithCenter:topRightArcCenter radius:topRightRadius startAngle:M_PI * 3 / 2 endAngle:2 * M_PI clockwise:YES];
    }
    [bezierPath closePath];
    return bezierPath;
}
#pragma mark - WXHAlertContainerDelegate
- (void)updateLayout
{
    CGRect sourceFrame =  [self.superview convertRect:self.popoverSourceFrame fromView:self.popoverSourceView.superview];
    
    CGRect superViewFrame = self.superview.frame;
    
    if (CGRectEqualToRect(superViewFrame, CGRectZero)) {
        return;
    }
    
    CGFloat arrow_x = 0;
    CGFloat arrow_y = 0;
    CGFloat offset_x = 0;
    CGFloat offset_y = 0;
    
    if (self.arrowDirection == WXHAlertViewArrowDirectionAuto) {
        //先判断上下的时候，箭头能不能放
        if (sourceFrame.origin.y + sourceFrame.size.height + self.contentSize.height + self.borderWidth * 2 + self.minMargin + self.arrowSize.height < superViewFrame.size.height) {
            self.arrowDirection = WXHAlertViewArrowDirectionUp;
        } else if (sourceFrame.origin.y - (self.contentSize.height + self.borderWidth * 2 + self.minMargin + self.arrowSize.height) - 100 > 0) {
            self.arrowDirection = WXHAlertViewArrowDirectionDown;
        } else if (sourceFrame.origin.x + sourceFrame.size.width + self.contentSize.width + self.borderWidth * 2 + self.minMargin + self.arrowSize.width < superViewFrame.size.width) {
            self.arrowDirection = WXHAlertViewArrowDirectionLeft;
        } else {
            self.arrowDirection = WXHAlertViewArrowDirectionRight;
        }
        
        CGFloat arrowMinMargin = self.cornerRadius > self.arrowMinMargin ? self.cornerRadius : self.arrowMinMargin;
        
        if (self.arrowDirection == WXHAlertViewArrowDirectionUp || self.arrowDirection == WXHAlertViewArrowDirectionDown) {
            arrow_x = sourceFrame.origin.x + sourceFrame.size.width/2;
            offset_x = arrow_x - self.contentSize.width/2 - self.borderWidth;
            
            if (offset_x < self.minMargin) {
                offset_x = self.minMargin;
            } else if (offset_x > superViewFrame.size.width - self.contentSize.width - self.minMargin - self.borderWidth) {
                offset_x = superViewFrame.size.width - self.contentSize.width - self.minMargin - self.borderWidth;
            }
            
            arrow_x = arrow_x - offset_x;
            //当箭头离左边距离不在中心点，就往左边移一点
            if (arrow_x < arrowMinMargin + self.arrowSize.width/2) {
                arrow_x = arrowMinMargin + self.arrowSize.width/2;
                
                //左移之后已经超出了按钮的大小，就只能把箭头指向左边
                if (arrow_x + offset_x < sourceFrame.origin.x || arrow_x + offset_x > sourceFrame.origin.x + sourceFrame.size.width) {
                    self.arrowDirection = WXHAlertViewArrowDirectionLeft;
                }
            } else if (arrow_x > self.contentSize.width + self.borderWidth * 2 - arrowMinMargin -  self.arrowSize.width/2) {
                
                arrow_x = self.contentSize.width + self.borderWidth * 2 - arrowMinMargin -  self.arrowSize.width/2;
                
                //右移之后已经超出了按钮的大小，就这孩子能把箭头指向右边
                if (arrow_x + offset_x < sourceFrame.origin.x || arrow_x + offset_x > sourceFrame.origin.x + sourceFrame.size.width) {
                    self.arrowDirection = WXHAlertViewArrowDirectionRight;
                }
            }
        }
        if (self.arrowDirection == WXHAlertViewArrowDirectionLeft || self.arrowDirection == WXHAlertViewArrowDirectionRight){
            arrow_y = sourceFrame.origin.y + sourceFrame.size.height / 2;
            offset_y = arrow_y - self.contentSize.height / 2 - self.borderWidth;
            
            if (offset_y < self.minMargin) {
                offset_y = self.minMargin;
            } else if (offset_y > superViewFrame.size.height - self.contentSize.height - self.minMargin - self.borderWidth) {
                offset_y = superViewFrame.size.height - self.contentSize.height - self.minMargin - self.borderWidth;
            }
            
            arrow_y = arrow_y - offset_y;
            if (arrow_y < arrowMinMargin + self.arrowSize.width/2) {
                arrow_y = arrowMinMargin + self.arrowSize.width/2;
            } else if (arrow_y > self.contentSize.height + self.borderWidth * 2 - arrowMinMargin -  self.arrowSize.width/2) {
                arrow_y = self.contentSize.height + self.borderWidth * 2 - arrowMinMargin -  self.arrowSize.width/2;
            }
        }
    }
    
    if (self.arrowDirection == WXHAlertViewArrowDirectionUp) {
        offset_y = sourceFrame.origin.y + sourceFrame.size.height + self.offset;
        arrow_y = 0;
        
        self.frame = CGRectMake(offset_x,
                                offset_y,
                                self.contentSize.width + self.borderWidth * 2,
                                self.contentSize.height + self.borderWidth * 2 + self.arrowSize.height);
        
        self.contentView.frame = CGRectMake(self.borderWidth,
                                            self.arrowSize.height + self.borderWidth,
                                            self.contentSize.width,
                                            self.contentSize.height);
        
    } else if (self.arrowDirection == WXHAlertViewArrowDirectionDown) {
        offset_y = sourceFrame.origin.y - self.offset - self.contentSize.height - self.borderWidth * 2 - self.arrowSize.height;
        arrow_y = self.contentSize.height + self.arrowSize.height + self.borderWidth * 2;
        
        self.frame = CGRectMake(offset_x,
                                offset_y,
                                self.contentSize.width + self.borderWidth * 2,
                                self.contentSize.height + self.borderWidth * 2 + self.arrowSize.height);
        
        self.contentView.frame = CGRectMake(self.borderWidth,
                                            self.borderWidth,
                                            self.contentSize.width,
                                            self.contentSize.height);
        
    } else if (self.arrowDirection == WXHAlertViewArrowDirectionLeft) {
        offset_x = sourceFrame.origin.x + sourceFrame.size.width + self.offset;
        arrow_x = 0;
        
        self.frame = CGRectMake(offset_x,
                                offset_y,
                                self.contentSize.width + self.borderWidth * 2 + self.arrowSize.height,
                                self.contentSize.height + self.borderWidth * 2);
        
        self.contentView.frame = CGRectMake(self.borderWidth + self.arrowSize.height,
                                            self.borderWidth,
                                            self.contentSize.width,
                                            self.contentSize.height);
        
    } else if (self.arrowDirection == WXHAlertViewArrowDirectionRight) {
        offset_x = sourceFrame.origin.x - self.offset - self.contentSize.width - self.borderWidth * 2 - self.arrowSize.height;
        arrow_x = self.contentSize.width + self.arrowSize.height + self.borderWidth * 2;
        
        self.frame = CGRectMake(offset_x,
                                offset_y,
                                self.contentSize.width + self.borderWidth * 2 + self.arrowSize.height,
                                self.contentSize.height + self.borderWidth * 2);
        
        self.contentView.frame = CGRectMake(self.borderWidth,
                                            self.borderWidth,
                                            self.contentSize.width,
                                            self.contentSize.height);
    }
    self.arrowPosition = CGPointMake(arrow_x, arrow_y);    
    self.bezierPath = [self bezierPathWithRect:self.bounds
                                    rectCorner:self.rectCorner
                                  cornerRadius:self.cornerRadius
                                     arrowSize:self.arrowSize
                                 arrowPosition:self.arrowPosition
                                arrowDirection:self.arrowDirection];
    
    self.maskShapeLayer.path = self.bezierPath.CGPath;
}
- (void)drawRect:(CGRect)rect
{
    self.bezierPath.lineWidth = self.borderWidth;
    
    if (self.borderColor) {
        [self.borderColor setStroke];
    }
    if (self.backColor) {
        [self.backColor setFill];
    }
    
    [self.bezierPath fill];
    [self.bezierPath stroke];
}
- (void)setContentSize:(CGSize)size
{
    _contentSize = size;
    [self setNeedsDisplay];
}
- (void)setContentView:(UIView *)view
{
    if (_contentView != view) {
        if (_contentView) {
            [_contentView removeFromSuperview];
        }
        _contentView = view;
        [self.maskView addSubview:_contentView];
    }
    [self updateLayout];
}
- (CAAnimation *)appearAnimation
{
    CGPoint center = self.center;
    CGPoint arrowPosition = [self.superview convertPoint:self.arrowPosition fromView:self];
    
    CAAnimationGroup *animatGroup = [CAAnimationGroup animation];
    CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animatScale.fromValue = @(0.0);
    animatScale.toValue = @(1.0);
    
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.fromValue = @(0.0);
    animatOpacity.toValue = @(1.0);
    
    CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatPosition.fromValue = [NSValue valueWithCGPoint:arrowPosition];
    animatPosition.toValue = [NSValue valueWithCGPoint:center];
    
    animatGroup.animations = @[animatScale,animatOpacity,animatPosition];
    animatGroup.duration = 0.1;
    animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatGroup.fillMode = kCAFillModeForwards;
    animatGroup.removedOnCompletion = NO;
    return animatGroup;
}
- (CAAnimation *)disappearAnimation
{
    CGPoint arrowPosition = [self.superview convertPoint:self.arrowPosition fromView:self];
    
    CAAnimationGroup *animatGroup = [CAAnimationGroup animation];
    CABasicAnimation *animatScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animatScale.toValue = @(0.1);
    
    CABasicAnimation *animatOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatOpacity.toValue = @(0);
    
    CABasicAnimation *animatPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animatPosition.toValue = [NSValue valueWithCGPoint:arrowPosition];
    
    animatGroup.animations = @[animatScale,animatOpacity,animatPosition];
    animatGroup.duration = 0.1;
    animatGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animatGroup.fillMode = kCAFillModeForwards;
    animatGroup.removedOnCompletion = NO;
    return animatGroup;
}

- (CAShapeLayer *)maskShapeLayer
{
    if (!_maskShapeLayer) {
        _maskShapeLayer = [CAShapeLayer layer];
    }
    return _maskShapeLayer;
}
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        [_maskView.layer setMask:self.maskShapeLayer];
    }
    return _maskView;
}
@end
