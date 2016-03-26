//
//  WFChatMessageCell.m
//  WFQQChat
//
//  Created by lzxuan on 15/10/8.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "WFChatMessageCell.h"
#import "WFMessageFrame.h"
#import "WFMessageModel.h"
@implementation WFChatMessageCell {
    /**
     *  聊天时间空间
     */
    UILabel *_chatTimeView;
    /**
     *  聊天头像
     */
    UIImageView *_iconImageView;
    /**
     *  聊天内容
     */
    UIButton *_chatTextView;
    
    
    
    
}

/**
 *  自定义 cell(通过继承) 的时候重写 initWithStyle 方法
 *
 *  @param style           单元格样式
 *  @param reuseIdentifier 重用标识符
 *
 *  @return 单元格对象
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customViews];
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)customViews {
    /**
     *  初始化聊天单元格控件
     */
    _chatTimeView = [UILabel new];
    _chatTimeView.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_chatTimeView];
    
    _iconImageView = [UIImageView new];
    [self.contentView addSubview:_iconImageView];
    
    _chatTextView = [[UIButton alloc] init];
    _chatTextView.titleLabel.numberOfLines = 0;
    _chatTextView.titleLabel.font = WFMessageFont;
    [_chatTextView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _chatTextView.contentEdgeInsets = UIEdgeInsetsMake(WFTextPadding, WFTextPadding, WFTextPadding, WFTextPadding);
    [self.contentView addSubview:_chatTextView];
    
}

- (void)setMessageFrame:(WFMessageFrame *)messageFrame {
    _messageFrame = messageFrame;
    
    _chatTimeView.text = _messageFrame.messageModel.time;
    _chatTimeView.frame = _messageFrame.chatTimeFrame;
    
    
    NSString *iconName = _messageFrame.messageModel.type == WFMessageTypeOther ? @"other" : @"me";
    UIImage *image = [UIImage imageNamed:iconName];
    _iconImageView.image =  image;
    _iconImageView.frame = _messageFrame.chatIconFrame;
    
    
    [_chatTextView setTitle:_messageFrame.messageModel.text forState:UIControlStateNormal];
    _chatTextView.frame = _messageFrame.chatTextViewFrame;
    
    NSString *backImageName = _messageFrame.messageModel.type == WFMessageTypeOther ? @"chat_recive_nor" : @"chat_send_nor";
    UIImage *backgroundImage = [UIImage imageNamed:backImageName];
    UIImage *backImage = [backgroundImage stretchableImageWithLeftCapWidth:(backgroundImage.size.width)*0.5 topCapHeight:(backgroundImage.size.height)*0.5];
    [_chatTextView setBackgroundImage:backImage forState:UIControlStateNormal];

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
