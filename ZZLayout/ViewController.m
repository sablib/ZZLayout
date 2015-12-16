//
//  ViewController.m
//  ZZLayout
//
//  Created by sablib on 15/12/4.
//  Copyright © 2015年 sablib. All rights reserved.
//

#import "ViewController.h"
#import "ZZLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor greenColor];
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor blueColor];
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view1];
    [view1 addSubview:view2];
    [view2 addSubview:view3];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZZLayoutItem *item1 = [ZZLayoutItem new];
        ZZLayoutItem *item2 = [ZZLayoutItem new];
        ZZLayoutItem *item3 = [ZZLayoutItem new];
        [item1 addSubItem:item2];
        [item2 addSubItem:item3];
        
        item1.frame = CGRectMake(100, 100, 150, 150);
        [item2 makeConstraints:^(ZZLayoutConstraintMaker *make) {
            make.left.equalTo(item1).with.offset(10);
            make.top.equalTo(item1).with.offset(140);
            make.width.equalTo(item1).with.offset(-10);
            make.height.equalTo(item1).with.offset(-10);
        }];
        
        [item3 makeConstraints:^(ZZLayoutConstraintMaker *make) {
            make.centerX.equalTo(item1.left);
            make.top.equalTo(item2).with.offset(10);
            make.height.equalTo(item3.width);
            make.width.equalTo(item1).with.offset(-100);
        }];
        
        [item1 layout];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            view1.frame = item1.frame;
            view2.frame = item2.frame;
            view3.frame = item3.frame;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
