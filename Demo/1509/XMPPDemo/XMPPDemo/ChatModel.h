//
//  ChatModel.h
//  XMPPDemo
//
//  Created by lijinghua on 15/9/28.
//  Copyright (c) 2015年 lijinghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *to;
@property(nonatomic,copy)NSString *message;
@end
