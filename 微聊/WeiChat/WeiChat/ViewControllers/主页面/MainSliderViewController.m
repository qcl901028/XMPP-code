//
//  MainSliderViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "MainSliderViewController.h"
#import "MainTabBarViewController.h"
#import "SettingViewController.h"
@interface MainSliderViewController ()

@end

@implementation MainSliderViewController

- (void)viewDidLoad {
    [self createViewController];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)createViewController{
    //主页面
    MainTabBarViewController*mainVc=[[MainTabBarViewController alloc]init];
    self.MainVC=mainVc;
    //左边
    SettingViewController*leftVc=[[SettingViewController alloc]init];
    self.LeftVC=leftVc;

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
