//
//  XNDatabaseModel.m
//  xndm_proj
//
//  Created by xn on 2021/6/28.
//  Copyright © 2021 Linfeng Song. All rights reserved.
//

#import "XNDatabaseModel.h"

@implementation XNDatabaseModel

//@synthesize dbId;

+ (BOOL)isCacheDBFromCurrentClass; // 这个数据是否缓存在数据库
{
    return NO;
}

+ (NSArray<Class> *)whiteList; // 模型白名单
{
    return @[];
}
+ (NSArray<Class> *)blackList; // 模型黑名单
{
    return @[];
}

@end
