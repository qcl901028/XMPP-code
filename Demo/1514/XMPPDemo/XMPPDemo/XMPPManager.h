//
//  XMPPManager.h
//  XMPPDemo
//
//  Created by lzxuan on 15/11/9.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

typedef NS_ENUM(NSInteger, ConnectServerPurposeType)
{
    ConnectServerPurposeTypeLogin,    //登录
    ConnectServerPurposeTypeRegister   //注册
};

@interface XMPPManager : NSObject <XMPPStreamDelegate>

//通信管道，输入输出流
@property (nonatomic, strong) XMPPStream *xmppStream;

/**
 *  好友管理
 */
@property (nonatomic, strong) XMPPRoster *xmppRoster;

// 聊天信息
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;

@property (nonatomic, strong) NSManagedObjectContext *messageArchivingContext;
/**
 *  单列方法
 *
 *  @return  manager 对象
 */
+ (instancetype)defautManager;

//登录的方法
-(void)loginwithName:(NSString *)userName andPassword:(NSString *)password;
//注册
- (void)registerwithName:(NSString *)userName andPassword:(NSString *)password ;

@end
