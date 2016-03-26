//
//  ThemeManager.h
//  WeiChat
//
//  Created by 张诚 on 15/2/4.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDownLoadBlock.h"
@interface ThemeManager : NSObject
//下载调用的指针
@property(nonatomic,copy)void(^myBlock)(BOOL);
//记录当前数据源
@property(nonatomic,strong)NSDictionary*dic;
//主题名称
@property(nonatomic,copy)NSString*themeName;
//已经下载过的主题
@property(nonatomic,strong)NSMutableArray*dataArray;
//plist文件数据持久化的路径
@property(nonatomic,copy)NSString*plistPath;

//单例
+(instancetype)shareManager;
//下载的调用方法 BOOL使用是已经下载过，还是没下载过的
-(BOOL)themeDownLoadData:(NSDictionary*)dic Block:(void(^)(BOOL))a;
@end
