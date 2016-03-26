
//
//  MessageCell.m
//  WeiChat
//
//  Created by 张诚 on 15/2/5.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "MessageCell.h"
#import "Photo.h"
@implementation MessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    
    return self;
}
-(void)makeUI{
    //左边
    //头像
    leftHeaderImageView=[ZCControl createImageViewWithFrame:CGRectMake(5, 5, 30, 30) ImageName:@"logo_2.png"];
    //图片切圆角
    leftHeaderImageView.layer.cornerRadius=15;
    leftHeaderImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:leftHeaderImageView];
    //气泡
    leftBubbleImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 10, 10) ImageName:nil];
    UIImage*leftImage=[UIImage imageNamed:@"chat_send_nor_pic.png"];
    //矩阵翻转
    leftImage=[UIImage imageWithCGImage:leftImage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];
    //进行拉伸
    leftImage=[leftImage stretchableImageWithLeftCapWidth:40 topCapHeight:28];
    leftBubbleImageView.image=leftImage;
    [self.contentView addSubview:leftBubbleImageView];
    //文字
    leftMessageLabel=[ZCControl createLabelWithFrame:CGRectZero Font:10 Text:nil];
    [leftBubbleImageView addSubview:leftMessageLabel];
    //设置图片
    leftPhotoImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    [leftBubbleImageView addSubview:leftPhotoImageView];
    //设置大表情
    leftStickerImageView=[[StickerImageView alloc]initWithFrame:CGRectMake(10, 10, 180, 180)];
    [leftBubbleImageView addSubview:leftStickerImageView];
    //设置语音
    leftVoiceButton=[ZCControl createButtonWithFrame:CGRectMake(10, 10, 40, 40) ImageName:@"chat_bottom_voice_nor.png" Target:self Action:@selector(voiceClick) Title:nil];
    [leftBubbleImageView addSubview:leftVoiceButton];
    
    //右边
    //头像
    rightHeaderImageView=[ZCControl createImageViewWithFrame:CGRectMake(WIDTH-35, 5, 30, 30) ImageName:@"logo_2.png"];
    rightHeaderImageView.layer.cornerRadius=15;
    rightHeaderImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:rightHeaderImageView];
    //气泡
    rightBubbleImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 10, 10) ImageName:nil];
    UIImage*rightImage=[UIImage imageNamed:@"chat_send_nor.png"];
    rightImage=[rightImage stretchableImageWithLeftCapWidth:40 topCapHeight:28];
    rightBubbleImageView.image=rightImage;
    [self.contentView addSubview:rightBubbleImageView];
    //文字
    rightMessageLabel=[ZCControl createLabelWithFrame:CGRectZero Font:10 Text:nil];
    [rightBubbleImageView addSubview:rightMessageLabel];
    //图片
    rightPhotoImageView=[ZCControl createImageViewWithFrame:CGRectZero ImageName:nil];
    [rightBubbleImageView addSubview:rightPhotoImageView];
    //大表情
    rightStickerImageView=[[StickerImageView alloc]initWithFrame:CGRectMake(10, 10, 180, 180)];
    [rightBubbleImageView addSubview:rightStickerImageView];
    //语音
    rightVoiceButton=[ZCControl createButtonWithFrame:CGRectMake(10, 10, 40, 40) ImageName:@"chat_bottom_voice_nor.png" Target:self Action:@selector(voiceClick) Title:nil];
    [rightBubbleImageView addSubview:rightVoiceButton];
    
}
-(void)configFriendImage:(UIImage *)leftImage myImage:(UIImage *)rightImage message:(XMPPMessageArchiving_Message_CoreDataObject *)object
{
    rightHeaderImageView.image=rightImage;
    leftHeaderImageView.image=leftImage;

    
    //判断自己还是对方
    if (object.isOutgoing) {
        //自己
        rightHeaderImageView.hidden=NO;
        leftHeaderImageView.hidden=YES;
        rightBubbleImageView.hidden=NO;
        leftBubbleImageView.hidden=YES;
        NSString*str=object.message.body;
        if ([str hasPrefix:MESSAGE_STR]) {
            //文字
            CGSize size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
            rightMessageLabel.frame=CGRectMake(20,10, size.width, size.height);
            rightBubbleImageView.frame=CGRectMake(WIDTH-40-size.width-30, 5 , size.width+30, size.height+30);
            rightMessageLabel.text=[str substringFromIndex:3];
            rightMessageLabel.hidden=NO;
            rightPhotoImageView.hidden=YES;
            rightStickerImageView.hidden=YES;
            rightVoiceButton.hidden=YES;
            
        }else{
            if ([str hasPrefix:MESSAGE_IMAGESTR]) {
                //图片
                UIImage*image=[Photo string2Image:[str substringFromIndex:3]];
                CGSize size=image.size;
                rightPhotoImageView.frame=CGRectMake(5, 5, size.width>200?200:size.width, size.height>200?200:size.height);
                
                rightBubbleImageView.frame=CGRectMake(WIDTH-40-rightPhotoImageView.frame.size.width-10, 5, rightPhotoImageView.frame.size.width+10, rightPhotoImageView.frame.size.height+10);
                rightPhotoImageView.image=image;
                rightMessageLabel.hidden=YES;
                rightPhotoImageView.hidden=NO;
                rightStickerImageView.hidden=YES;
                rightVoiceButton.hidden=YES;
            }else{
                if ([str hasPrefix:MESSAGE_BIGIMAGESTR]) {
                    rightStickerImageView.sticker=[StickerInfo stickerWithID:[str substringFromIndex:3]];
                    rightBubbleImageView.frame=CGRectMake(WIDTH-40-200, 5, 200, 200);
                    rightMessageLabel.hidden=YES;
                    rightPhotoImageView.hidden=YES;
                    rightStickerImageView.hidden=NO;
                    rightVoiceButton.hidden=YES;
                }else{
                    if ([str hasPrefix:MESSAGE_VOICE]) {
                        //做记录保存
                        rightBubbleImageView.frame=CGRectMake(WIDTH-40-60, 5, 60, 60);
                        rightMessageLabel.hidden=YES;
                        rightPhotoImageView.hidden=YES;
                        rightStickerImageView.hidden=YES;
                        rightVoiceButton.hidden=NO;
                    }
                
                }
            
            }
        
        
        
        }
        
        
        
        
    }else{
    //对方
        rightHeaderImageView.hidden=YES;
        leftHeaderImageView.hidden=NO;
        rightBubbleImageView.hidden=YES;
        leftBubbleImageView.hidden=NO;
       NSString*str=object.message.body;
        if ([str hasPrefix:MESSAGE_STR]) {
            //计算字符串大小
            CGSize size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
            
            leftMessageLabel.frame=CGRectMake(20, 10, size.width, size.height);
            leftMessageLabel.text=[str substringFromIndex:3];
            leftBubbleImageView.frame=CGRectMake(50, 5, size.width+30, size.height+30);
            leftMessageLabel.hidden=NO;
            leftPhotoImageView.hidden=YES;
            leftStickerImageView.hidden=YES;
            leftVoiceButton.hidden=YES;
        }else{
            if ([str hasPrefix:MESSAGE_IMAGESTR]) {
                UIImage*image=[Photo string2Image:[str substringFromIndex:3]];
                CGSize size=image.size;
                leftPhotoImageView.frame=CGRectMake(20, 15, size.width>200?200:size.width, size.height>200?200:size.height);
            
                leftPhotoImageView.image=image;
                leftBubbleImageView.frame=CGRectMake(50, 5, leftPhotoImageView.frame.size.width+40, leftPhotoImageView.frame.size.height+30);
                leftMessageLabel.hidden=YES;
                leftPhotoImageView.hidden=NO;
                leftStickerImageView.hidden=YES;
                leftVoiceButton.hidden=YES;
            }else{
                if ([str hasPrefix:MESSAGE_BIGIMAGESTR]) {
                    leftStickerImageView.sticker=[StickerInfo stickerWithID:[str substringFromIndex:3]];
                    leftBubbleImageView.frame=CGRectMake(50,5, 200, 200);
                    leftMessageLabel.hidden=YES;
                    leftPhotoImageView.hidden=YES;
                    leftStickerImageView.hidden=NO;
                    leftVoiceButton.hidden=YES;
                }else{
                    if ([str hasPrefix:MESSAGE_VOICE]) {
                        //记录数据
                        leftBubbleImageView.frame=CGRectMake(50, 5, 60, 60);
                        leftMessageLabel.hidden=YES;
                        leftPhotoImageView.hidden=YES;
                        leftStickerImageView.hidden=YES;
                        leftVoiceButton.hidden=NO;
                    }
                
                }
            
            }
        
        }
        
        
        
    
    }


}

//语音播放
-(void)voiceClick{

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
