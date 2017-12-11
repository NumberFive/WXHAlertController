//
//  WXHAlertMaskView.m
//  Demo
//
//  Created by 伍小华 on 2017/12/6.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHAlertMaskView.h"
@interface WXHAlertMaskView()
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, assign) NSInteger clicedIndex;
@end
@implementation WXHAlertMaskView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.color = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapDidAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _visualEffectView.frame = self.bounds;
}
- (void)tapDidAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertMaskViewDidTap)]) {
        [self.delegate alertMaskViewDidTap];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.type == WXHAlertMaskViewTypeNone) {
        if (self.clicedIndex % 2 == 0) {
            [self tapDidAction];
        }
        self.clicedIndex++;
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark - Setter / Getter
- (void)setType:(WXHAlertMaskViewType)type
{
    if (type == WXHAlertMaskViewTypeBlur) {
        self.backgroundColor = [UIColor clearColor];
        self.visualEffectView.frame = self.bounds;
    } else {
        [_visualEffectView removeFromSuperview];
        _visualEffectView = nil;
        if (type == WXHAlertMaskViewTypeNone) {
            self.backgroundColor = [UIColor clearColor];
        } else {
            self.backgroundColor = self.color;
        }
    }
    _type = type;
}
- (UIVisualEffectView *)visualEffectView
{
    if (!_visualEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.alpha = 0.8;
        [self addSubview:self.visualEffectView];
    }
    return _visualEffectView;
}
@end
