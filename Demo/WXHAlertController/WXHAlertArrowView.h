//
//  WXHAlertArrowView.h
//  Demo
//
//  Created by 伍小华 on 2017/12/8.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WXHAlertViewArrowDirection) {
    WXHAlertViewArrowDirectionNone = 0,
    WXHAlertViewArrowDirectionUp,
    WXHAlertViewArrowDirectionDown,
};
@interface WXHAlertArrowView : UIView
@property (nonatomic, assign) WXHAlertViewArrowDirection arrowDirection;
@property (nonatomic, strong) UIColor *arrowColor;
@end
