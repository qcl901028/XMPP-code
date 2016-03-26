
//
//  RegisterManager.m
//  WeiChat
//
//  Created by 张诚 on 15/2/2.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "RegisterManager.h"
static RegisterManager *manager=nil;
@implementation RegisterManager
+(id)shareManager{
//    if (manager==nil) {
//        manager=[[RegisterManager alloc]init];
//    }
//    return manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[RegisterManager alloc]init];
    });
    return manager;
}
@end
