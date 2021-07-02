//
//  XNDataBaseActionBaseProvider.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import <Foundation/Foundation.h>
#import "XNDataBaseConstonts.h"

NS_ASSUME_NONNULL_BEGIN

@interface XNDataBaseActionBaseProvider : NSObject

+ (void)fireAction:(XNDataBaseActionType)actionType config:(XNDataBaseActionConfig *)config resultBlock:(DataBaseActionResultBlock)resultBlock;
+ (void)fireAction:(XNDataBaseActionType)actionType config:(XNDataBaseActionConfig *)config resultBlock:(DataBaseActionResultBlock)resultBlock buildSql:(DataBaseActionBuildSqlBlock)buildSqlBlock;

@property (nonatomic, assign) XNDataBaseActionType actionType;
@property (nonatomic, strong) XNDataBaseActionConfig *config;
@property (nonatomic, copy) DataBaseActionResultBlock resultBlock;
@property (nonatomic, copy) DataBaseActionBuildSqlBlock buildSqlBlock;

- (void)fireAction;

@end

NS_ASSUME_NONNULL_END
