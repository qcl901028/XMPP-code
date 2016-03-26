//
//  WFMessageModel.m
//  WFQQChat
//
//  Created by lzxuan on 15/10/8.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "WFMessageModel.h"

@implementation WFMessageModel

+ (instancetype)messageWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
