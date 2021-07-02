//
//  XNDatabaseModelProtocol.h
//  xndm_proj
//
//  Created by xn on 2021/6/28.
//  Copyright © 2021 Linfeng Song. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XNDatabaseModelProtocol <NSObject>

//@property (nonatomic, assign) NSInteger dbId; // 数据库的id

+ (BOOL)isCacheDBFromCurrentClass; // 是否从当前页面开始遍历属性进行缓存, default:NO


// whitelist > blackList
+ (NSArray<Class> *)whiteList; // 白名单 default:[]
+ (NSArray<Class> *)blackList; // 黑名单 default:[]

@end

NS_ASSUME_NONNULL_END
