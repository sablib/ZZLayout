# ZZLayout

基于Rhea来进行布局计算，并没有使用AutoLayout，用法见代码。
目前还比较简单，功能上API上都是，之后添加其他的功能。

1. 计算出来的布局信息是在一个座标系里面的绝对坐标，没有父子关系以及对应的相对座标系
2. 目前支持的功能也还比较单一，还不能实现`自动布局`，只能进行一次性的计算
3. 现在只支持一些基本属性，没有Masonry那样强大的功能

优点在于自动计算布局信息，不用手动计算frame，可以在其他线程跑。

``` Objective-C
UIView *view1 = [UIView new];
view1.backgroundColor = [UIColor greenColor];
UIView *view2 = [UIView new];
view2.backgroundColor = [UIColor blueColor];
[self.view addSubview:view1];
[self.view addSubview:view2];

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    ZZLayoutItem *item1 = [ZZLayoutItem new];
    ZZLayoutItem *item2 = [ZZLayoutItem new];

    item1.frame = CGRectMake(100, 100, 150, 150);
    [item2 makeConstraints:^(ZZLayoutConstraintMaker *make) {
        make.left.equalTo(item1).with.offset(10);
        make.top.equalTo(item1).with.offset(140);
        make.width.equalTo(item1).with.offset(-10);
        make.height.equalTo(item1).with.offset(-10);
    }];

    [ZZLayoutItem layout];

    dispatch_async(dispatch_get_main_queue(), ^{
        view1.frame = item1.frame;
        view2.frame = item2.frame;
    });
});
```
