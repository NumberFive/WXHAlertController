//
//  WXHActionSheetView.h
//  Demo
//
//  Created by 伍小华 on 2017/12/12.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXHAlertContainerDelegate.h"
@interface WXHActionSheetView : UIView<WXHAlertContainerDelegate>
@property (nonatomic, assign) CGFloat bottomOffset;
@end
