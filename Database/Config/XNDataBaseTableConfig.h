//
//  XNDataBaseTableConfig.h
//  xndm_proj
//
//  Created by xn on 2021/7/1.
//  Copyright © 2021 Linfeng Song. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNDataBaseTableConfig : NSObject

@property (nonatomic, assign) BOOL keepOriginData; // 是否保留以前的数据

@property (nonatomic, copy) NSString *conditionSql; // 判断条件，如果符合，就不进行下一步操作
@property (nonatomic, assign) BOOL conditionAction; // YES， 往下执行， NO: 直接返回
@property (nonatomic) id conditionData;// 控制的数据

// 这个是公共的内容
@property (nonatomic, strong) NSArray<NSString *> *whiteList; // 白名单
@property (nonatomic, strong) NSArray<NSString *> *blackList; // 黑名单
@property (nonatomic, strong) NSString *primaryKey; // 主键， 如果为空，就是dbId ， 这个当然是不可以重复的
@property (nonatomic, strong) NSArray<NSString *> *uniqueValues; // 唯一值，不可以重复

@end

NS_ASSUME_NONNULL_END
