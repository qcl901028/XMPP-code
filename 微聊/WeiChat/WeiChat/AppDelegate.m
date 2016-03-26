//
//  AppDelegate.m
//  WeiChat
//
//  Created by 张诚 on 15/1/30.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainSliderViewController.h"
#import "ZipArchive.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    /******************/
    //设置初始button字体颜色都是黑色
    [[UIButton appearance]setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //状态条设置为白色,并且在plist需要添加一个key值View controller-based status bar appearance为NO
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UITableView appearance].backgroundColor=[UIColor clearColor];
    [UITableViewCell appearance].backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    
    /******************/
    /*
     账号18816394
     密码123
     */
  
    
    //判断程序是否是第一次运行
     NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"appFirst"]) {
        //读取文件路径
        NSString*path=[[NSBundle mainBundle]pathForResource:@"com" ofType:@"zip"];
        //解压缩的路径
        /*
         为什么要写在lib文件夹下，因为苹果审核原则：用户自己生成的是写在Documents如果是程序自己使用的写入在lib下，临时文件写在tmp下，但是需要注意的是tmp下是会不定期清空，什么清空，苹果不通知你，有以下情况，程序当时不崩溃，但是有可能2天后或者1天后就崩溃了，原因是tmp没有文件了
         */
        NSString*movePath=[NSString stringWithFormat:@"%@com.zip",LIBPATH];
        NSString*savePath=[NSString stringWithFormat:@"%@绿色简约",LIBPATH];
        
        //读取文件
        NSData*data=[NSData dataWithContentsOfFile:path];
        //写入到沙盒
        [data writeToFile:movePath atomically:YES];
        //创建解压缩工具
        ZipArchive*unZip=[[ZipArchive alloc]init];
        //设置解压缩文件路径
        [unZip UnzipOpenFile:movePath];
        //设置解压缩到哪
        [unZip UnzipFileTo:savePath overWrite:YES];
        //完成解压缩 需要注意的是到最后这步才真正解压缩完成，把在缓存中的文件，写入成文件
        [unZip UnzipCloseFile];
        
        //记录默认的主题
        [user setObject:@"绿色简约" forKey:THEME];
        //记录第一次启动完成，下次不再进入
        [user setObject:@"appFirst" forKey:@"appFirst"];
        //同步
        [user synchronize];
    }
    
    
    
    
    
    

    
//    LoginViewController*vc=[[LoginViewController alloc]init];
//    self.window.rootViewController=vc;
//    MainSliderViewController*vc=[[MainSliderViewController alloc]init];
//    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:vc];
//    self.window.rootViewController=nc;
    
    /*
     在登陆和主页之间，那么我们需要在本地记录一个值，判断用户是否登陆过，如果登陆，就不要显示登陆界面，直接进入主页面，自动登陆
     */
   
    if ([user objectForKey:isLogin]) {
        //注意这里不要用alloc来创建
        MainSliderViewController*vc=(MainSliderViewController*)[MainSliderViewController sharedSliderController];
        UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController=nc;
    }else{
        LoginViewController*vc=[[LoginViewController alloc]init];
        self.window.rootViewController=vc;
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
