//
//  XNDataBaseActionUpdateProvider.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionUpdateProvider.h"
#import "XNDataBaseActionConfig.h"
#import <FMDB/FMDB.h>
#import "XNDataBaseHelper.h"

@implementation XNDataBaseActionUpdateProvider

- (void)fireAction
{
    NSString *linkWordSql = [self.config.firstLinkWordCondition conditionText];
    
    BOOL updateOneObj = (self.config.updateData && linkWordSql.length >0);
    BOOL updateListSomeProp = self.config.settingListData;
   
    if (!updateOneObj && updateListSomeProp) {
        !self.resultBlock? :self.resultBlock(NO, nil);
        return;
    }
    
    if (self.buildSqlBlock) {
        NSString *tableName = self.config.tableName;
        NSString *keyValueStr = @"";
        if (updateOneObj) {
            NSArray *propertiesArray = [XNDataBaseHelper getPropertiesFromClass:self.config.tableMapClass].allKeys;
            NSArray * valuesArray = [XNDataBaseHelper getValuesFromObject:self.config.updateData properties:propertiesArray];
            NSMutableArray * keyValueArray = [NSMutableArray array];
            [propertiesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = valuesArray[idx];
                NSString *keyValue = [value isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@='%@'", obj, valuesArray[idx]]: [NSString stringWithFormat:@"%@=%@", obj, valuesArray[idx]];
                [keyValueArray addObject:keyValue];
            }];
             keyValueStr = [keyValueArray componentsJoinedByString:@","];
        }
        else {
            NSDictionary *settingListData = self.config.settingListData;
            NSArray *propertiesArray = settingListData.allKeys;
            NSMutableArray * keyValueArray = [NSMutableArray array];
            [propertiesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = [settingListData objectForKey:obj];
                NSString *keyValue = [value isKindOfClass:[NSString class]] ? [NSString stringWithFormat:@"%@='%@'", obj, value]: [NSString stringWithFormat:@"%@=%@", obj, value];
                [keyValueArray addObject:keyValue];
            }];
            keyValueStr = [keyValueArray componentsJoinedByString:@","];
        }
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@ %@;", tableName, keyValueStr, linkWordSql];
        !self.resultBlock? :self.resultBlock(self.buildSqlBlock(sql, nil), nil);
    }
    else {
        !self.resultBlock? :self.resultBlock(NO, nil);
    }
}

@end
