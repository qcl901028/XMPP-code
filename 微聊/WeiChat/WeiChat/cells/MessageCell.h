//
//  MessageCell.h
//  WeiChat
//
//  Created by 张诚 on 15/2/5.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>
//大表情
#import "StickerImageView.h"
@interface MessageCell : UITableViewCell
{
//左边的 对方
    //左边头像
    UIImageView*leftHeaderImageView;
    //左边气泡
    UIImageView*leftBubbleImageView;
    //左边文字
    UILabel*leftMessageLabel;
    //左边图片
    UIImageView*leftPhotoImageView;
    //左边大表情图片
    StickerImageView*leftStickerImageView;
    //左边语音
    UIButton*leftVoiceButton;
//右边的 自己
    //右边头像
    UIImageView*rightHeaderImageView;
    //右边气泡
    UIImageView*rightBubbleImageView;
    //右边文字
    UILabel*rightMessageLabel;
    //右边图片
    UIImageView*rightPhotoImageView;
    //右边大表情图片
    StickerImageView*rightStickerImageView;
    //右边语音
    UIButton*rightVoiceButton;
}
-(void)configFriendImage:(UIImage*)leftImage myImage:(UIImage*)rightImage message:(XMPPMessageArchiving_Message_CoreDataObject*)object;


@end
