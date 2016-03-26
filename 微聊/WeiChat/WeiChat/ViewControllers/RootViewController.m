//
//  RootViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTheme];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createTheme) name:THEME object:nil];
    // Do any additional setup after loading the view.
}
-(void)createTheme{
//读取当前主题
    NSString*theme=[[NSUserDefaults standardUserDefaults]objectForKey:THEME];
//拼接路径
    self.path=[NSString stringWithFormat:@"%@%@/",LIBPATH,theme];
//设置导航条背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@header_bg.png",self.path]] forBarMetrics:UIBarMetricsDefault];
//设置self.view的背景色
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@chat_bg_default.jpg",self.path]]];
    

//当子类也想接收主题变化的通知，但是又不能重写这个方法，那么额外建立一个方法,并且为了方便子类重写该方法，需要在.h中声明，这样，如果子类想接收主题变化的通知，只需重写createNotificationTheme就可以了

//设置导航的左右按钮，当主题变化时候，左右按钮也需要跟着刷新
    [self createNotificationTheme];


}
#pragma mark 子类中重写该方法
-(void)createNotificationTheme{

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
