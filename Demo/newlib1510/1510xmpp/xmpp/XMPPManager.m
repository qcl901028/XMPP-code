//
//  XMPPManager.m
//  xmpp
//
//  Created by 张广洋 on 15/10/8.
//  Copyright © 2015年 张广洋. All rights reserved.
//

#import "XMPPManager.h"

@implementation XMPPManager

#pragma mark - 重新构造方法，添加xmppStream设置 -
//构造方法
-(id)init
{
    if (self=[super init]) {
        [self setupStream];
    }
    return self;
}
//设置stream和花名册
- (void)setupStream
{
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppStream setHostPort:5222];
    
    //代码作用是将_xmppRoster对象与_xmppStream联系在一起。这样就能实现添加好友了
    //初始化花名册
    xmppRosterDataStorage=[[XMPPRosterCoreDataStorage alloc]init];
    xmppRoster=[[XMPPRoster alloc]initWithRosterStorage:xmppRosterDataStorage];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppRoster.autoFetchRoster=YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests=YES;
    xmppRosterManagedObjectContext = xmppRosterDataStorage.mainThreadManagedObjectContext;
}


#pragma mark - 获取单例对象 -
//但里
+(XMPPManager *)share
{
    static XMPPManager *_share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share=[[XMPPManager alloc] init];
    });
    return _share;
}


#pragma mark - 功能接口 -
//登录
-(void)login
{
    isReg=NO;
    [xmppStream setHostName:self.domainName];
    [self connect];
}
//等出
-(void)logOut
{
    NSLog(@"注销用户");
    XMPPPresence *presene=[XMPPPresence presenceWithType:@"unavailable"];
    //设置下线状态
    [xmppStream sendElement:presene];
    //2.断开连接
    [xmppStream disconnect];
}
//注册
-(void)reg
{
    isReg=YES;
    [xmppStream setHostName:self.domainName];
    [self connect];
}
//添加好友
-(void)addFriend{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.name,self.domainName]];
    [xmppRoster subscribePresenceToUser:jid];
}
//获取好友列表
//获取好友列表
-(NSArray*) getFriends
{
    NSManagedObjectContext *context = xmppRosterDataStorage.mainThreadManagedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([XMPPUserCoreDataStorageObject class])];
    //筛选本用户的好友
    NSString *userinfo = [NSString stringWithFormat:@"%@@%@",self.name,self.domainName];
    NSLog(@"userinfo = %@",userinfo);
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"streamBareJidStr=%@",userinfo];
    request.predicate = predicate;
    //排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
    request.sortDescriptors = @[sort];
    
    fetFriend = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    fetFriend.delegate = self;
    NSError *error;
    if (![fetFriend performFetch:&error])    {
        NSLog(@"%s  %@",__FUNCTION__,[error localizedDescription]);
    }
    //返回的数组是XMPPUserCoreDataStoeObject  *obj类型的
    //名称为 obj.displayName
    NSLog(@"%lu",(unsigned long)fetFriend.fetchedObjects.count);
    return  fetFriend.fetchedObjects;
    
//    NSManagedObjectContext *context = [xmppRosterDataStorage mainThreadManagedObjectContext];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    [request setEntity:entity];
//    NSError *error ;
//    NSArray *friends = [context executeFetchRequest:request error:&error];
//    return friends;
}


#pragma mark - 进行服务器连接 -
//连接服务器
- (BOOL)connect
{
    //如果当前已经链接服务器，断开连接，如果断不开，直接返回。
    if (xmppStream.isConnected) {
        [xmppStream disconnect];
    }
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    //如果用户名没有输入，直接返回。
    if (self.name == nil) {
        return NO;
    }
    //设置JID
    [xmppStream setMyJID:[XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",self.name,self.domainName]]];
    //开始链接
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        //提示用户连接失败
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"连接服务失败"
                                                            message:@"请查阅详细内容"
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}


#pragma mark - 连接结果代理方法 ＋ 登录注册的代理结果 -
//成功连接服务器
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    NSLog(@"socketDidConnect");
}
//连接服务器失败
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"xmppStreamDidDisconnect");
}
//xmpp链接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"xmppStreamDidConnect");
    NSError *error = nil;
    if (isReg)
    {
        if (![xmppStream registerWithPassword:self.password error:&error])
        {
            NSLog(@"%@",error);
        }
    }
    else
    {
        if (![xmppStream authenticateWithPassword:self.password error:&error])
        {
            NSLog(@"%@",error);
            
        }
    }
}
//登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPPresence *presence = [XMPPPresence presence];
    [xmppStream sendElement:presence];
    
    NSLog(@"xmppStreamDidAuthenticate");
    [self goOnline];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录成功"
                                                        message:@"登录成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
    [xmppRoster activate:xmppStream];
    
    
}
//登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    NSLog(@"didNotAuthenticate");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码错误"
                                                        message:@"密码错误"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    
    
}
//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"xmppStreamDidRegister");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册成功"
                                                        message:@"注册成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    isReg=NO;
}
//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"didNotRegister");
    NSLog(@"%@",[[error elementForName:@"error"] stringValue]);
    NSLog(@"%@",error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                        message:@"注册失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    isReg=NO;
}


#pragma mark - 上线下线通知 -
- (void)goOnline//上线通知
{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [xmppStream sendElement:presence];
}
- (void)goOffline//下线通知
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
}


#pragma mark - 接收到用户添加好友的请求 -
//接受好友请求
- (void) receiveContact:(XMPPStream *)sender presence:(XMPPPresence *)presence xmppRoster:(XMPPRoster *)xmppRoster
{
    NSString *presenceType = presence.type;
    NSString *userId = sender.myJID.user;
    NSString *presenceFromUser = presence.from.user;
    if (![presenceFromUser isEqualToString:userId])
    {
        
        // 用户在线
        if ([presenceType isEqualToString:@"available"]) {
            
            
        }else if([presenceType isEqualToString:@"unavailable"])
        {
            
        }else if ([presenceType isEqualToString:@"subscribe"])
        {
            //            NSLog(@%@,presence.description);
            //            NSLog(@%@,presence.from);
            XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",presence.from]];
            [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
        }
    }
}





@end
