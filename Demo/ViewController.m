//
//  ViewController.m
//  Demo
//
//  Created by 伍小华 on 2017/12/5.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "ViewController.h"
#import "WXHAlertController.h"

@interface ViewController ()
@property (nonatomic, strong) WXHAlertController *alertController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    [self.view sendSubviewToBack:nav.view];
}

- (IBAction)typeButtonAction:(id)sender {
    UIButton *button = sender;
    WXHAlertController *alertController = [[WXHAlertController alloc] init];
    alertController.contentSize = CGSizeMake(200, 200);

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor brownColor];

    alertController.contentView = view;
    alertController.arrowColor = view.backgroundColor;
    alertController.style = button.tag;
    alertController.popverSourceView = sender;
    alertController.maskViewType = WXHAlertMaskViewTypeBlur;
    
    alertController.alertView.containerView.layer.cornerRadius = 10.0f;
    alertController.alertView.containerView.clipsToBounds = YES;
    [alertController show:nil];
    
//    self.alertController.style = button.tag;
//    self.alertController.popverSourceView = sender;
//    [self.alertController show:nil];
}
- (IBAction)backgroundButtonAction:(id)sender {
    UIButton *button = sender;
    
    WXHAlertController *alertController = [[WXHAlertController alloc] init];
    alertController.contentSize = CGSizeMake(200, 150);

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor brownColor];

    alertController.contentView = view;
    alertController.arrowColor = view.backgroundColor;

    alertController.style = WXHAlertControllerStyleAlert;
    alertController.maskViewType = button.tag;
    alertController.popverSourceView = button;
    
    alertController.alertView.containerView.layer.cornerRadius = 10.0f;
    alertController.alertView.containerView.clipsToBounds = YES;
    [alertController show:nil];
    
//    self.alertController.style = WXHAlertControllerStyleAlert;
//    self.alertController.maskViewType = button.tag;
//    self.alertController.popverSourceView = sender;
//    [self.alertController show:nil];
}

- (IBAction)popoverAction:(id)sender
{
    WXHAlertController *alertController = [[WXHAlertController alloc] init];
    alertController.contentSize = CGSizeMake(200, 150);

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor brownColor];

    alertController.contentView = view;
    alertController.arrowColor = view.backgroundColor;

    alertController.style = WXHAlertControllerStylePopover;
    alertController.maskViewType = WXHAlertMaskViewTypeNone;
    alertController.alertView.containerView.layer.cornerRadius = 10.0f;
    alertController.alertView.containerView.clipsToBounds = YES;
    
    alertController.popverSourceView = sender;
    [alertController showOnView:self.view complete:nil];
    
//    if (self.alertController.isShow) {
//        [self.alertController dismiss:^{
//            self.alertController.style = WXHAlertControllerStylePopover;
//            self.alertController.maskViewType = WXHAlertMaskViewTypeNone;
//            self.alertController.popverSourceView = sender;
//            [self.alertController show:nil];
//        }];
//    } else {
//        self.alertController.style = WXHAlertControllerStylePopover;
//        self.alertController.maskViewType = WXHAlertMaskViewTypeNone;
//        self.alertController.popverSourceView = sender;
//        [self.alertController show:nil];
//    }
}


- (WXHAlertController *)alertController
{
    if (!_alertController) {
        _alertController = [[WXHAlertController alloc] init];
        _alertController.contentSize = CGSizeMake(200, 200);
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blueColor];
        
        _alertController.contentView = view;
        _alertController.arrowColor = [UIColor redColor];
    }
    return _alertController;
}



@end
