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


#define kCreateFromCls(cls,c) ([kDBMgr createTableFromClass:cls.class config:c])

NS_ASSUME_NONNULL_BEGIN

@interface XNDataBaseManager : NSObject

- (void)executeUpdateSql:(NSString *)sql; // 保留原生的执行sql的语句

+ (instancetype)shareManager;


// 表操作
- (BOOL)createTableFromClass:(Class)tableClass config:(XNDataBaseTableConfig  *_Nullable)config;

//数据操作
- (void)action:(XNDataBaseActionType)actionType builder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;


// convinice method
- (void)selectBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
- (void)updateBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
- (void)deleteBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
- (void)insertBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;

#pragma mark - sync method
// 同步的的请求方式， 这个不推荐使用

- (NSDictionary *)syncAction:(XNDataBaseActionType)actionType builder:(DatabaseActionConfigBlock)builderBlock;

- (NSDictionary *)syncSelectBuilder:(DatabaseActionConfigBlock)builderBlock;
- (NSDictionary *)syncUpdateBuilder:(DatabaseActionConfigBlock)builderBlock;
- (NSDictionary *)syncDeleteBuilder:(DatabaseActionConfigBlock)builderBlock;
- (NSDictionary *)syncInsertBuilder:(DatabaseActionConfigBlock)builderBlock;

@end

NS_ASSUME_NONNULL_END
