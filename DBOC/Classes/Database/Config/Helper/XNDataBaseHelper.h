//
//  XNDataBaseHelper.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNDataBaseHelper : NSObject

+ (NSString*)dataToJsonString:(id)object;
+ (id)toArrayOrDictionary:(NSString *)jsonString;


+ (NSArray *)getValuesFromObject:(id)object;// 获取改对象对应的属性的值
+ (NSArray *)getValuesFromObject:(id)object properties:(NSArray *)properties; // 指定属性的值

+ (NSArray *)getColumnsValuesFromObject:(id)object;// 获取对应表的字段的值

+ (NSDictionary *)getPropertiesFromClass:(Class)class;

+ (void)bindObject:(id)object withValue:(id)value propertyNameType:(NSDictionary *)propDict property:(NSString *)prop; // 绑定一个对象的值给属性
+ (id)getDataWithValue:(id)value propType:(NSString *)type; // 通过一个值和类型获取对应的真实值

+ (Class)getTableMapClassWithObjcClass:(Class)cls;

+ (NSArray *)getSettingsList:(NSArray<NSString *> *)keys ofItem:(id)item;
+ (NSDictionary *)getSettingDictList:(NSArray<NSString *> *)keys ofItem:(id)item;

@end

NS_ASSUME_NONNULL_END
