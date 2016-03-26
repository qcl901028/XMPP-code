//
//  WFMessageFrame.h
//  WFQQChat
//
//  Created by lzxuan on 15/10/8.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//


#define WFMessageFont [UIFont systemFontOfSize:13]
#define WFTextPadding 20

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WFMessageModel;
@interface WFMessageFrame : NSObject

/**
 *  聊天时间的 frame
 */
@property (nonatomic, assign, readonly) CGRect chatTimeFrame;

/**
 *  聊天头像的 frame
 */
@property (nonatomic, assign, readonly) CGRect  chatIconFrame;

/**
 *  聊天内容的 frame
 */
@property (nonatomic, assign, readonly) CGRect chatTextViewFrame;

/**
 *  单元格高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 *  WFMessageFrame 对应的数据源 model
 */
@property (nonatomic, strong) WFMessageModel *messageModel;

@end
