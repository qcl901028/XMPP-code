
//
//  MainTabBarViewController.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "MainTabBarViewController.h"
//最近联系人
#import "RecentlyViewController.h"
//联系人
#import "FriendViewController.h"
//动态
#import "NewViewController.h"
@interface MainTabBarViewController ()
@property(nonatomic,copy)NSString*path;
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers];
    [self createTabBarItems];
    
    //接收主题变换的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createTabBarItems) name:THEME object:nil];
    // Do any additional setup after loading the view.
}
-(void)createTabBarItems{
//取出当前主题的名称
    NSString*theme=[[NSUserDefaults standardUserDefaults]objectForKey:THEME];
//拼接图片路径
    self.path=[NSString stringWithFormat:@"%@%@/",LIBPATH,theme];
//创建数据 3个数组
    NSArray*titleArray=@[@"消息",@"联系人",@"动态"];
    NSArray*selectArray=@[@"tab_recent_press.png",@"tab_buddy_press.png",@"tab_qworld_press.png"];
    NSArray*unSelectArray=@[@"tab_recent_nor.png",@"tab_buddy_nor.png",@"tab_qworld_nor.png"];
    
    for (int i=0; i<titleArray.count; i++) {
        //获取item
        UITabBarItem*item=self.tabBar.items[i];
        item=[item initWithTitle:titleArray[i] image:[self createImage:unSelectArray[i]] selectedImage:[self createImage:selectArray[i]]];
    }
//设置item的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
//设置tabBar的阴影线为隐藏
    [self.tabBar setShadowImage:[[UIImage alloc]init]];
    
//设置背景色
    [self.tabBar setBackgroundImage:[self createImage:@"tabbar_bg.png"]];
    
    

}
//路径转换为图片的方法
-(UIImage*)createImage:(NSString*)imageName{
    //拼接imageName路径
    NSString*imagePath=[NSString stringWithFormat:@"%@%@",self.path,imageName];
    //生成image
    UIImage*image=[UIImage imageWithContentsOfFile:imagePath];
    //处理阴影
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

-(void)createViewControllers{
    RecentlyViewController*vc1=[[RecentlyViewController alloc]init];
    vc1.title=@"消息";
    UINavigationController*nc1=[[UINavigationController alloc]initWithRootViewController:vc1];
    
    FriendViewController*vc2=[[FriendViewController alloc]init];
    vc2.title=@"联系人";
    UINavigationController*nc2=[[UINavigationController alloc]initWithRootViewController:vc2];
    
    NewViewController*vc3=[[NewViewController alloc]init];
    vc3.title=@"动态";
    UINavigationController*nc3=[[UINavigationController alloc]initWithRootViewController:vc3];
    self.viewControllers=@[nc1,nc2,nc3];
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
