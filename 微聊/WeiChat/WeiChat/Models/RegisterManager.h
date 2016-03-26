//
//  RegisterManager.h
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

/*
本模型主要用于4个注册界面的数据记录，方便传递数据
 由于vc之间的传递，所有本模型采用单例
 
*/

#import <Foundation/Foundation.h>

@interface RegisterManager : NSObject
//用户名
@property(nonatomic,copy)NSString*userName;
//昵称
@property(nonatomic,copy)NSString*nickName;
//头像
@property(nonatomic)UIImage*headerImage;
//生日
@property(nonatomic,copy)NSString*birthday;
//性别
@property(nonatomic,copy)NSString*sex;
//手机号
@property(nonatomic,copy)NSString*phoneNum;
//密码
@property(nonatomic,copy)NSString*passWord;
//签名
@property(nonatomic,copy)NSString*qmd;
//地址
@property(nonatomic,copy)NSString*address;
//单例方法
+(id)shareManager;
@end
