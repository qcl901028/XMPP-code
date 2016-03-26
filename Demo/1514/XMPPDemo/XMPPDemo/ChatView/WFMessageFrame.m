
//
//  WFMessageFrame.m
//  WFQQChat
//
//  Created by lzxuan on 15/10/8.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "WFMessageFrame.h"
#import "UIView+Common.h"
#import "WFMessageModel.h"
#import "NSString+Tools.h"
@implementation WFMessageFrame

- (void)setMessageModel:(WFMessageModel *)messageModel {
    _messageModel = messageModel;
    
    if (!_messageModel.notShowTime) {
      _chatTimeFrame = CGRectMake(0, 0, screenWidth(), 20);
    }
    
    CGFloat chatPadding = 10;
    
    CGFloat iconW = 40;
    CGFloat iconH = 40;
    CGFloat iconY = CGRectGetMaxY(_chatTimeFrame);
    
    if (messageModel.type == WFMessageTypeOther) {
        _chatIconFrame = CGRectMake(chatPadding, iconY, iconW, iconH);
    }else {
        _chatIconFrame = CGRectMake(screenWidth() - iconW - chatPadding, iconY, iconW, iconH);
    }
    
    CGFloat chatTextW = 150;
    CGFloat chatTextX;
    CGFloat chattextY = iconY;
    CGSize chatTextSize = [messageModel.text sizeWithFont:WFMessageFont maxSize:CGSizeMake(chatTextW, MAXFLOAT)];
    CGFloat chatTextH = chatTextSize.height ;
    if (messageModel.type == WFMessageTypeOther) {
        chatTextX = CGRectGetMaxX(_chatIconFrame) + chatPadding;

    }else {
        chatTextX = screenWidth() - chatPadding - iconW - chatTextSize.width - chatPadding - WFTextPadding*2;
    }
    _chatTextViewFrame = CGRectMake(chatTextX, chattextY, chatTextSize.width + WFTextPadding*2, chatTextH + WFTextPadding*2);
    _cellHeight = MAX(CGRectGetMaxY(_chatIconFrame), CGRectGetMaxY(_chatTextViewFrame)) + chatPadding;
}



@end
