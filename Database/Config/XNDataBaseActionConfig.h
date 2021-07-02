//
//  XNDataBaseActionConfig.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDatabaseModel.h"
#import "XNDataBaseConstonts.h"
#import "XNDataBaseActionLinkWord.h"


NS_ASSUME_NONNULL_BEGIN

// 目前暂时支持单个 更新和插入， 批量的删除和插入还需要处理

@interface XNDataBaseActionConfig : NSObject

@property (nonatomic, assign) XNDataBaseActionType actionType; // 操作的类型

@property (nonatomic, copy, readonly) NSString *tableName;// 对应的表的名字
@property (nonatomic, copy, readonly) Class tableMapClass;// table 映射的对象
@property (nonatomic, copy, readonly) Class objectClass;// 数据使用的对象

-(XNDataBaseActionConfig * (^)(NSString *tableName))bindTableName;
-(XNDataBaseActionConfig * (^)(Class cls))bindTableMapClass;
-(XNDataBaseActionConfig * (^)(Class cls))bindObjcClass;

@property (nonatomic, assign) BOOL keepOriginData; // 返回数据是否转化为模型， YES: 不转化array 、 dictionary NO: 转化， 默认是转化
-(XNDataBaseActionConfig * (^)(BOOL))bindKeepOrigin;

@property (nonatomic, strong, readonly) XNDataBaseActionLinkWord *firstLinkWordCondition; // 连接词的处理
@property (nonatomic, strong, readonly) XNDataBaseActionLinkWord *currentLinkWordCondition; // 当前的连接词处理

-(XNDataBaseActionConfig * (^)(XNDataValueRelation relation))relative;
-(XNDataBaseActionConfig * (^)(id conditionValue))conditionValue;
-(XNDataBaseActionConfig * (^)(XNDataBaseActionLinkWordType linkword))linkword;

#pragma mark - 查询
@property (nonatomic, strong, readonly) NSArray<NSString *> *queryColumnFields; // 查询指定的字段
-(XNDataBaseActionConfig * (^)(NSArray<NSString *> *))bindQueryColumnFields; // 如果这个值设置了，默认返回的不是对象模型

#pragma mark - 插入
@property (nonatomic, strong, readonly) id insertData;
-(XNDataBaseActionConfig * (^)(id insertData))bindInsertData;

#pragma mark - 删除
@property (nonatomic, strong, readonly) id deleteData; // 删除的数据
-(XNDataBaseActionConfig * (^)(id deleteData))bindDeleteData;
@property (nonatomic, assign, readonly) BOOL deleteAll; // 判断是否删除全部
-(XNDataBaseActionConfig * (^)(BOOL deleteAll))bindDeleteAll;

#pragma mark - 更新
@property (nonatomic, strong, readonly) id updateData; // 更新一个对象 + where 判断条件 【必须要有判断条件】
-(XNDataBaseActionConfig * (^)(id updateData))bindUpdateData;

@property (nonatomic, strong, readonly) NSDictionary *updateListData; // 更新一个对象里面的几个属性 ， 判断条件 （这个可以没有判断条件，表示的是所有的）
-(XNDataBaseActionConfig * (^)(NSDictionary *updateListData))bindUpdateListData;

@end


NS_ASSUME_NONNULL_END
