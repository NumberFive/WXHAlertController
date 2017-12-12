//
//  WXHPopoverView.h
//  Demo
//
//  Created by 伍小华 on 2017/12/12.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHAlertContainerDelegate.h"
@interface WXHPopoverView : UIView<WXHAlertContainerDelegate>
@property (nonatomic, weak) UIView *popverSourceView;
@property (nonatomic, assign) CGRect popoverSourceFrame;
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, assign) CGSize arrowSize;
@property (nonatomic, assign) CGFloat margin;
@end
