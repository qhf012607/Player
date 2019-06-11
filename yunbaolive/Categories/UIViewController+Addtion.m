//
//  UIViewController+Addtion.m
//  QCColumbus
//
//  Created by HeDong on 16/9/18.
//  Copyright © 2016年 Quancheng-ec. All rights reserved.
//

#import "UIViewController+Addtion.h"
#import <objc/runtime.h>

@implementation UIViewController (Addtion)
- (void)setHiddenNav:(BOOL)hiddenNav{
    objc_setAssociatedObject(self, @selector(hiddenNav), @(hiddenNav), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hiddenNav{
    return [(NSNumber *)objc_getAssociatedObject(self, @selector(hiddenNav)) boolValue];
}

- (void)setIdentifier:(NSString *)identifier{
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)identifier{
    return objc_getAssociatedObject(self, @selector(identifier));
}


@end
