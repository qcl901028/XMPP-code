//
//  WFMessageModel.h
//  WFQQChat
//
//  Created by lzxuan on 15/10/8.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WFMessageTypeOther = 0,// 表示其他人
    WFMessageTypeMe // 表示自己
}WFMessageType;

@interface WFMessageModel : NSObject

/**
 *  聊天内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *   聊天时间
 */
@property (nonatomic, copy) NSString *time;

/**
 *  聊天类型(表示谁发的消息) NSString int BOOL (@"0" @"1")
 */
@property (nonatomic, assign) WFMessageType type;
/**
 *  是否不显示时间
 */
@property (nonatomic, assign) BOOL  notShowTime;


+ (instancetype)messageWithDict:(NSDictionary *)dict ;


- (instancetype)initWithDict:(NSDictionary *)dict ;




@end
