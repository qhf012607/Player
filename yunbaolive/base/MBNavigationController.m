//
//  QCNavigationController.m
//  QCColumbus
//
//  Created by Chen on 15/4/8.
//  Copyright (c) 2015年 Quancheng-ec. All rights reserved.
//

#import "MBNavigationController.h"
#import <objc/runtime.h>
#import "UIBarButtonItem+Helper.h"
#import "UIViewController+Addtion.h"
#import "UIImage+Additions.h"
@interface MBNavigationController () <UINavigationControllerDelegate,UINavigationBarDelegate, UIGestureRecognizerDelegate>

@end

@implementation MBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak MBNavigationController *weakSelf = self;
    [self.navigationBar setTranslucent:NO];
    self.interactivePopGestureRecognizer.delegate = weakSelf;
    self.delegate = weakSelf;
    [self.navigationBar setBarTintColor: RGB(255, 255, 255)];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:RGB(255, 255, 255) size:CGSizeMake([UIScreen mainScreen].bounds.size.width, 1)]];
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"person_back_black"];
    self.navigationBar.backIndicatorTransitionMaskImage =[UIImage imageNamed:@"person_back_black"];
    self.navigationBar.tintColor=[UIColor whiteColor];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    [self popSelf];
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated enablePopGesture:(BOOL)enablePopGesture {
    _enablePopGesture = enablePopGesture;
   
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    [super pushViewController:viewController animated:animated];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//
//    [viewController.navigationItem.backBarButtonItem setTitle:@""];
//    if(viewController.hiddenNav){
//        [self setNavigationBarHidden:YES animated:YES];
//    }else{
//        [self setNavigationBarHidden:NO animated:YES];
//    }
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //此处设置大于0或者等于1都可以
    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [self pushViewController:viewController animated:animated enablePopGesture:YES];
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    _enablePopGesture = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    _enablePopGesture = YES;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)popSelf {
    if (self.topViewController && [self.topViewController respondsToSelector:@selector(willPopSelf)]) {
        [self.topViewController performSelector:@selector(willPopSelf)];
    }
    [self popViewControllerAnimated:YES];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && _enablePopGesture) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }

    return YES;
}
#pragma mark EnableGestureRecognizer
- (void)enableGestureRecognizer:(BOOL)enable {
    if (enable) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    } else {
        self.enablePopGesture = NO;
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}
@end

@implementation UINavigationController (Identifier)

- (NSString *)identifier
{
    return objc_getAssociatedObject(self, @selector(identifier));
}

- (void)setIdentifier:(NSString *)identifier
{
    [self willChangeValueForKey:@"identifier"];
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"identifier"];
}

@end

@implementation UIViewController (popSupporting)

- (void)willPopSelf
{
    
}

@end
