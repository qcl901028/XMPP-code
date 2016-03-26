//
//  XMPPManager.m
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import "XMPPManager.h"
#import "XMPPStream.h"
#import "NSXMLElement+XMPP.h"
#import "UserModel.h"
#import "XMPPCommonDefine.h"

@interface XMPPManager()<XMPPStreamDelegate>
//使用xmppStream来与服务端打交道
@property(nonatomic)XMPPStream *xmppStream;

//记录当前的的用户名密码，以及结果block
@property(nonatomic,copy)NSString *currentUser;
@property(nonatomic,copy)NSString *currentPassword;
@property(nonatomic,copy)ResultBlockType completeBlock;

@property(nonatomic)BOOL isRegistAction;    //记录当前是否为注册的行为
@end

@implementation XMPPManager


+ (instancetype)sharedInstance
{
    static XMPPManager *s_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_manager = [[XMPPManager alloc] init];
    });
    
    return s_manager;
}

- (id)init{
    if (self = [super init]) {
        //好友列表初始化
        self.freindList = [NSMutableArray array];
        
        _xmppStream = [[XMPPStream alloc]init];
        _xmppStream.hostName = @"lzxuan.local";
        _xmppStream.hostPort = 5222;
        
        //给xmppStream添加代理，这样，xmppStream的各种事件就会通过代理方法传递给我们，譬如登陆注册是否成功，好友列表等事件
        
        //所有的代理方法在主队列上执行
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}


- (void)connetToHost:(NSString*)userName password:(NSString*)password resultBlock:(ResultBlockType)block
{
    //记录
    self.currentUser      = userName;
    self.currentPassword  = password;
    self.completeBlock    = block;
    
    //跟服务端打交道的xmppframework提供XMPPStream的类来实现
    //由于XMPPStrema使用的是tcp，在数据传输之前，需要先建立连接
    
    //使用xmppStream 连接到服务器之前，需要绑定jid
    //JID 在xmpp协议中唯一表示一个用户
    //JID格式为user@domain/resource   user@domain邮箱格式，所以必须用邮箱格式注册
    //resource 区分终端或地区用的，pc or 手机，resouce 可选
    
    XMPPJID *jid = [XMPPJID jidWithString:userName];
    [self.xmppStream setMyJID:jid];
    
    //判断xmppStream是否应连接，如果连接，先断开，只保证连接一次
    if ([self.xmppStream isConnected]) {
        [self.xmppStream disconnect];
    }
    
    //连接到服务端
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:-1 error:&error];
}

//注册的接口
- (void)regist:(NSString*)userName password:(NSString*)password resultBlock:(ResultBlockType)block
{
    self.isRegistAction = YES;
    [self connetToHost:userName password:password resultBlock:block];
}

//登录的接口
- (void)login:(NSString*)userName password:(NSString*)password resultBlock:(ResultBlockType)block
{
    self.isRegistAction = NO;
    [self connetToHost:userName password:password resultBlock:block];
}

//获取自己的好友列表，向服务器发送iq节 type为get
//from：jid
//id 代表会话
//query  xmlns:xml的namespace（命名空间）jabber:iq:roster （花名册）

//<iq from='juliet@example.com/balcony' type='get' id='roster_1'>
//<query xmlns='jabber:iq:roster'/>
//</iq>

- (void)getAllFriends
{
    //生成iq节点
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"];
    [iq addAttributeWithName:@"from" stringValue:self.currentUser];
    [iq addAttributeWithName:@"id" stringValue:@"12345"];
    
    //生成query节点
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    //添加query节点作为iq的字节点
    [iq addChild:query];
    
    //发送iq节到服务器
    [self.xmppStream sendElement:iq];
}

//发布出席信息
//发布出席信息之后（上线后）服务器会把我的好友的状态信息再次返回给我，这里面就包含是可以与其通信的状态信息
- (void)onLine
{
    XMPPPresence *presence = [XMPPPresence presence];
    [self.xmppStream sendElement:presence];
}


//返回当前的登陆用户
- (NSString*)currentLoginUser{
    return self.currentUser;
}

//
//<message
//to='romeo@example.net'
//from='juliet@example.com/balcony'
//type='chat'
//xml:lang='en'>
//<body>Wherefore art thou, Romeo?</body>
//</message>
//聊天的接口
- (void)sendMessage:(ChatModel*)chat
{
    //message节
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat"];
    [message addAttributeWithName:@"to" stringValue:chat.to];
    [message addAttributeWithName:@"from" stringValue:chat.from];
    [message addAttributeWithName:@"xml:lang" stringValue:@"en"];
    
    //body
    NSXMLElement *body = [NSXMLElement elementWithName:@"body" stringValue:chat.message];
    
    [message addChild:body];
    //发送
    [self.xmppStream sendElement:message];
}
#pragma mark -
#pragma mark XMPPStreamDelegate
//和服务端建立连接后调用的代理方法
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    if (self.isRegistAction) {
        //注册的接口
        [self.xmppStream registerWithPassword:self.currentPassword error:nil];
    }else{
        //登陆认证接口
        [self.xmppStream authenticateWithPassword:self.currentPassword error:nil];
    }
}

//-------------------------------------------------------
//注册成功的回调函数
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    if(self.completeBlock)
    {
        self.completeBlock(YES,nil);
    }
}

//注册失败的回调函数
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    if (self.completeBlock) {
        //类型转换，1000 是错误的类型码  ,跟HTTP 200 对应 OK 一样
        NSError *retError = [NSError errorWithDomain:error.description code:1000 userInfo:nil];
        self.completeBlock(NO,retError);
    }
}
//-------------------------------------------------------------
//登陆认证成功后的代理方法
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    if (self.completeBlock) {
        self.completeBlock(YES,nil);
    }
    
    //获取好友列表
    [self getAllFriends];
    
    //上线，发布自己的出席信息
    [self onLine];
}

//登陆认证失败后的代理方法
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if (self.completeBlock) {
        NSError *retError = [NSError errorWithDomain:error.description code:2000 userInfo:nil];
        self.completeBlock(NO,retError);
    }

}

//<iq to='juliet@example.com/balcony' type='result' id='roster_1'>
//    <query xmlns='jabber:iq:roster'>
//     <item jid='romeo@example.net'
//      name='Romeo'
//      subscription='both'>
//      <group>Friends</group>
//     </item>
//     <item jid='mercutio@example.org'
//      name='Mercutio'
//      subscription='from'>
//    <group>Friends</group>
//   </item>
//   <item jid='benvolio@example.org'
//    name='Benvolio'
//    subscription='both'>
//   <group>Friends</group>
//   </item>
//</query>
//</iq>

//subscription
//to     :我订阅了改用户的出席信息（上线通知）,但是该用户没有订阅我的出席信息
//from   :该用户订阅了我的出席信息，但是我没有订阅他的出席信息
//both   :双方都订阅了各自的出席信息
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    //判断iq的类型是否为result
    if ([iq.type isEqualToString:@"result"]) {
        
        //先清除好友列表
        [self.freindList removeAllObjects];
        
        //首先得到query 节点
        DDXMLElement *query = iq.childElement;
        //得到query节点的字节点列表
        NSArray *itemArray = query.children;
        for (NSXMLElement *item in itemArray) {
            UserModel *user = [[UserModel alloc]init];
            user.jid = [item attributeStringValueForName:@"jid"];
            user.name = [item attributeStringValueForName:@"name"];
            //自己还没有上线，目前的状态时unavailable，指信息不可达
            user.status = @"unavailable";
            
            [self.freindList addObject:user];
        }
        
        //发送通知，跟新好友列表
        [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_FRIEND_LIST_NOTIFICATION object:nil];
    }
    
    return YES;
}

//<presence from='juliet@example.com/balcony' type='unavailable'/>
//unavailable
//available
//服务器把我的好友的出席信息给我，该函数会被调用多次
//当我的好友的上线，下线也会调用该方法
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    NSString *jid = [presence.from bare];
    if ([jid isEqualToString:self.currentUser]) {
        //过滤掉自身的jid
        return;
    }
    
    NSString *type = presence.type;

    //遍历好友列表，跟新状态信息
    for (UserModel *user in self.freindList) {
        if ([user.jid isEqualToString:jid]) {
            user.status = type;
        }
    }
    
    //发送好友状态信息修改的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:XMPP_UPDATE_STATUS_NOTIFICATION object:nil];
}

//收到聊天对方发送的消息，调用该代理方法
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *from = [message.from bare];
    NSString *to   = [message.to bare];
    NSString *body = [message body];
    if (body == nil) {
        return;
    }
    
    ChatModel *chat = [[ChatModel alloc]init];
    chat.from = from;
    chat.to   = to;
    chat.message = body;
    
    //发送消息告诉收到了聊天的内容
    [[NSNotificationCenter defaultCenter]postNotificationName:XMPP_RECEIVE_CHAT_MESSAGE_NOTIFICATION object:chat];
}
@end
