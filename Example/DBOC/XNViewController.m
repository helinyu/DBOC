//
//  XNViewController.m
//  DBOC
//
//  Created by helinyu on 07/05/2021.
//  Copyright (c) 2021 helinyu. All rights reserved.
//

#import "XNViewController.h"
#import <DBOC/DBOC.h> 
#import "XNDataModel.h"

@interface XNViewController ()

@end

@implementation XNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[XNDataBaseManager shareManager] createTableFromClass:[XNDataModel class] config:nil];
}

- (IBAction)onBatchInsert:(id)sender {
    XNDataModel *item0 = [XNDataModel new];
    item0.name = @"helinyu";
    item0.age = 18;
    
    XNDataModel *item1 = [XNDataModel new];
    item1.name = @"helinyu1";
    item1.age = 21;
    
    kCP(XNDataModel, name);
    NSArray *items = @[item0, item1];
    [[XNDataBaseManager shareManager] action:XNDataBaseActionTypeInsert builder:^(XNDataBaseActionConfig *config) {
        config.b_class(XNDataModel).b_batchList(items);
        config.bindConditionValue(kCP(XNDataModel, name));
//        config.bindWhereF(kCP(XNDataModel, name));
        config.whereF(kCP(XNDataModel, name));
    } then:^(BOOL result, id  _Nullable value) {
        NSLog(@"lt insert batch :%hhd, %@",result, value);
    }];
}

@end
