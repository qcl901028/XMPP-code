//
//  XMPPManager.h
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"

//注册登录的结果block类型
typedef void(^ResultBlockType) (BOOL isOK,NSError *error);

@interface XMPPManager : NSObject

//好友列表
@property(nonatomic)NSMutableArray *freindList;

//单例
+(instancetype)sharedInstance;

//注册的接口
- (void)regist:(NSString*)userName password:(NSString*)password resultBlock:(ResultBlockType)block;

//登录的接口
- (void)login:(NSString*)userName password:(NSString*)password resultBlock:(ResultBlockType)block;

//返回当前的登陆用户
- (NSString*)currentLoginUser;

//聊天的接口
- (void)sendMessage:(ChatModel*)chat;

@end
