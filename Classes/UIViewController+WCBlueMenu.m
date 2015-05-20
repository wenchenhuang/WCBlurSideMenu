//
//  UIViewController+WCBlueMenu.m
//  WCBlurSideMenuExample
//
//  Created by huangwenchen on 15/5/20.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "UIViewController+WCBlueMenu.h"

@implementation UIViewController (WCBlueMenu)
- (WCBlurMenu *)blurMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[WCBlurMenu class]]) {
            return (WCBlurMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
