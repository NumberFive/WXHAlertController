//
//  WXHAlertController.h
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXHAlertView.h"
#import "WXHAlertMaskView.h"

typedef NS_ENUM(NSInteger, WXHAlertControllerStyle) {
    WXHAlertControllerStyleAlert = 0,
    WXHAlertControllerStyleActionSheet,
    WXHAlertControllerStylePopover,
};


typedef void (^WXHAlertBlock)(void);

@interface WXHAlertController : NSObject
@property (nonatomic, assign) WXHAlertControllerStyle style;

@property (nonatomic, strong) WXHAlertMaskView *maskView;
@property (nonatomic, assign) WXHAlertMaskViewType maskViewType;
@property (nonatomic, strong) UIColor *maskViewColor;
@property (nonatomic, copy) WXHAlertBlock maskViewDidTapBlock;

@property (nonatomic, strong) WXHAlertView *alertView;
@property (nonatomic, strong) UIColor *arrowColor;

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGFloat alertOffset;

@property (nonatomic, strong) CAAnimation *appearAnimation;
@property (nonatomic, strong) CAAnimation *disappearAnimation;

@property (nonatomic, weak) UIView *popverSourceView;
@property (nonatomic, assign) CGRect popoverSourceFrame;
@property (nonatomic, assign, readonly) BOOL isShow;
@property (nonatomic, assign) CGSize arrowSize;

- (void)setContentView:(UIView *)contentView;

- (void)show:(WXHAlertBlock)finished;
- (void)showOnView:(UIView *)view complete:(WXHAlertBlock)finished;
- (void)dismiss:(WXHAlertBlock)finished;
@end
