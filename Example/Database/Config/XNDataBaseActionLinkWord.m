//
//  XNDataBaseActionJudgingCondition.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionLinkWord.h"

@implementation XNDataBaseActionLinkWord

- (BOOL)isContainer;
{
    return (self.linkWord == XNDataBaseActionLinkWordTypeWhere);
}

- (XNDataBaseActionCondition *)condition {
    if (!_condition) {
        _condition = [XNDataBaseActionCondition new];
    }
    return _condition;
}

- (NSString *)linkwordText {
//    XNDataBaseActionLinkWordTypeWhere, // whare
//    XNDataBaseActionLinkWordTypeAnd, // and
//    XNDataBaseActionLinkWordTypeOr, // or
//    XNDataBaseActionLinkWordTypeOrderBy, // orderBy
   NSDictionary *dict = @{
        @(XNDataBaseActionLinkWordTypeWhere):@"where",
        @(XNDataBaseActionLinkWordTypeAnd):@"and",
        @(XNDataBaseActionLinkWordTypeOr):@"or",
        @(XNDataBaseActionLinkWordTypeOrderBy):@"order by",
   };
   return [dict objectForKey:@(self.linkWord)];
}

- (BOOL)conditionFullFill;
{
    return self.condition.fullFill;
}

- (NSString *)conditionText {
  return [self filterConditionText:@"" linkWord:self];
}

- (NSString *)filterConditionText:(NSString *)prefix linkWord:(XNDataBaseActionLinkWord *)linkword {
    NSString *text = @"";
    if (linkword.linkWord == XNDataBaseActionLinkWordTypeWhere) {
       NSString *curLinkText = [NSString stringWithFormat:@"%@ (%@ %@ '%@')",linkword.linkwordText , linkword.condition.field, linkword.condition.relationText, linkword.condition.fieldValue];
       text = [NSString stringWithFormat:@"%@ %@",prefix, curLinkText];
    }
    else if (linkword.linkWord == XNDataBaseActionLinkWordTypeAnd || linkword.linkWord == XNDataBaseActionLinkWordTypeOr) {
        NSString *curLinkText = [NSString stringWithFormat:@"%@ %@ %@ '%@'",linkword.linkwordText , linkword.condition.field, linkword.condition.relationText, linkword.condition.fieldValue];
        if (prefix.length >0 && [prefix hasSuffix:@")"]) {
            NSRange lastRange = NSMakeRange(prefix.length -1, 1);
            prefix = [prefix stringByReplacingCharactersInRange:lastRange withString:@""];
            text = [NSString stringWithFormat:@"%@ %@ )",prefix, curLinkText];
        }
        else {
            text = [NSString stringWithFormat:@"%@ %@",prefix, curLinkText];
        }
    }
    else if (linkword.linkWord == XNDataBaseActionLinkWordTypeOrderBy) {
        NSString *curLinkText = [NSString stringWithFormat:@"%@ %@ '%@'",linkword.linkwordText , linkword.condition.field, linkword.condition.fieldValue];
        text = [NSString stringWithFormat:@"%@ %@",prefix, curLinkText];
    }
    else {}
    
    if (linkword.nextLinkWord) {
        return[self filterConditionText:text linkWord:linkword.nextLinkWord];
    }
    else {
        return text;
    }
}

@end
