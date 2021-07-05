//
//  XNDataBaseActionQueryProvider.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionQueryProvider.h"
#import "XNDataBaseActionConfig.h"
#import <FMDB/FMDB.h>
#import "XNDataBaseHelper.h"

@implementation XNDataBaseActionQueryProvider

- (void)fireAction;
{
    NSString *keyFieldText = @"*";
    if (self.config) {
        NSArray<NSString *> *fields = self.config.queryColumnFields;
        if (fields.count >0) {
            keyFieldText = [fields componentsJoinedByString:@","];
        }
        else {}
    }
  
    NSString *sql = [NSString stringWithFormat:@"select %@ from %@", keyFieldText, self.config.tableName];
    
    XNDataBaseActionLinkWord *linkword = self.config.firstLinkWordCondition;
    if (linkword) {
        sql = [NSString stringWithFormat:@"%@ %@",sql, [linkword conditionText]];
    }
    
    if (self.buildSqlBlock) {
        FMResultSet *resultSet = self.buildSqlBlock(sql , nil);
        Class objcClass = self.config.tableMapClass;
        NSDictionary *propDict = [XNDataBaseHelper getPropertiesFromClass:self.config.tableMapClass];
        NSMutableArray *objectsArray = [NSMutableArray new];
        while ([resultSet next]) {
            if (self.config.keepOriginData && self.config.queryColumnFields.count >0) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                for (NSString *prop in self.config.queryColumnFields) {
                    id value = [resultSet objectForColumn:prop];
                    NSString *type = [propDict objectForKey:prop];
                    [dict setObject:[XNDataBaseHelper getDataWithValue:value propType:type] forKey:prop];
                }
                [objectsArray addObject:dict];
            }
            else {
                id object = [[objcClass alloc] init];
                for (NSString * prop in propDict.allKeys) {
                    id value = [resultSet objectForColumn:prop];
                    [XNDataBaseHelper bindObject:object withValue:value propertyNameType:propDict property:prop];
                }
                [objectsArray addObject:object];
            }
          
        }
        !self.resultBlock? :self.resultBlock(YES, objectsArray);
    }
    else {
        !self.resultBlock? :self.resultBlock(NO, nil);
    }
}


@end
