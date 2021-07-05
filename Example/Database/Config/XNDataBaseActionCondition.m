//
//  XNDataBaseActionContraintsModel.m
//  TestRAC
//
//  Created by xn on 2021/7/1.
//

#import "XNDataBaseActionCondition.h"

@implementation XNDataBaseActionCondition

- (BOOL)fullFill;
{    
    if (self.field.length >0 && self.fieldValue != nil && self.relation > XNDataValueRelationUnvalid) {
        return YES;
    }
    return NO;
}

- (NSString *)relationText {
    NSDictionary *dict = @{
        @(XNDataValueRelationLessThanOrEqual):@"<=",
        @(XNDataValueRelationLessThan):@"<",
        @(XNDataValueRelationEqual):@"=",
        @(XNDataValueRelationGreaterThan):@">",
        @(XNDataValueRelationGreaterThanOrEqual):@">=",
        @(XNDataValueRelationNotEqual):@"!=",
        @(XNDataValueRelationIn):@"in",
    };
  
    NSString *relationText = [dict objectForKey:@(self.relation)];
    return relationText.length >0? relationText : @"";
}

@end
