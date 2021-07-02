//
//  XNDataBaseActionDeleteProvider.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionDeleteProvider.h"
#import "XNDataBaseActionLinkWord.h"
#import <FMDB/FMDB.h>
#import "XNDataBaseActionConfig.h"
#import "XNDataBaseHelper.h"


@implementation XNDataBaseActionDeleteProvider

- (void)fireAction {
    

    NSString *linkWordSql = [self.config.firstLinkWordCondition conditionText];
    
    if (linkWordSql.length <=0 && !self.config.deleteData && !self.config.deleteAll) {
        !self.resultBlock? :self.resultBlock(NO, nil);
        return;
    }

    if (self.buildSqlBlock) {
        NSString *tableName = self.config.tableName;
        if (self.config.deleteAll) { //（先判断是否是删除全部）
            NSString *sql = [NSString stringWithFormat:@"delete from %@",tableName];
            !self.resultBlock? :self.resultBlock(self.buildSqlBlock(sql, nil), nil);
            return;
        }
        
        if (linkWordSql.length >0) {
            NSString *sql = [NSString stringWithFormat:@"delete from %@ %@",tableName, linkWordSql];
            !self.resultBlock? :self.resultBlock(self.buildSqlBlock(sql, nil), nil);
            return;
        }
        
        { // 删除某个对象
            NSArray * propArray = [XNDataBaseHelper getPropertiesFromClass:self.config.tableMapClass].allKeys;
            NSArray * valueArray = [XNDataBaseHelper getValuesFromObject:self.config.deleteData];
            NSString * whereStr = [propArray componentsJoinedByString:@"=? AND "];
            whereStr = [whereStr stringByAppendingString:@"=?"];
            NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, whereStr];
            !self.resultBlock? :self.resultBlock(self.buildSqlBlock(sql, valueArray), nil);
            return;
        }
    }
    else {
        !self.resultBlock? :self.resultBlock(NO, nil);
    }
}

@end
