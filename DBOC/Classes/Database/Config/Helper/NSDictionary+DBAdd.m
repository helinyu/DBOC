//
//  NSDictionary+DBAdd.m
//  Pods
//
//  Created by xn on 2021/7/17.
//


#import "NSDictionary+DBAdd.h"
#import "XNDataBaseConstonts.h"

@implementation NSDictionary (DBAdd)

- (id)result;
{
   return [self objectForKey:kDB_actionResultKey];
}

- (BOOL)actionFlag;
{
    return [[self objectForKey:kDB_actionFlagKey] boolValue];
}


@end
