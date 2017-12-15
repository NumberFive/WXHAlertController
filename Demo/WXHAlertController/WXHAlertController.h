//
//  WXHAlertController.h
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXHAlertMaskView.h"
#import "WXHAlertContainerDelegate.h"

typedef void (^WXHAlertBlock)(void);

@interface WXHAlertController : NSObject
@property (nonatomic, assign, readonly) BOOL isShow;
@property (nonatomic, assign, readonly) BOOL isAppearAnimationing;
@property (nonatomic, assign, readonly) BOOL isDisappearAnimationing;
@property (nonatomic, assign) BOOL dismissWhenMaskViewDidTap;

- (instancetype)initWithContainer:(UIView<WXHAlertContainerDelegate> *)container;
- (void)setContentView:(UIView *)contentView;
- (void)setContentSize:(CGSize)contentSize;

- (void)setMaskViewColor:(UIColor *)maskViewColor;
- (void)setMaskViewType:(WXHAlertMaskViewType)maskViewType;
- (void)setMaskViewDidTapBlock:(WXHAlertBlock)block;

- (void)show:(WXHAlertBlock)finished;
- (void)showOnView:(UIView *)view
          complete:(WXHAlertBlock)finished;
- (void)showOnView:(UIView *)view
      aboveSubview:(UIView *)subview
          complete:(WXHAlertBlock)finished;
- (void)showOnView:(UIView *)view
      belowSubview:(UIView *)subview
          complete:(WXHAlertBlock)finished;

- (void)dismiss:(WXHAlertBlock)finished;
@end
