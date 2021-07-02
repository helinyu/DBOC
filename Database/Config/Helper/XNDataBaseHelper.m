//
//  XNDataBaseHelper.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseHelper.h"
#import <objc/runtime.h>
#import "XNDatabaseModel.h"

@implementation XNDataBaseHelper

#pragma mark - 数据模型转换

+ (NSString*)dataToJsonString:(id)object{
    if (!object) {
        return nil;
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (id)toArrayOrDictionary:(NSString *)jsonString{
    if (jsonString.length == 0) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

#pragma mark - 获取类的值

+ (NSArray *)getValuesFromObject:(id)object
{
    // 创建数组存储所有的值
    NSMutableArray * valuesArray = [NSMutableArray array];
    // 先获取所有的属性
    NSMutableArray * propertiesArray = [[XNDataBaseHelper getPropertiesFromClass:[object class]].allKeys mutableCopy];
    for (NSString * prop in propertiesArray) {
        // 通过KVC方式获取对象中的值
        id value = [object valueForKey:prop];
        if (!value) {
            [valuesArray addObject:@""];
        }
        else {
            if ([value isKindOfClass:[NSDictionary class]] ||
                [value isKindOfClass:[NSArray class]]) {
                [valuesArray addObject:[XNDataBaseHelper dataToJsonString:value]];
            }else{
                [valuesArray addObject:value];
            }
        }
    }
    return valuesArray;
}

+ (NSArray *)getValuesFromObject:(id)object properties:(NSArray *)properties{
    // 创建数组存储所有的值
    NSMutableArray * valuesArray = [NSMutableArray array];
    for (NSString * prop in properties) {
        // 通过KVC方式获取对象中的值
        id value = [object valueForKey:prop];
        if (!value) {
            [valuesArray addObject:@""];
        }
        else {
            if ([value isKindOfClass:[NSDictionary class]] ||
                [value isKindOfClass:[NSArray class]]) {
                [valuesArray addObject:[XNDataBaseHelper dataToJsonString:value]];
            }else{
                [valuesArray addObject:value];
            }
        }
    }
    return valuesArray;
}


+ (NSArray *)getColumnsValuesFromObject:(id)object;// 获取对应表的字段的值
{
#warning - 需要处理白名单以及黑名单
    return [self getValuesFromObject:object];
}

#pragma mark - 获取类的属性

// 获取类的有关属性
+ (NSDictionary *)getPropertiesFromClass:(Class)class {
    // 创建数组存储所有属性
    //NSMutableArray * propertiesArray = [NSMutableArray array];
    NSMutableDictionary *propertiesDict = [NSMutableDictionary dictionary];
    
    unsigned int propertiescount = 0;
    // 通过runtime获取类中所有的属性
    // 参数1：class
    // 参数2：属性的个数
    // 返回值：指针，指向一个数组，指向数组中第一个元素
    objc_property_t * objcPropertyArray =  class_copyPropertyList(class, &propertiescount);
    // 循环遍历取出属性
    for (int idx = 0; idx < propertiescount; idx++) {
        objc_property_t property = objcPropertyArray[idx];
        // 获取结构中属性的name
        const char * propertyName = property_getName(property);
        const char * attributes = property_getAttributes(property);
        NSString * attrStr = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
        NSArray *attrs = [attrStr componentsSeparatedByString:@","];
        NSString *typeName = attrs.firstObject;
        //Td,N,V_addtime;
        if ([typeName containsString:@"@"]) {
            typeName = [typeName substringFromIndex:2];
            typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        }else{
            typeName = [typeName substringFromIndex:1];
            const char * rawPropertyType = [typeName UTF8String];
            
            if (strcmp(rawPropertyType, @encode(float)) == 0) {
                typeName = @"float";
            } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
                typeName = @"int";
            } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
                typeName = @"id";
            } else if (strcmp(rawPropertyType, @encode(double)) == 0){
                typeName = @"double";
            }else if(strcmp(rawPropertyType, @encode(long)) == 0){
                typeName = @"long";
            }else if(strcmp(rawPropertyType, @encode(unsigned int)) == 0){
                typeName = @"NSInteger";
            }else if(strcmp(rawPropertyType, @encode(unsigned long)) == 0){
                typeName = @"NSInteger";
            }
        }
        
        // 将char * 转换为NSString
        NSString * nameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propertiesDict setObject:typeName forKey:nameStr];
    }
    
#pragma mark -- 黑名单以及白名单
    
    //释放
    free(objcPropertyArray);
    return propertiesDict;
}

#pragma mark - 设置有关的值

+ (void)bindObject:(id)object withValue:(id)value propertyNameType:(NSDictionary *)propDict property:(NSString *)prop {
    NSString *type = [propDict objectForKey:prop];
    id result = [self getDataWithValue:value propType:type];
    [object setValue:value forKey:prop];
//    if (value == [NSNull null] || !value) {
//        NSString *type = propDict[prop];
//            if ([type isEqualToString:@"NSArray"]) {
//                [object setValue:@[] forKey:prop];
//            }else if ([type isEqualToString:@"NSDictionary"]) {
//                [object setValue:@{} forKey:prop];
//            }else if ([type isEqualToString:@"NSString"]) {
//                [object setValue:@"" forKey:prop];
//            }
//            else {
//                [object setValue:@(0) forKey:prop];
//            }
//    }else{
//        NSString *type = [propDict objectForKey:prop];
//        if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
//            id v = [XNDataBaseHelper toArrayOrDictionary:value];
//            if (v) {
//                [object setValue:v forKey:prop];
//            }
//            else {
//                if ([type isEqualToString:@"NSArray"]) {
//                    [object setValue:@[] forKey:prop];
//                }
//                else {
//                    [object setValue:@{} forKey:prop];
//                }
//            }
//        }else{
//            [object setValue:value forKey:prop];
//        }
//    }
}

+ (id)getDataWithValue:(id)value propType:(NSString *)type {
    if (value == [NSNull null] || !value) {
        if ([type isEqualToString:@"NSArray"]) {
            return @[];
        }else if ([type isEqualToString:@"NSDictionary"]) {
            return @{};
        }else if ([type isEqualToString:@"NSString"]) {
            return @"";
        }
        else {
            return @0;
        }
    }else{
        if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
            id v = [XNDataBaseHelper toArrayOrDictionary:value];
            if (v) {
                return v;
            }
            else {
                if ([type isEqualToString:@"NSArray"]) {
                    return @[];
                }
                else {
                    return @{};
                }
            }
        }else{
            return value;
        }
    }
}

#pragma mark - 根据OC对象获取表对应的对象

+ (Class)getTableMapClassWithObjcClass:(Class)cls {
    if ([self isBaseClass:cls]) {
        return cls;
    }
 
    Class currentCls = cls;
    while (![self canFind:currentCls]) {
        currentCls = [currentCls superclass];
        if ([self isBaseClass:currentCls]) {
            currentCls = cls;
            break;
        }
    }
    return currentCls;
}

+ (BOOL)isBaseClass:(Class)cls {
    BOOL isBaseClass = (!cls || cls == [XNDatabaseModel class] || cls == [NSObject class]);
    return isBaseClass;
}

+ (BOOL)canFind:(Class)cls {
    SEL cacheSel = @selector(isCacheDBFromCurrentClass);
    BOOL canFind = ([cls respondsToSelector:cacheSel] && [cls performSelector:cacheSel] && [[cls superclass] respondsToSelector:cacheSel] && ![[cls superclass] performSelector:cacheSel]);
    return canFind;
}

@end
