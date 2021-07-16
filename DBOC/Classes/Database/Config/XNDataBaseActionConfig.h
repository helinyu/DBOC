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

#define b_table(x) bindTableName(x.class)
#define b_tableClass(x) bindTableMapClass(x.class)
#define b_class(x) bindObjcClass(x.class)
#define b_cls(x) b_class(x)

#define b_batchList(x) bindBatchList(x)

#define b_keyField(x) bindConditionValue(x)
#define b_keyValue(x) bindConditionValue(x)
#define b_relate(x) bindRelative(x)
#define b_linkWord(x) bindLinkword(x)
#define b_inequality(x,y,z) bindInequality(x, y, z)

//bindWhereF
#define whereF(field) bindWhereF(field)
#define where(x, y, z) bindWhere(x,y,z)
//#define where(...) bindWhere(__VA_ARGS__)

#define b_equalTo(x) bindEqualTo(x)
#define b_lessOrEqualTo(x) bindLessThanOrEqual(x)
#define b_lessThan(x) bindLessThan(x)
#define b_greaterThen(x) bindGreaterThan(x)
#define b_greaterOrEqualTo(x) bindGreaterThanOrEqual(x)
#define b_notEqualTo(x) bindNotEqual(x)
#define b_In(x) bindIn(x)

@interface XNDataBaseActionConfig : NSObject

@property (nonatomic, assign) XNDataBaseActionType actionType; // 操作的类型

@property (nonatomic, copy, readonly) NSString *tableName;// 对应的表的名字
@property (nonatomic, copy, readonly) Class tableMapClass;// table 映射的对象
@property (nonatomic, copy, readonly) Class objectClass;// 数据使用的对象

-(XNDataBaseActionConfig * (^)(NSString *tableName))bindTableName;
-(XNDataBaseActionConfig * (^)(Class cls))bindTableMapClass;
-(XNDataBaseActionConfig * (^)(Class cls))bindObjcClass;

-(XNDataBaseActionConfig * (^)(id cls))bindT;

@property (nonatomic, assign) BOOL keepOriginData; // 返回数据是否转化为模型， YES: 不转化array 、 dictionary NO: 转化， 默认是转化
-(XNDataBaseActionConfig * (^)(BOOL))bindKeepOrigin;

@property (nonatomic, strong, readonly) XNDataBaseActionLinkWord *firstLinkWordCondition; // 连接词的处理
@property (nonatomic, strong, readonly) XNDataBaseActionLinkWord *currentLinkWordCondition; // 当前的连接词处理

-(XNDataBaseActionConfig * (^)(XNDataValueRelation relation))bindRelative;
-(XNDataBaseActionConfig * (^)(id conditionValue))bindConditionValue;
-(XNDataBaseActionConfig * (^)(XNDataBaseActionLinkWordType linkword))bindLinkword;

- (XNDataBaseActionConfig * (^)(id keyfield, XNDataValueRelation relate, id value))bindInequality; // 控制的条件

- (XNDataBaseActionConfig * (^)(XNDataBaseActionLinkWordType linkword,id keyfield, XNDataValueRelation relate, id value))bindCondition; // 控制的条件
- (XNDataBaseActionConfig * (^)(id keyfield, XNDataValueRelation relate, id value))bindWhere; // where的情况下
- (XNDataBaseActionConfig * (^)(id keyfield))bindWhereF; // where的情况下

- (XNDataBaseActionConfig * (^)(void))bindAnd; // and 的情况下
- (XNDataBaseActionConfig * (^)(id keyField))bindAndF; // and 的情况下

- (XNDataBaseActionConfig * (^)(NSInteger count))limitCount; // limit count 的情况下

// 排列
- (XNDataBaseActionConfig * (^)(NSString *keyField, NSString *desc,xnDataBaseValueType caseType))orderbyCast; // limit count 的情况下
- (XNDataBaseActionConfig * (^)(NSString *keyField, NSString *desc))orderby; // limit count 的情况下



//  有关的不等式
- (XNDataBaseActionConfig * (^)(id value))bindEqualTo;
- (XNDataBaseActionConfig * (^)(id value))bindLessThanOrEqual;
- (XNDataBaseActionConfig * (^)(id value))bindLessThan;
- (XNDataBaseActionConfig * (^)(id value))bindGreaterThan;
- (XNDataBaseActionConfig * (^)(id value))bindGreaterThanOrEqual;
- (XNDataBaseActionConfig * (^)(id value))bindNotEqual;
- (XNDataBaseActionConfig * (^)(id value))bindIn;
- (XNDataBaseActionConfig * (^)(id value))bindNotIn;


#pragma mark - 查询
@property (nonatomic, strong, readonly) NSArray<NSString *> *queryColumnFields; // 查询指定的字段
-(XNDataBaseActionConfig * (^)(NSArray<NSString *> *))bindQueryColumnFields; // 如果这个值设置了，默认返回的不是对象模型

#pragma mark - 插入
@property (nonatomic, strong, readonly) id insertData;
-(XNDataBaseActionConfig * (^)(id insertData))bindInsertData;

@property (nonatomic, strong, readonly) NSArray *batchlist;  // 插入、更新批量的
-(XNDataBaseActionConfig * (^)(NSArray *insertList))bindBatchList;

@property (nonatomic, assign) BOOL batch; // 批量处理
-(XNDataBaseActionConfig * (^)(NSArray *insertList))bindBatch;

#pragma mark - 删除
@property (nonatomic, strong, readonly) id deleteData; // 删除的数据
-(XNDataBaseActionConfig * (^)(id deleteData))bindDeleteData;
@property (nonatomic, assign, readonly) BOOL deleteAll; // 判断是否删除全部
-(XNDataBaseActionConfig * (^)(BOOL deleteAll))bindDeleteAll;

#pragma mark - 更新
@property (nonatomic, strong, readonly) id updateData; // 更新一个对象 + where 判断条件 【必须要有判断条件】
-(XNDataBaseActionConfig * (^)(id updateData))bindUpdateData;

@property (nonatomic, strong, readonly) NSDictionary *settingListData; // 更新一个对象里面的几个属性 ， 判断条件 （这个可以没有判断条件，表示的是所有的） , 这个地方可能是更新、或者删除
-(XNDataBaseActionConfig * (^)(NSDictionary *settingListData))bindsettingListData;


@end

NS_ASSUME_NONNULL_END
