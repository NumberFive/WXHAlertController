//
//  WXHPopoverView.h
//  Demo
//
//  Created by 伍小华 on 2017/12/12.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHAlertContainerDelegate.h"
typedef NS_ENUM(NSInteger, WXHAlertViewArrowDirection) {
    WXHAlertViewArrowDirectionAuto = 0,//先上，后下，再左，最后右
    WXHAlertViewArrowDirectionUp,
    WXHAlertViewArrowDirectionDown,
    WXHAlertViewArrowDirectionLeft,
    WXHAlertViewArrowDirectionRight,
};

@interface WXHPopoverView : UIView<WXHAlertContainerDelegate>

@property (nonatomic, weak) UIView *popoverSourceView;
@property (nonatomic, assign) CGRect popoverSourceFrame;

@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat offset;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) UIRectCorner rectCorner;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) WXHAlertViewArrowDirection arrowDirection;

@property (nonatomic, assign) CGSize arrowSize;

@property (nonatomic, assign) CGFloat minMargin;
@property (nonatomic, assign) CGFloat arrowMinMargin;
@end
