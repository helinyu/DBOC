//
//  XNDataBaseConstonts.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#ifndef XNDataBaseConstonts_h
#define XNDataBaseConstonts_h

@class XNDataBaseActionConfig;

// 数据的关系
typedef NS_ENUM(NSInteger, XNDataValueRelation) {
    XNDataValueRelationUnvalid = 0, 
    XNDataValueRelationLessThanOrEqual = 1, //小于等于
    XNDataValueRelationLessThan = 2, // 小于
    XNDataValueRelationEqual = 3, // 等于
    XNDataValueRelationGreaterThan = 4, // 大于
    XNDataValueRelationGreaterThanOrEqual = 5, // 大于等于
    XNDataValueRelationNotEqual = 6, // 不等于
    XNDataValueRelationIn = 7, // 在哪个里面
    XNDataValueRelationPlaceholder = 8, // 占位的关系， eg: orderby
};

// 增删改查
typedef NS_ENUM(NSInteger, XNDataBaseActionType) {
    XNDataBaseActionTypeSelect = 1,
    XNDataBaseActionTypeDelete = 2,
    XNDataBaseActionTypeInsert = 3,
    XNDataBaseActionTypeUpdate = 4,
};

#define ASCE asce // 递增
#define DESC desc // 递减

// 有关的关系
// 白名单 > 黑名单
// 外面设置的名单 >  model 上的名单


typedef void(^DatabaseActionConfigBlock)(XNDataBaseActionConfig * config);
typedef void(^DataBaseActionResultBlock)(BOOL result,id _Nullable value);
typedef id(^DataBaseActionBuildSqlBlock)(NSString *sql, NSArray *values);

#define kClassField(CLASS, field) @(((void)(NO && ((void)((CLASS *)(nil)).field, NO)), #field))
#define kCP(cls, field) kClassField(cls, field)

#endif /* XNDataBaseConstonts_h */
