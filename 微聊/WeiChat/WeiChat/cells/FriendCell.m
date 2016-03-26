
//
//  FriendCell.m
//  WeiChat
//
//  Created by 张诚 on 15/2/4.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    headerImageView=[ZCControl createImageViewWithFrame:CGRectMake(10, 10, 40, 40) ImageName:@"logo_2.png"];
    headerImageView.layer.cornerRadius=20;
    headerImageView.layer.masksToBounds=YES;
    [self.contentView addSubview:headerImageView];
    
    nickNameLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 10, 200, 20) Font:15 Text:nil];
    [self.contentView addSubview:nickNameLabel];
    
    qmdLabel=[ZCControl createLabelWithFrame:CGRectMake(60, 30, 200, 20) Font:10 Text:nil];
    qmdLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:qmdLabel];

}
-(void)config:(XMPPUserCoreDataStorageObject *)object
{
//获取用户名
    self.userName=object.jidStr;
    
//首先先获取本地上次取出来的用户头像
    UIImage*image=[[ZCXMPPManager sharedInstance]avatarForUser:object];
    if (image) {
        headerImageView.image=image;
    }
    nickNameLabel.text=self.userName;
    qmdLabel.text=nil;
    
//获取用户的Vcard  需要切割userName不带@
    NSString*str=[[self.userName componentsSeparatedByString:@"@"]firstObject];
    [[ZCXMPPManager sharedInstance]friendsVcard:str Block:^(BOOL isSucceed, XMPPvCardTemp *friend) {
        if (friend.photo) {
            headerImageView.image=[UIImage imageWithData:friend.photo];
        }
        if (friend.nickname) {
            nickNameLabel.text=UNCODE(friend.nickname);
        }else{
        //如果昵称没有，就显示账号
            nickNameLabel.text=self.userName;
        
        }
        NSString*qmd=[[friend elementForName:QMD]stringValue];
        if (qmd) {
            qmdLabel.text=UNCODE(qmd);
        }else{
        qmdLabel.text=@"这家伙很懒，什么都没留下";
        }
        
    }];

}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
