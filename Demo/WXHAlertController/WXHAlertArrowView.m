//
//  WXHAlertArrowView.m
//  Demo
//
//  Created by 伍小华 on 2017/12/8.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHAlertArrowView.h"

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
    if (self.arrowDirection == WXHAlertViewArrowDirectionNone) {
        [super drawRect:rect];
    } else {
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
}

@end
