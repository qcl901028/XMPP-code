//
//  XMPPManager.h
//  xmpp
//
//  Created by 张广洋 on 15/10/8.
//  Copyright © 2015年 张广洋. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "XMPPFramework.h"

@interface XMPPManager : NSObject
<XMPPStreamDelegate,XMPPRosterDelegate,NSFetchedResultsControllerDelegate>
{
    XMPPStream * xmppStream;
    //添加好友用，花名册
    XMPPRoster * xmppRoster;
    //花名册存储
    XMPPRosterCoreDataStorage * xmppRosterDataStorage;
    //查询好友的fetch
    NSFetchedResultsController * fetFriend;
    NSManagedObjectContext * xmppRosterManagedObjectContext;
    BOOL isReg;
}

@property (copy) NSString * name;

@property (copy) NSString * password;

@property (copy) NSString * domainName;

+(XMPPManager *)share;

-(void)login;

-(void)reg;

-(void)addFriend;

-(void)logOut;

-(NSArray*) getFriends;

@end
