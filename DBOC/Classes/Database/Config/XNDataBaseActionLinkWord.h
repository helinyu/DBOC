//
//  XNDataBaseActionJudgingCondition.h
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import <Foundation/Foundation.h>
#import "XNDataBaseActionCondition.h"

NS_ASSUME_NONNULL_BEGIN


// 连接词
typedef NS_ENUM(NSUInteger, XNDataBaseActionLinkWordType) {
    XNDataBaseActionLinkWordTypeWhere, // whare
    XNDataBaseActionLinkWordTypeAnd, // and
    XNDataBaseActionLinkWordTypeOr, // or
    XNDataBaseActionLinkWordTypeOrderBy, // orderBy , 后面可以接入多个值
    XNDataBaseActionLinkWordTypeLimit, // limit
};

//@property (nonatomic, copy) NSString *where;
//@property (nonatomic, copy) NSString *and; // 相当于and
//@property (nonatomic, copy) NSString *or;
//@property (nonatomic, copy) NSString *orderBy;  SELECT * FROM Websites ORDER BY alexa DESC;

@interface XNDataBaseActionLinkWord : NSObject

@property (nonatomic, assign) XNDataBaseActionLinkWordType linkWord; // 条件类型
@property (nonatomic, copy) NSString *linkwordText;

- (BOOL)isContainer; // where 的时候就是一个容器

@property (nonatomic, strong) XNDataBaseActionCondition *condition;//控制语句
@property (nonatomic, copy, readonly) NSString *conditionText;

@property (nonatomic, strong) XNDataBaseActionLinkWord *nextLinkWord;// 下一个条件判断
// 判断顺序： condition > nextLinkWord

- (BOOL)conditionFullFill;

@end

NS_ASSUME_NONNULL_END
