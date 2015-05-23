//
//  WCBlurMenu.m
//  WCBlurSideMenu
//
//  Created by huangwenchen on 15/5/19.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "WCBlurMenu.h"
#import "UIImage+ImageEffects.h"

@interface WCBlurMenu ()

@property (strong,nonatomic)UIView * contentView;
@property (strong,nonatomic)UIView * menuView;
@property (strong,nonatomic)UIImageView * contentBackgroundImageview;
@property (strong,nonatomic)UIImageView * menuBackgronhdImageview;
@property (strong,nonatomic)UIButton * contentButton;
@property (strong,nonatomic)UIPanGestureRecognizer * gestureRecognizer;
@end

@implementation WCBlurMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    //Add contentView
    [self addChildViewController:self.contentViewController];
    [self.contentViewController didMoveToParentViewController:self];
    self.contentView = self.contentViewController.view;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.frame = self.view.frame;
    
    //Add menuView
    [self addChildViewController:self.menuViewController];
    [self.menuViewController didMoveToParentViewController:self];
    self.menuView  = self.menuViewController.view;
    self.menuView.frame = CGRectOffset(self.view.frame, -1 * CGRectGetWidth(self.view.frame), 0);
    self.menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.menuView.alpha = 1.0;
    self.menuView.hidden = NO;
    self.menuView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.menuView];
    self.contentButton = ({
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectNull];
        [button addTarget:self action:@selector(hideMenuViewController) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    self.gestureRecognizer = ({
        UIScreenEdgePanGestureRecognizer * gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(catchScreenEdgePan:)];
        gesture.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:gesture];
        gesture;
    });
}
//Handle edge pan gesture
-(void)catchScreenEdgePan:(UIScreenEdgePanGestureRecognizer *)gesture{
    CGPoint  translation;
    CGPoint velocity;
    CGRect originFrame = CGRectOffset(self.view.frame, -1 * CGRectGetWidth(self.view.frame), 0);
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self addBlurBackground];
            self.menuView.hidden = NO;
            break;
        case UIGestureRecognizerStateChanged:
            translation = [gesture translationInView:self.view];
            self.menuView.frame = CGRectOffset(originFrame, MIN(translation.x, [self maxOffset] + 10),0);
            self.menuView.alpha = [self alphaWithOffset:translation.x];
            self.contentBackgroundImageview.alpha = [self alphaWithOffset:translation.x];
            break;
        case UIGestureRecognizerStateEnded:
           velocity = [gesture velocityInView:self.view];
            if (velocity.x > 0) {
                [self showMenu];
            }else{
                [self HideMenu];
            }
            break;
        default:
            break;
    }
}
#pragma mark - private method

-(CGFloat)alphaWithOffset:(CGFloat)offest{
    return MAX(MIN(1.0, offest/[self maxOffset]),0.0);
}
-(CGFloat)maxOffset{
    return CGRectGetWidth(self.menuView.frame) * 0.5;
}
-(void)hideMenuViewController{
    [self HideMenu];
}
-(void)addBlurBackground{
    if (self.contentBackgroundImageview.superview == nil) {
        [self.contentView addSubview:self.contentBackgroundImageview];
    }
}
-(UIImageView *)contentBackgroundImageview{
    if (!_contentBackgroundImageview) {
        _contentBackgroundImageview = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        UIImage * image = [self blurredSnapshotWithFrame:self.contentView.bounds BlurType:self.blurtype];
        _contentBackgroundImageview.image = image;
        _contentBackgroundImageview.autoresizingMask = UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleWidth;
        _contentBackgroundImageview.alpha = 0.0;
    }
    return _contentBackgroundImageview;
}
- (void)addContentButton
{
    if (self.contentButton.superview)
        return;
    
    self.contentButton.autoresizingMask = UIViewAutoresizingNone;
    self.contentButton.frame = self.contentView.bounds;
    self.contentButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:self.contentButton];
}

-(void)removeContentButton{
    if (self.contentButton.superview == nil) {
        return;
    }
    [self.contentButton removeFromSuperview];
}
#pragma mark -  API

-(void)showMenu{
    self.menuView.hidden = NO;
    [self.menuViewController beginAppearanceTransition:YES animated:YES];
    CGRect originFrame = CGRectOffset(self.view.frame, -1 * CGRectGetWidth(self.view.frame), 0);
    
    [self addBlurBackground];
    if ([self.delegate respondsToSelector:@selector(didStartShowWCBlurMenu)]) {
        [self.delegate didStartShowWCBlurMenu];
    }
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.menuView.alpha = 1.0;
                         self.menuView.frame =CGRectOffset(originFrame, [self maxOffset], 0);
                         self.contentBackgroundImageview.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self addContentButton];
                         if ([self.delegate respondsToSelector:@selector(didEndShowWCBlurMenu)]) {
                             [self.delegate didEndShowWCBlurMenu];
                         }
                     }];
}
-(void)HideMenu{
    if ([self.delegate respondsToSelector:@selector(didStartDismissWCBlurMenu)]) {
        [self.delegate didStartDismissWCBlurMenu];
    }
    CGRect originFrame = CGRectOffset(self.view.frame, -1 * CGRectGetWidth(self.view.frame), 0);
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         self.menuView.alpha = 0.0;
                         self.menuView.frame =originFrame;
                         self.contentBackgroundImageview.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         self.menuView.hidden = YES;
                         [self removeContentButton];
                         [self.contentBackgroundImageview removeFromSuperview];
                         self.contentBackgroundImageview = nil;
                         if ([self.delegate respondsToSelector:@selector(didEndDismissWCblueMenu)]) {
                             [self.delegate didEndDismissWCblueMenu];
                         }
                     }];
}
-(instancetype)initWithContenetViewController:(UIViewController *)contentViewController MenuViewController:(UIViewController *)menuViewController{
    return [self initWithContenetViewController:contentViewController MenuViewController:menuViewController BlurType:WCBlurMenuBlurTypeDark];
}
-(instancetype)initWithContenetViewController:(UIViewController *)contentViewController MenuViewController:(UIViewController *)menuViewController BlurType:(WCBlurMenuBlurType)type{
    if (self = [super init]) {
        _contentViewController = contentViewController;
        _menuViewController = menuViewController;
        _blurtype = type;
        
    }
    return self;
}
#pragma mark - Snapshot
- (UIImage *)blurredSnapshotWithFrame:(CGRect)frame BlurType:(WCBlurMenuBlurType)type{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 1.0f);
    [self.contentView drawViewHierarchyInRect:frame afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage;
    switch (type) {
        case WCBlurMenuBlurTypeDark:
            blurredSnapshotImage = [snapshotImage applyDarkEffect];
            break;
        case WCBlurMenuBlurTypeExtraLight:
            blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
            break;
        case WCBlurMenuBlurTypeLight:
            blurredSnapshotImage = [snapshotImage applyLightEffect];
            break;
        default:
            break;
    }

    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}
#pragma mark - handle device rotate

-(BOOL)shouldAutorotate{
    return NO;
}


@end
