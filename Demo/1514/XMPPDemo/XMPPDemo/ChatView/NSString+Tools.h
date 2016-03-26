//
//  NSString+Tools.h
//  KillAllFree
//
//  Created by lzxuan on 15/9/24.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Tools)
NSString * URLEncodedString(NSString *str);
NSString * MD5Hash(NSString *aString);
/**
 *  计算字符串 CGSize
 *
 *  @param font    字符串的 font
 *  @param maxSize  字符串的最大显示的 CGSize
 *
 *  @return  字符串实际的CGSize
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
