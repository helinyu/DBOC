//
//  XNDataBaseActionBaseProvider.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionBaseProvider.h"

@implementation XNDataBaseActionBaseProvider

+ (Class)getClassWithActionType:(XNDataBaseActionType)actionType {
    NSDictionary *dict = @{
        @(XNDataBaseActionTypeSelect):@"XNDataBaseActionQueryProvider",
        @(XNDataBaseActionTypeDelete):@"XNDataBaseActionDeleteProvider",
        @(XNDataBaseActionTypeInsert):@"XNDataBaseActionAddProvider",
        @(XNDataBaseActionTypeUpdate):@"XNDataBaseActionUpdateProvider",
    };
    NSString * className = [dict objectForKey:@(actionType)];
    if (className.length >0) {
        return NSClassFromString(className);
    }
    return nil;
}

+ (void)fireAction:(XNDataBaseActionType)actionType config:(XNDataBaseActionConfig *)config resultBlock:(DataBaseActionResultBlock)resultBlock;
{
    Class cls = [self getClassWithActionType:actionType];
    if (!cls) {
        !resultBlock? :resultBlock(NO, nil);
    }
    
    XNDataBaseActionBaseProvider *provider = [cls new];
    provider.actionType = actionType;
    provider.config = config;
    provider.resultBlock = resultBlock;
}

+ (void)fireAction:(XNDataBaseActionType)actionType config:(XNDataBaseActionConfig *)config resultBlock:(DataBaseActionResultBlock)resultBlock buildSql:(DataBaseActionBuildSqlBlock)buildSqlBlock;
{
    Class cls = [self getClassWithActionType:actionType];
    if (!cls) {
        !resultBlock? :resultBlock(NO, nil);
    }
    
    XNDataBaseActionBaseProvider *provider = [cls new];
    provider.actionType = actionType;
    provider.config = config;
    provider.resultBlock = resultBlock;
    provider.buildSqlBlock = buildSqlBlock;
    [provider fireAction];
}

- (void)fireAction;
{
    
}

@end
