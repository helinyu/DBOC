//
//  XNDataModel.h
//  DBOC_Example
//
//  Created by xn on 2021/7/5.
//  Copyright © 2021 helinyu. All rights reserved.
//

#import <DBOC/XNDatabaseModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XNDataModel : XNDatabaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
