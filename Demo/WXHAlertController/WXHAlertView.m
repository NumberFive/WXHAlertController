//
//  WXHAlertView.m
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHAlertView.h"
@interface WXHAlertView ()

@end
@implementation WXHAlertView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.arrowView];
        [self addSubview:self.containerView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
    self.contentView.frame = self.containerView.bounds;
}
- (void)dealloc
{
    NSLog(@"WXHAlertView dealloc");
}

#pragma mark - Setter / Getter
- (void)setContentView:(UIView *)contentView
{
    if (_contentView != contentView) {
        if (_contentView) {
            [_contentView removeFromSuperview];
        }
        _contentView = contentView;
        contentView.frame = self.bounds;
        [self.containerView addSubview:contentView];
    }
}
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
- (void)setArrowDirection:(WXHAlertViewArrowDirection)arrowDirection
{
    self.arrowView.arrowDirection = arrowDirection;
    if (arrowDirection == WXHAlertViewArrowDirectionNone) {
        self.arrowView.hidden = YES;
    } else {
        self.arrowView.hidden = NO;
    }
}
- (WXHAlertArrowView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[WXHAlertArrowView alloc] init];
        _arrowView.alpha = 0.8;
        _arrowView.backgroundColor = [UIColor clearColor];
    }
    return _arrowView;
}
@end
