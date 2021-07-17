//
//  XNNewDataBaseManager.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseManager.h"

#import <FMDB/FMDB.h>
#import <objc/runtime.h>

#import "XNDatabaseModelProtocol.h"
#import "XNDatabaseModel.h"
#import "XNDataBaseActionConfig.h"
#import "XNDataBaseTableConfig.h"
#import "XNDataBaseHelper.h"

static NSString *const kdbId = @"dbId";
static NSString *const kNewAddKey = @"new_add";
static NSString *const kNewMinuKey = @"new_minu";

@interface XNDataBaseManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation XNDataBaseManager

- (void)executeUpdateSql:(NSString *)sql{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}


#pragma mark -- 创建数据库

+ (instancetype)shareManager {
    static XNDataBaseManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] initPrivate];
        }
    });
    return manager;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self createDB];
    }
    return self;
}

- (void)createDB {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"app.db"];
    NSLog(@"lt - dbPath:%@",dbPath);
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
}

#pragma mark - 创建数据表

- (BOOL)createTableFromClass:(Class)tableClass config:(XNDataBaseTableConfig  *_Nullable)config {
    return [self createTableFromClass:tableClass withTableName:NSStringFromClass([tableClass class]) config:config];
}

- (BOOL)createTableFromClass:(Class)tableClass withTableName:(NSString *)tableName config:(XNDataBaseTableConfig *)config {
    
    if (![XNDataBaseHelper getTableMapClassWithObjcClass:tableClass]) {
#if DEBUG
        NSAssert(1>2, @"数据库模型需要 是 XNDatabaseModel 的子类 【暂时】");
#endif
        return NO;
    }
    
    tableClass = [XNDataBaseHelper getTableMapClassWithObjcClass:tableClass];
    
    NSDictionary *dict = [XNDataBaseHelper getPropertiesFromClass:tableClass];
    NSArray *properties = dict.allKeys;
    
    if (![self tableExist:tableName]) {
        NSString * createSql = [self __getCreateSqlWithProperties:properties tableName:tableName primaryKey:config.primaryKey];
        __block BOOL suc;
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            suc = [db executeUpdate:createSql];
        }];
        return suc;
    }
    
    // (3)  表是存在的
    // 判断和原来的数据是否相同？ 1>保存原来的数据，需要迁移数据 2》 不需要迁移数据
    NSDictionary *changeDict = [self __checkChangedPropertiesOfTableName:tableName newColumns:[NSSet setWithArray:properties]];
    if (changeDict.count <=0) { // 数据库表没有改变
        return YES;
    }
    
    __block BOOL suc = YES;
    if (config.keepOriginData) {
        NSString *tempTalbeName = [NSString stringWithFormat:@"%@_temp",tableName];
        NSString *createSql = [self __getCreateSqlWithProperties:properties tableName:tempTalbeName primaryKey:config.primaryKey];
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            suc = [db executeUpdate:createSql];
        }];
        
        NSString *selectProperty = [properties componentsJoinedByString:@","];
        NSString *selectSql = [NSString stringWithFormat:@"select %@ from %@",selectProperty, tableName];
        
        __block NSArray *arr = [self __getObjectsOfClass:tableClass withSql:selectSql];

        if (arr.count >0) {
            [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:tableClass]) {
                        NSString *sql = [self getInsertSql:obj tableName:tempTalbeName];
                        NSArray *valuesArray = [XNDataBaseHelper getValuesFromObject:obj];
                        [db executeUpdate:sql withArgumentsInArray:valuesArray];
                        
                        if(db.lastErrorCode > 0){
                            *rollback = YES;
                            NSLog(@"db异常：%@",db.lastErrorMessage);
                            return;
                        }
                    }
                }];
            }];
            
            NSString *alterNewTableName = [NSString stringWithFormat:@"alter table %@ rename to %@;",tempTalbeName, tableName];
            [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
                suc = [db executeUpdate:alterNewTableName];
            }];
        }
    }
    else {
        NSString *createSql = [self __getCreateSqlWithProperties:properties tableName:tableName primaryKey:config.primaryKey];
        NSString *dropSql = [NSString stringWithFormat:@"drop table %@",tableName];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:dropSql];
        }];
        
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            suc = [db executeUpdate:createSql];
        }];
    }
    return suc;
}

- (NSString *)__getCreateSqlWithProperties:(NSArray<NSString *> *)properties tableName:(NSString *)tableName primaryKey:(NSString *)primaryKey {
    if (primaryKey.length >0) {
        NSMutableArray<NSString *> *mProperties = [properties mutableCopy];
        [mProperties removeObject:primaryKey];
        
        NSString * propertiesStr = [properties componentsJoinedByString:@" TEXT NOT NULL, "];
        propertiesStr = [propertiesStr stringByAppendingString:@" TEXT NOT NULL"];
        NSString * createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT NOT NULL PRIMARY KEY , %@);", primaryKey, tableName, propertiesStr];
        return createSql;
    }
    else {
        NSString * propertiesStr = [properties componentsJoinedByString:@" TEXT NOT NULL, "];
        propertiesStr = [propertiesStr stringByAppendingString:@" TEXT NOT NULL"];
        NSString * createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE, %@);", tableName, kdbId, propertiesStr];
        return createSql;
    }
}

// 根据SQL语句查询记录
- (NSArray *)__getObjectsOfClass:(Class)tableClass withSql:(NSString *)sql {
    __block NSMutableArray *objectsArray = [NSMutableArray arrayWithCapacity:0];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        // 获取属性列表
        NSMutableArray * propArray = [[XNDataBaseHelper getPropertiesFromClass:tableClass].allKeys mutableCopy];
        while ([resultSet next]) {
            // 创建对象，通过class创建对象
            id object = [[tableClass alloc] init];
            // 遍历字段列表
            for (NSString * prop in propArray) {
                // 从结果集中获取指定列的数据
                id value = [resultSet objectForColumn:prop];
                // 通过KVC方式为对象赋值
                [object setValue:(value == [NSNull null] ? @"":value) forKey:prop];
            }
            // 将对象添加到数组中
            [objectsArray addObject:object];
        }
    }];
    return objectsArray;
}

- (id)excuteAction:(XNDataBaseActionType)actionType sql:(NSString *)sql valuesArray:(NSArray *)valuesArray batch:(BOOL)batch list:(NSArray *)list {
    if (!batch) {
        if (actionType == XNDataBaseActionTypeSelect) {
            __block FMResultSet *resultSet;
            [_dbQueue inDatabase:^(FMDatabase *db) {
                resultSet = [db executeQuery:sql];
            }];
            return resultSet;
        }
        
        if (actionType == XNDataBaseActionTypeInsert) {
            __block BOOL isSuccess;
            [_dbQueue inDatabase:^(FMDatabase *db) {
                isSuccess = [db executeUpdate:sql withArgumentsInArray:valuesArray];
            }];
            return @(isSuccess);
        }
        
        if (actionType == XNDataBaseActionTypeDelete) {
            __block BOOL isSuccess;
            [_dbQueue inDatabase:^(FMDatabase *db) {
                isSuccess = [db executeUpdate:sql withArgumentsInArray:valuesArray];
            }];
            return @(isSuccess);
        }
        
        if (actionType == XNDataBaseActionTypeUpdate) {
            __block BOOL isSuccess;
            [_dbQueue inDatabase:^(FMDatabase *db) {
                isSuccess = [db executeUpdate:sql];
            }];
            return @(isSuccess);
        }
        return nil;
    }
    else {
        if (actionType == XNDataBaseActionTypeInsert) {
            __block BOOL suc = YES;
            [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSArray *valuesArray = [XNDataBaseHelper getValuesFromObject:obj];
                        [db executeUpdate:sql withArgumentsInArray:valuesArray];
                        
                        if(db.lastErrorCode > 0){
                            *rollback = YES;
                            NSLog(@"db异常：%@",db.lastErrorMessage);
                            suc = NO;
                        }
                }];
            }];
            return @(suc);
        }
        return nil;
    }
}

- (void)action:(XNDataBaseActionType)actionType builder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        XNDataBaseActionConfig *config = [XNDataBaseActionConfig new];
        config.actionType = actionType;
        !builderBlock? :builderBlock(config);
        [XNDataBaseActionBaseProvider fireAction:actionType config:config resultBlock:resultBlock buildSql:^id(NSString *sql, NSArray *values) {
            return [self excuteAction:actionType sql:sql valuesArray:values batch:config.batch list:config.batchlist];
        }];
    });
}

// convinice method
- (void)selectBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
{
    [self action:XNDataBaseActionTypeSelect builder:builderBlock then:resultBlock];
}
- (void)updateBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
{
    [self action:XNDataBaseActionTypeUpdate builder:builderBlock then:resultBlock];
}
- (void)deleteBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
{
    [self action:XNDataBaseActionTypeDelete builder:builderBlock then:resultBlock];
}
- (void)insertBuilder:(DatabaseActionConfigBlock)builderBlock then:(DataBaseActionResultBlock _Nullable)resultBlock;
{
    [self action:XNDataBaseActionTypeInsert builder:builderBlock then:resultBlock];
}


// sync method 同步方法
- (NSDictionary *)syncAction:(XNDataBaseActionType)actionType builder:(DatabaseActionConfigBlock)builderBlock;
{
    __block NSMutableDictionary *mDict = [NSMutableDictionary new];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        XNDataBaseActionConfig *config = [XNDataBaseActionConfig new];
        config.actionType = actionType;
        !builderBlock? :builderBlock(config);
        [XNDataBaseActionBaseProvider fireAction:actionType config:config resultBlock:^(BOOL result, id value){
            [mDict setObject:@(result) forKey:kDB_actionFlagKey];
            [mDict setObject:value forKey:kDB_actionResultKey];
            dispatch_semaphore_signal(semaphore);
        } buildSql:^id(NSString *sql, NSArray *values) {
            return [self excuteAction:actionType sql:sql valuesArray:values batch:config.batch list:config.batchlist];
        }];
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return [mDict copy];
}

- (NSDictionary *)syncSelectBuilder:(DatabaseActionConfigBlock)builderBlock;
{
    return [self syncAction:XNDataBaseActionTypeSelect builder:builderBlock];
}
- (NSDictionary *)syncUpdateBuilder:(DatabaseActionConfigBlock)builderBlock;
{
    return [self syncAction:XNDataBaseActionTypeUpdate builder:builderBlock];
}
- (NSDictionary *)syncDeleteBuilder:(DatabaseActionConfigBlock)builderBlock;
{
    return [self syncAction:XNDataBaseActionTypeDelete builder:builderBlock];
}
- (NSDictionary *)syncInsertBuilder:(DatabaseActionConfigBlock)builderBlock;
{
   return [self syncAction:XNDataBaseActionTypeInsert builder:builderBlock];
}

#pragma mark - help method

- (BOOL)tableExist:(NSString *)tableName {
    __block BOOL existed = NO;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        existed = [db tableExists:tableName];
    }];
    return existed;
}

- (NSString *)getInsertSql:(id)object {
    // 获取对象的class
    Class objcClass = [object class];
    
    // 获取类名
    NSString * tableName = NSStringFromClass(objcClass);
    
    // 获取属性列表
    NSMutableArray * propertiesArray = [[XNDataBaseHelper getPropertiesFromClass:objcClass].allKeys mutableCopy];
    
    NSString * propStr = [propertiesArray componentsJoinedByString:@", "];
    
    // 创建问号
    NSMutableArray * placeHolderArray = [NSMutableArray array];
    [propertiesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [placeHolderArray addObject:@"?"];
    }];
    
    NSString * placeHolderStr = [placeHolderArray componentsJoinedByString:@", "];
    
    NSString * insertSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@) ", tableName, propStr, placeHolderStr];
    
    return insertSql;
}

- (NSString *)getInsertSql:(id)object tableName:(NSString *)tn {
    // 获取对象的class
    Class objcClass = [object class];
    
    // 获取类名
    NSString * tableName = tn.length >0? tn: NSStringFromClass(objcClass);
    
    // 获取属性列表
    NSMutableArray * propertiesArray = [[XNDataBaseHelper getPropertiesFromClass:objcClass].allKeys mutableCopy];
    
    NSString * propStr = [propertiesArray componentsJoinedByString:@", "];
    
    // 创建问号
    NSMutableArray * placeHolderArray = [NSMutableArray array];
    [propertiesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [placeHolderArray addObject:@"?"];
    }];
    
    NSString * placeHolderStr = [placeHolderArray componentsJoinedByString:@", "];
    
    NSString * insertSql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@) ", tableName, propStr, placeHolderStr];
    
    return insertSql;
}

// 数据库发生了改变
- (NSDictionary *)__checkChangedPropertiesOfTableName:(NSString *)tableName newColumns:(NSSet<NSString *> *)newColumns {
    NSSet<NSString *> *columns = [self __getAllColumnsOfTable:tableName];
    NSMutableSet<NSString *> *mColumns = [columns mutableCopy];
    if ([mColumns containsObject:kdbId]) {
        [mColumns removeObject:kdbId];
    }
    
    NSMutableSet<NSString *> *newLeftColumns = [newColumns mutableCopy];
    [newLeftColumns minusSet:mColumns];
    
    [mColumns minusSet:newColumns];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (newLeftColumns.count >0) {
        [dict setObject:newLeftColumns forKey:kNewAddKey];
    }
    if (mColumns.count >0) {
        [dict setObject:mColumns forKey:kNewMinuKey];
    }
    return dict;
}

- (NSSet *)__getAllColumnsOfTable:(NSString *)tableName {
    __block NSMutableSet *columns = [NSMutableSet new];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db getTableSchema:tableName];
        //check if column is present in table schema
        while ([rs next]) {
            [columns addObject:[rs stringForColumn:@"name"]];
        }
        [rs close];
    }];
    return columns;
}


@end
