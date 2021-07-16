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
	// Do any additional setup after loading the view, typically from a nib.
    
    [[XNDataBaseManager shareManager] createTableFromClass:[XNDataModel class] config:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBatchInsert:(id)sender {
    XNDataModel *item0 = [XNDataModel new];
    item0.name = @"helinyu";
    item0.age = 18;
    
    XNDataModel *item1 = [XNDataModel new];
    item1.name = @"helinyu1";
    item1.age = 21;
    
    [[XNDataBaseManager shareManager] action:XNDataBaseActionTypeInsert builder:^(XNDataBaseActionConfig *config) {
        config.bindObjcClass([XNDataModel class]);
        config.bindBatchList(@[item0, item1]);
        } then:^(BOOL result, id  _Nullable value) {
            NSLog(@"lt insert batch :%zd, %@",result, value);
        }];
}

@end
