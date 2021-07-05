//
//  XNDataBaseActionContraintsModel.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import <Foundation/Foundation.h>
#import "XNDataBaseConstonts.h"
@class XNDataBaseActionLinkWord;

NS_ASSUME_NONNULL_BEGIN


// 一个不等式的语句
@interface XNDataBaseActionCondition : NSObject

@property (nonatomic, copy) NSString *field; // 字段的名称
@property (nonatomic) id fieldValue; // 不等式的值
@property (nonatomic, assign) XNDataValueRelation relation; // 不等式关系
@property (nonatomic, copy, readonly) NSString *relationText; // 不等式的文案

//@property (nonatomic, strong) XNDataBaseActionLinkWordCondition *nextLinkWordCondition; // 下一个判断的内容

- (BOOL)fullFill;

@end

NS_ASSUME_NONNULL_END
