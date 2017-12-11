//
//  WXHAlertView.h
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHAlertArrowView.h"
@class WXHAlertController;
@interface WXHAlertView : UIView
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WXHAlertArrowView *arrowView;
@property (nonatomic, strong) WXHAlertController *alertController;
@end
