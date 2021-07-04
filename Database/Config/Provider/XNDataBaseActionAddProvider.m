//
//  XNDataBaseActionAddProvider.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionAddProvider.h"
#import "XNDataBaseActionLinkWord.h"
#import <FMDB/FMDB.h>
#import "XNDataBaseActionConfig.h"
#import "XNDataBaseHelper.h"

@implementation XNDataBaseActionAddProvider

- (void)fireAction;
{
    NSMutableArray * propertiesArray = [[XNDataBaseHelper getPropertiesFromClass:self.config.tableMapClass].allKeys mutableCopy];
    id aItem = self.config.batch? self.config.batchlist.firstObject : self.config.insertData;
    NSString * propStr = [propertiesArray componentsJoinedByString:@", "];
    NSArray * valuesArray = [XNDataBaseHelper getValuesFromObject:aItem properties:propertiesArray];
    NSMutableArray * placeHolderArray = [NSMutableArray array];
    [propertiesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [placeHolderArray addObject:@"?"];
    }];
    NSString * placeHolderStr = [placeHolderArray componentsJoinedByString:@", "];
    NSString * sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@) ", self.config.tableName, propStr, placeHolderStr];
  
    XNDataBaseActionLinkWord *linkword = self.config.firstLinkWordCondition;
    if (linkword) {
        sql = [NSString stringWithFormat:@"%@ %@",sql, [linkword conditionText]];
    }
    
    if (self.buildSqlBlock) {
        BOOL suc = self.buildSqlBlock(sql, valuesArray);
        !self.resultBlock? :self.resultBlock(suc, nil);
    }
    else {
        !self.resultBlock? :self.resultBlock(NO, nil);
    }
}

@end
