//
//  ViewController.m
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "ViewController.h"
#import "WXHAlertController.h"
#import "WXHAlertView.h"
#import "WXHActionSheetView.h"
#import "WXHPopoverView.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UINavigationController *nav;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    [self addChildViewController:self.nav];
    [self.view addSubview:self.nav.view];
    [self.view sendSubviewToBack:self.nav.view];
}

- (IBAction)typeButtonAction:(id)sender {
    UIButton *button = sender;
    UIView<WXHAlertContainerDelegate> *containerView;
    if (button.tag == 0) {
        containerView = [[WXHActionSheetView alloc] init];
    } else if (button.tag == 1){
        containerView = [[WXHAlertView alloc] init];
    } else if (button.tag == 2) {
        WXHPopoverView *popoverView = [[WXHPopoverView alloc] init];
        popoverView.arrowSize = CGSizeMake(30, 15);
        popoverView.arrowColor = [UIColor brownColor];
        popoverView.popverSourceView = button;
        popoverView.popoverSourceFrame = button.frame;
        containerView = popoverView;
    }
    [self showView:self.contentView
         container:containerView
          maskType:WXHAlertMaskViewTypeBlur];
}
- (IBAction)backgroundButtonAction:(id)sender {
    UIButton *button = sender;
    
    UIView<WXHAlertContainerDelegate> *containerView = [[WXHAlertView alloc] init];
    
    [self showView:self.contentView
         container:containerView
          maskType:button.tag];
}

- (IBAction)popoverAction:(id)sender
{
    UIButton *button = sender;
    UIView<WXHAlertContainerDelegate> *containerView;
    WXHPopoverView *popoverView = [[WXHPopoverView alloc] init];
    popoverView.arrowSize = CGSizeMake(30, 15);
    popoverView.arrowColor = self.contentView.backgroundColor;
    popoverView.popverSourceView = button;
    popoverView.popoverSourceFrame = button.frame;
    containerView = popoverView;
    
    [self showView:self.contentView
         container:containerView
          maskType:WXHAlertMaskViewTypeNone];
}
- (void)showView:(UIView *)view
       container:(UIView<WXHAlertContainerDelegate> *)containerView
        maskType:(WXHAlertMaskViewType)type
{
    WXHAlertController *alertController = [[WXHAlertController alloc] initWithContainer:containerView];
    alertController.contentSize = CGSizeMake(200, 200);
    alertController.contentView = view;
    alertController.maskViewType = type;
    [alertController show:nil];
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor brownColor];
        _contentView.layer.cornerRadius = 10.0f;
        _contentView.clipsToBounds = YES;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:35.0f];
        label.text = @"测试";
        [_contentView addSubview:label];
    }
    return _contentView;
}

@end
