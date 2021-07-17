//
//  NSDictionary+DBAdd.h
//  Pods
//
//  Created by xn on 2021/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (DBAdd)

- (id)db_data; // 结果
- (BOOL)db_actionSuc; //执行是否成功

@end

NS_ASSUME_NONNULL_END
