//
//  WXHAlertContainerDelegate.h
//  Demo
//
//  Created by 伍小华 on 2017/12/12.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXHAlertContainerDelegate <NSObject>
- (void)updateLayout;

- (CAAnimation *)appearAnimation;
- (CAAnimation *)disappearAnimation;

- (void)setContentSize:(CGSize)size;
- (void)setContentView:(UIView *)view;
@end
