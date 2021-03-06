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

-(XNDataBaseActionConfig * (^)(Class cls))bindTableMapClass{
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


-(XNDataBaseActionConfig * (^)(XNDataBaseActionLinkWordType linkword))linkword{
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

-(XNDataBaseActionConfig * (^)(id conditionValue))conditionValue{
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

-(XNDataBaseActionConfig * (^)(XNDataValueRelation relation))relative{
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

-(XNDataBaseActionConfig * (^)(NSDictionary *updateListData))bindUpdateListData;
{
    return ^id(NSDictionary *updateListData) {
        self->_updateListData = updateListData;
        return self;
    };
}

@end
