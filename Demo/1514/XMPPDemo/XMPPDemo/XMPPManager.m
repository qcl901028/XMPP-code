//
//  XMPPManager.m
//  XMPPDemo
//
//  Created by lzxuan on 15/11/9.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "XMPPManager.h"


@interface XMPPManager () {
    //表示注册还是登录
    ConnectServerPurposeType _connectServerPurposeType;
}
/**
 *  密码字符串
 */
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) XMPPJID *fromJid;
@end

@implementation XMPPManager

+ (instancetype)defautManager {
    static XMPPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XMPPManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 1.初始化XMPPStream
        _xmppStream = [[XMPPStream alloc] init];
        // 设置服务器地址,这里用的是本地地址（可换成公司具体地址）
        _xmppStream.hostName = @"qianfeng.local";
        //设置端口号
        _xmppStream.hostPort = 5222;
        //设置代理
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        XMPPRosterCoreDataStorage *rosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:rosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        //激活
        [_xmppRoster activate:_xmppStream];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        XMPPMessageArchivingCoreDataStorage *messageDataStore = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:messageDataStore dispatchQueue:dispatch_get_main_queue()];
        [_xmppMessageArchiving activate:_xmppStream];
        _messageArchivingContext = messageDataStore.mainThreadManagedObjectContext;
        
    }
    return self;
}
/**
 *  登录方法
 *
 *  @param userName 用户名
 *  @param password 用户密码
 */
- (void)loginwithName:(NSString *)userName andPassword:(NSString *)password {
    // 表示是登录
    _connectServerPurposeType = ConnectServerPurposeTypeLogin;
    //这里记录用户输入的密码，在登录（注册）的方法里面使用
    self.passWord = password;
    /**
     *  1.初始化一个xmppStream
     2.连接服务器（成功或者失败）
     3.成功的基础上，服务器验证（成功或者失败）
     4.成功的基础上，发送上线消息
     */
    
    
    // *  创建xmppjid（用户）
    // *  @param NSString 用户名，域名，登录服务器的方式（苹果，安卓等）
    
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:@"qianfeng.local" resource:@"iPhone6s"];
    self.xmppStream.myJID = jid;
    //连接到服务器
    [self connectToServer];
    //有可能成功或者失败，所以有相对应的代理方法
 
}
- (void)registerwithName:(NSString *)userName andPassword:(NSString *)password {
    // 表示是登录
    _connectServerPurposeType = ConnectServerPurposeTypeRegister;
    //这里记录用户输入的密码，在登录（注册）的方法里面使用
    self.passWord = password;

    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:@"qianfeng.local" resource:@"iPhone6s"];
    self.xmppStream.myJID = jid;
    //连接到服务器
    [self connectToServer];
    //有可能成功或者失败，所以有相对应的代理方法
    
}


// 收到好友请求执行的方法
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    NSLog(@"ssss");
    self.fromJid = presence.from;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示:有人添加你" message:presence.from.user  delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"%ld",buttonIndex);
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:_fromJid andAddToRoster:YES];
    }
}

#pragma mark 连接到服务器的方法
-(void)connectToServer{
    //如果已经存在一个连接，需要将当前的连接断开，然后再开始新的连接
    if ([self.xmppStream isConnected]) {
        [self logout];
    }
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:30.0f error:&error];
    if (error) {
        NSLog(@"error = %@",error);
    }
}

#pragma mark 注销方法的实现
-(void)logout{
    //表示离线不可用
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    //    向服务器发送离线消息
    [self.xmppStream sendElement:presence];
    //断开链接
    [self.xmppStream disconnect];
}

#pragma mark xmppStream的代理方法
//连接服务器失败的方法
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接服务器失败的方法，请检查网络是否正常");
}
//连接服务器成功的方法
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接服务器成功的方法");
    //登录
    if (_connectServerPurposeType == ConnectServerPurposeTypeLogin) {
        NSError *error = nil;
        [sender authenticateWithPassword:self.passWord error:&error];
          NSLog(@"-----%@",self.passWord);
           NSLog(@"登录成功");
    }
    //注册
    else{
        //向服务器发送一个密码注册（成功或者失败）
        [sender registerWithPassword:self.passWord error:nil];
    }
    
}

//注册成功的回调函数
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
}

//注册失败的回调函数
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册失败:%@",error);
}




//验证成功的方法
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"验证成功的方法");
    /**
     *  unavailable 离线
     available  上线
     away  离开
     do not disturb 忙碌
     */
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
}
//验证失败的方法
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"验证失败的方法,请检查你的用户名或密码是否正确,%@",error);
}






@end
