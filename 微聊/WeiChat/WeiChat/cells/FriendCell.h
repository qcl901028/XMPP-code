//
//  FriendCell.h
//  WeiChat
//
//  Created by 张诚 on 15/2/4.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell
{
//头像
    UIImageView*headerImageView;
//昵称
    UILabel*nickNameLabel;
//签名
    UILabel*qmdLabel;

}
@property(nonatomic,copy)NSString*userName;
//设置方法
-(void)config:(XMPPUserCoreDataStorageObject*)object;
@end
