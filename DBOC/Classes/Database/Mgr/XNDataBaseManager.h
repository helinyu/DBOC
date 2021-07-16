//
//  XNNewDataBaseManager.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionBaseProvider.h"
#import "XNDataBaseConstonts.h"
@class XNDataBaseTableConfig, XNDataBaseActionConfig;


#define kDBMgr ([XNDataBaseManager shareManager])

NS_ASSUME_NONNULL_BEGIN

@interface XNDataBaseManager : NSObject

+ (instancetype)shareManager;

// 表操作
- (BOOL)createTableFromClass:(Class)tableClass config:(XNDataBaseTableConfig  *_Nullable)config;

//数据操作
- (void)action:(XNDataBaseActionType)actionType builder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock)resultBlock;


// convinice method
- (void)selectBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock)resultBlock;
- (void)updateBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock)resultBlock;
- (void)deleteBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock)resultBlock;
- (void)insertBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
