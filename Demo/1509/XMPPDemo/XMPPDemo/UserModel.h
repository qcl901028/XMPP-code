//
//  UserModel.h
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic,copy)NSString *jid;
@property(nonatomic,copy)NSString *name;
//unavailable 和 available
//unavailable 不能与之聊天
//available   能与之聊天
@property(nonatomic,copy)NSString *status;
@end
