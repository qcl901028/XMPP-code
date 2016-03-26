//
//  MyVcardViewController.h
//  WeiChat
//
//  Created by 张诚 on 15/2/3.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RootViewController.h"

@interface MyVcardViewController : RootViewController
@property(nonatomic,copy)void(^myVcardBlock)();
-(instancetype)initWithBlock:(void(^)())a;
@end
