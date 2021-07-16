//
//  XNDatabaseModel.h
//  xndm_proj
//
//  Created by xn on 2021/6/28.
//  Copyright © 2021 Linfeng Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XNDatabaseModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN


// 所有的类都需要继承这个类
@interface XNDatabaseModel : NSObject <XNDatabaseModelProtocol>

- (NSArray *)getValues:(NSArray<NSString *> *)keys;
- (NSDictionary *)getValueDictList:(NSArray<NSString *> *)keys;

@end

NS_ASSUME_NONNULL_END
