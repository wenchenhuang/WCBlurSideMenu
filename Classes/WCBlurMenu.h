//
//  WCBlurMenu.h
//  WCBlurSideMenu
//
//  Created by huangwenchen on 15/5/19.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WCBlurMenuType) {
    WCBlurMenuTypeFull,
    WCBlurMenuTypeDefault,
};

@protocol WCBlurMenuDelegate<NSObject>
@optional
-(void)didStartShowWCBlurMenu;
-(void)didEndShowWCBlurMenu;
-(void)didStartDismissWCBlurMenu;
-(void)didEndDismissWCblueMenu;
@end

@interface WCBlurMenu : UIViewController

-(void)showMenu;
-(void)HideMenu;

-(instancetype)initWithContenetViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;
//-(instancetype)initWithContenetViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController BlurType:(WCBlurMenuType)type;

@property (strong,nonatomic)UIViewController * contentViewController;
@property (strong,nonatomic)UIViewController * menuViewController;
//@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) WCBlurMenuType blurtype;
@property (weak,nonatomic) id<WCBlurMenuDelegate> delegate;

@end
