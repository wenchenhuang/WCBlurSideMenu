//
//  RootViewController.m
//  WCBlurSideMenuExample
//
//  Created by huangwenchen on 15/5/20.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import "RootViewController.h"
#import "MenuViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

-(void)awakeFromNib{
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuvc"];
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"navvc"];
    self.blurtype = WCBlurMenuTypeDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
