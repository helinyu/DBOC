//
//  XNDataBaseConstonts.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#ifndef XNDataBaseConstonts_h
#define XNDataBaseConstonts_h
#import <Foundation/Foundation.h>

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
    XNDataValueRelationNotIn =8, //不在里面 not in 在后面是一个数组，或者逗号隔开的字符串
    XNDataValueRelationPlaceholder , // 占位的关系， eg: orderby
};

// 增删改查
typedef NS_ENUM(NSInteger, XNDataBaseActionType) {
    XNDataBaseActionTypeSelect = 1,
    XNDataBaseActionTypeDelete = 2,
    XNDataBaseActionTypeInsert = 3,
    XNDataBaseActionTypeUpdate = 4,
};

#define DB_ASCE @"asce" // 递增
#define DB_DESC @"desc" // 递减

typedef NS_ENUM(NSInteger, xnDataBaseValueType) {
    xnDataBaseValueTypeInt = 1,
    xnDataBaseValueTypeString = 2,
    xnDataBaseValueTypeBool = 3,
};

#define DB_ASCE @"asce" // 递增
#define DB_DESC @"desc" // 递减

#define kAll @"*"   // sql 语句中的所有

#define kDB_actionFlagKey @"dboc.action.suc.flag"
#define kDB_actionResultKey @"dboc.action.result"


// 有关的关系
// 白名单 > 黑名单
// 外面设置的名单 >  model 上的名单


typedef void(^DatabaseActionConfigBlock)(XNDataBaseActionConfig * config);
typedef void(^DataBaseActionResultBlock)(BOOL result,id _Nullable value);
typedef id(^DataBaseActionBuildSqlBlock)(NSString *sql, NSArray *values);

#define kClassField(CLASS, field) @(((void)(NO && ((void)((CLASS *)(nil)).field, NO)), #field))
#define kCP(cls, field) kClassField(cls, field)




#endif /* XNDataBaseConstonts_h */


#ifdef __cplusplus
extern "C" {
#endif

static const NSString * _Nullable stringForValueType(xnDataBaseValueType valueType) {
    if (valueType == xnDataBaseValueTypeInt) {
        return @"Int";
    }
    
    if (valueType == xnDataBaseValueTypeString) {
        return @"string";
    }
    
    if (valueType == xnDataBaseValueTypeBool) {
        return @"bool";
    }
    return @"";
}

static const NSString * _Nullable db_field_length(NSString * _Nullable keyfield) {
   return [NSString stringWithFormat:@"length(%@)",keyfield];
}

//cast(sortIndex as int)

static const NSString * _Nullable db_cast(NSString * _Nullable keyfield, xnDataBaseValueType valueType) {
    return [NSString stringWithFormat:@"cast(%@ as %@)",keyfield, stringForValueType(valueType)];
}

static const NSString * _Nullable db_alias_feild_name(NSString * keyfield, NSString *aliasName) {
    return [NSString stringWithFormat:@" %@ as %@ ",keyfield, aliasName];
}

static const NSString * _Nullable db_datetime(NSString *keyfield, NSString *unixepoch, NSString *localtime) {
    return [NSString stringWithFormat:@"datetime(%@,'%@','%@')",keyfield, unixepoch, localtime];
}


#ifdef __cplusplus
}
#endif
