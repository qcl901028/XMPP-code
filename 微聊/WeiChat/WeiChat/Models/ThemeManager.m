
//
//  ThemeManager.m
//  WeiChat
//
//  Created by 张诚 on 15/2/4.
//  Copyright (c) 2015年 zhangcheng. All rights reserved.
//

#import "ThemeManager.h"
#import "ZipArchive.h"
@implementation ThemeManager
static ThemeManager*manager=nil;
+(instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[ThemeManager alloc]init];
    
    });
    return manager;
}
-(instancetype)init
{
    if (self=[super init]) {
     //读取本地数据持久化的plist文件
        self.plistPath=[NSString stringWithFormat:@"%@downLoadTheme.plist",LIBPATH];
        self.dataArray=[NSMutableArray arrayWithContentsOfFile:self.plistPath];
        if (self.dataArray==nil) {
            self.dataArray=[NSMutableArray arrayWithCapacity:0];
        }

    }
    return self;
}
-(BOOL)themeDownLoadData:(NSDictionary *)dic Block:(void (^)(BOOL))a
{
    //先记录数据
    self.dic=dic;
    //记录block指针
    self.myBlock=a;
    //记录主题
    self.themeName=dic[@"name"];
    //判断是否是已经下载过的主题
    if ([self.dataArray containsObject:self.themeName]) {
        //是已经下载过的主题
        NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
        [user setObject:self.themeName forKey:THEME];
        [user synchronize];
        //发送广播
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
        return YES;
        
    }else{
        //开始进行下载
        HttpDownLoadBlock*request=[[HttpDownLoadBlock alloc]initWithStrUrl:self.dic[@"url"] Block:^(BOOL isSucceed, HttpDownLoadBlock *http) {
            if (isSucceed) {
                //成功
                //写入文件
                NSString*savePath=[NSString stringWithFormat:@"%@com.zip",LIBPATH];
                [http.data writeToFile:savePath atomically:YES];
                //解压缩
                NSString*unZipPath=[NSString stringWithFormat:@"%@%@",LIBPATH,self.themeName];
                ZipArchive*unZip=[[ZipArchive alloc]init];
                [unZip UnzipOpenFile:savePath];
                [unZip UnzipFileTo:unZipPath overWrite:YES];
                [unZip CloseZipFile2];
                //记录主题
                NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
                [user setObject:self.themeName forKey:THEME];
                [user synchronize];
                //同步下载列表
                [self.dataArray addObject:self.themeName];
                [self.dataArray writeToFile:self.plistPath atomically:YES];
                //发送广播
                [[NSNotificationCenter defaultCenter]postNotificationName:THEME object:nil];
                if (self.myBlock) {
                    self.myBlock(YES);
                }
                
                
            }else{
                //失败
                if (self.myBlock) {
                    self.myBlock(NO);
                }
            }
        }];
        
    
        return NO;
    }
    


}
@end






