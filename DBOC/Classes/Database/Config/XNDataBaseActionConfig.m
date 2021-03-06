//
//  XNDataBaseActionConfig.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionConfig.h"
#import "XNDataBaseActionLinkWord.h"
#import "XNDataBaseHelper.h"

@interface XNDataBaseActionConfig ()

@end

#warning - 还有白名单和黑名单需要处理

@implementation XNDataBaseActionConfig

-(XNDataBaseActionConfig * (^)(NSString *tableName))bindTableName{
    return ^id(NSString *tableName) {
        self->_tableName = tableName;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(Class cls))bindTableMapClass
{
    return ^id(Class cls) {
        if (!self.objectClass) {
            self->_objectClass = cls;
        }
        
        if (self.tableName.length <=0) {
            self->_tableName = NSStringFromClass(cls);
        }
        
        self->_tableMapClass = cls;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(id cls))bindT;
{
    return ^id(id cls) {
        self->_tableMapClass = [cls class];
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(Class cls))bindObjcClass{
    return ^id(Class cls) {
        if (!self.tableMapClass) {
            self->_tableMapClass = [XNDataBaseHelper getTableMapClassWithObjcClass:cls];
        }
        
        if (self.tableName.length <=0) {
            self->_tableName = NSStringFromClass(self.tableMapClass);
        }
        
        self->_objectClass = cls;
        return self;
    };
}


-(XNDataBaseActionConfig * (^)(NSArray<NSString *> *))bindQueryColumnFields{
    return ^id(NSArray<NSString *> * columnFields){
        self->_queryColumnFields = columnFields;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(id insertData))bindInsertData;
{
    return ^id(id insertData){
        self->_insertData = insertData;
        return self;
    };
}


-(XNDataBaseActionConfig * (^)(NSArray *batchList))bindBatchList;
{
    return ^id(NSArray *batchList){
        self->_batchlist= batchList;
        self->_batch = YES;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(id deleteData))bindDeleteData;
{
    return ^id(id deleteData){
        self->_deleteData = deleteData;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(BOOL deleteAll))bindDeleteAll;
{
    return ^id(BOOL deleteAll){
        self->_deleteAll = deleteAll;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(BOOL))bindKeepOrigin{
    return ^id(BOOL keepOriginData){
        self.keepOriginData = keepOriginData;
        return self;
    };
}


-(XNDataBaseActionConfig * (^)(XNDataBaseActionLinkWordType linkword))bindLinkword{
    return ^id(XNDataBaseActionLinkWordType linkword) {
        if (!self.currentLinkWordCondition) {
            XNDataBaseActionLinkWord *newLinkWord = [XNDataBaseActionLinkWord new];
            newLinkWord.linkWord = linkword;
            self->_currentLinkWordCondition = newLinkWord;
            self->_firstLinkWordCondition = self.currentLinkWordCondition;
        }
        else {
            if (self.currentLinkWordCondition.conditionFullFill) {
                XNDataBaseActionLinkWord *newLinkWord = [XNDataBaseActionLinkWord new];
                newLinkWord.linkWord = linkword;
                //                if (self.currentLinkWordCondition.isContainer) {
                //                    self.currentLinkWordCondition.condition.nextLinkWordCondition = newLinkWord;
                //                }
                //                else {
                self.currentLinkWordCondition.nextLinkWord = newLinkWord;
                //                }
            }
            else {
                NSAssert(1 > 2, @"请检查你的设置语句，重复设置了判断条件");
            }
        }
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id keyfield, XNDataValueRelation relate, id value))bindInequality; // 控制的条件
{
    return ^id(id keyfield, XNDataValueRelation relate, id value){
        self.bindConditionValue(keyfield);
        self.bindRelative(relate);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(XNDataBaseActionLinkWordType linkword,id keyfield, XNDataValueRelation relate, id value))bindCondition; // 控制的条件
{
    return ^id(XNDataBaseActionLinkWordType linkword,id keyfield, XNDataValueRelation relate, id value){
        self.bindLinkword(linkword);
        self.bindConditionValue(keyfield);
        self.bindRelative(relate);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id keyfield, XNDataValueRelation relate, id value))bindWhere; // where的情况下
{
    return ^id(id keyfield, XNDataValueRelation relate, id value){
        self.bindLinkword(XNDataBaseActionLinkWordTypeWhere);
        self.bindConditionValue(keyfield);
        self.bindRelative(relate);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id keyfield))bindWhereF; // where的情况下
{
    return ^id(id keyfield){
        self.bindLinkword(XNDataBaseActionLinkWordTypeWhere);
        self.bindConditionValue(keyfield);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(void))bindAnd; // and 的情况下
{
    return ^id(){
        self.bindLinkword(XNDataBaseActionLinkWordTypeAnd);
        return self;
    };
}
- (XNDataBaseActionConfig * (^)(id keyfield))bindAndF; // and 的情况下
{
    return ^id(id keyfield){
        self.bindLinkword(XNDataBaseActionLinkWordTypeAnd);
        self.bindConditionValue(keyfield);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(NSString *keyField, NSString *desc,xnDataBaseValueType caseType))orderbyCast;
{
    return ^id(NSString *keyField, NSString *desc,xnDataBaseValueType caseType) {
        self.bindLinkword(XNDataBaseActionLinkWordTypeOrderBy);
        self.bindConditionValue(keyField);
        self.bindConditionValue(desc);
#warning  -- 这个需要去处理
        self.bindConditionValue(@(caseType)); // 这个需要处理
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(NSString *keyField, NSString *desc))orderby;
{
    return ^id(NSString *keyField, NSString *desc) {
        self.bindLinkword(XNDataBaseActionLinkWordTypeOrderBy);
        self.bindConditionValue(keyField);
        self.bindConditionValue(desc);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(NSInteger count))limitCount; // limit count 的情况下
{
    return ^id(NSInteger count){
        self.bindLinkword(XNDataBaseActionLinkWordTypeLimit);
        self.bindConditionValue(@(count));
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(id conditionValue))bindConditionValue{
    return ^id(id conditionValue){
        if (self.currentLinkWordCondition) {
            if (self.currentLinkWordCondition.condition.field.length <=0) {
                self.currentLinkWordCondition.condition.field = conditionValue;
            }
            else {
                self.currentLinkWordCondition.condition.fieldValue = conditionValue;
            }
        }
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(XNDataValueRelation relation))bindRelative{
    return ^id(XNDataValueRelation relation){
        if (self.currentLinkWordCondition) {
            self.currentLinkWordCondition.condition.relation = relation;
        }
        return self;
    };
}

#pragma mark - 更新

-(XNDataBaseActionConfig * (^)(id updateData))bindUpdateData;
{
    return ^id(id updateData) {
        self->_updateData = updateData;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(NSDictionary *settingListData))bindsettingListData;
{
    return ^id(NSDictionary *settingListData) {
        self->_settingListData = settingListData;
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindEqualTo;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationEqual);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindLessThanOrEqual;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationLessThanOrEqual);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindLessThan;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationLessThan);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindGreaterThan;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationGreaterThan);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindGreaterThanOrEqual;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationGreaterThanOrEqual);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindNotEqual;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationNotEqual);
        self.bindConditionValue(value);
        return self;
    };
}

- (XNDataBaseActionConfig * (^)(id value))bindIn;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationIn);
        self.bindConditionValue(value);
        return self;
    };
}
- (XNDataBaseActionConfig * (^)(id value))bindNotIn;
{
    return ^id(id value) {
        self.bindRelative(XNDataValueRelationNotIn);
        self.bindConditionValue(value); // 拼接有关的内容
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(NSString *keyField))count;
{
    return ^id(NSString *keyField) {
        self->_countKeyField = keyField;
        return self;
    };
}

-(XNDataBaseActionConfig * (^)(BOOL flag))bindNegateToAction;
{
    return ^id(BOOL flag) {
        self->_negateToAction = flag;
        return self;
    };
}


//case when read_time > 0.0 then datetime(read_time,'unixepoch','localtime') else collect_time end)
-(XNDataBaseActionConfig * (^)(XNDataBaseActionCondition *condition, id val0, id val1))bindCase;
{
    return ^id(XNDataBaseActionCondition *condition, id val0, id val1) {
        self->_condition = condition;
        self->_conditionVal0 = val0;
        self->_conditionVal1 = val1;
        return self;
    };
}


-(XNDataBaseActionConfig * (^)(NSArray<NSString *> *keyfields))bindWhiteList;
{
    return ^id(NSArray<NSString *> *keyfields) {
        self->_whiteList = keyfields;
        self->_hasSetWhiteOrBlackList = YES;
        return self;
    };
}
-(XNDataBaseActionConfig * (^)(NSArray<NSString *> *keyfields))bindBlackList;
{
    return ^id(NSArray<NSString *> *keyfields) {
        self->_blackList = keyfields;
        self->_hasSetWhiteOrBlackList = YES;
        return self;
    };
}

@end
