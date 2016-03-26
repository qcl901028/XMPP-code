//
//  ChatViewController.h
//  XMPPDemo
//
//  Created by lzxuan on 15/11/9.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPJID;
@interface ChatViewController : UIViewController

@property (nonatomic, strong) XMPPJID *friendJID;
@end
