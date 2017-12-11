//
//  WXHAlertMaskView.h
//  Demo
//
//  Created by 伍小华 on 2017/12/6.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WXHAlertMaskViewType) {
    WXHAlertMaskViewTypeDefault = 0,
    WXHAlertMaskViewTypeNone,
    WXHAlertMaskViewTypeBlur,
};
@protocol WXHAlertMaskViewDelegate<NSObject>
- (void)alertMaskViewDidTap;
@end
@interface WXHAlertMaskView : UIView
@property (nonatomic, assign) WXHAlertMaskViewType type;
@property (nonatomic, weak) id<WXHAlertMaskViewDelegate> delegate;
@property (nonatomic, strong) UIColor *color;
@end
