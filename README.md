# DDComponent
Make a collection controller to several components. A `UICollectionView/UITableView` framework for building fast and flexible lists. Like `IGList`.

[中文文档](./README-zh.md)

# Requirements

* Xcode 8.0+
* iOS 8.0+

# Installation

### CocoaPods

```
pod 'DDComponent'
```

### Carthage

```
github 'DDComponent'
```

# from

# Getting Started

For easy using, the api is similar to `UICollectionView` and `UITableView`.


```objc
@interface YourComponent : DDCollectionViewSectionComponent
@end

@implementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(DDComponentAutomaticDimension, 44);
        // config here. 
        // Remember self.collectionView is nil until it is added to root component.
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    // register your cell here.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ... // Return your cell
}

@end
```

And the other api is also the same.

```objc
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // select item
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // will display
}
```

# Debug

```
po self.rootComponent
<DDCollectionViewRootComponent: 0x6080000bb900>
  [SubComponents]
    <DDComponentPodDemo.StatusComponent: 0x60800009b440>
      -[loading] <DDComponentPodDemo.StateComponent: 0x6080001651c0>
      *[normal] <DDCollectionViewSectionGroupComponent: 0x60800009acc0>
          [SubComponents]
            <DDComponentPodDemo.TaobaoBannerComponent: 0x6080001235c0>
            <DDComponentPodDemo.TaobaoEntriesComponent: 0x6080001524e0>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000151eb0>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000151510>
              [Header] <DDComponentPodDemo.HeaderComponent: 0x608000151250>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000152220>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000152380>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x6080001511a0>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000151b40>
              [Header] <DDComponentPodDemo.HeaderComponent: 0x608000151ca0>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000152170>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x6080001515c0>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000151a90>
              [Header] <DDComponentPodDemo.HeaderComponent: 0x608000151f60>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000151930>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000151670>
            <DDComponentPodDemo.TaobaoGoodsComponent: 0x608000152640>
      -[error] <DDComponentPodDemo.StateComponent: 0x608000165340>
      -[noData] <DDComponentPodDemo.StateComponent: 0x608000165400>
```

# Structure

![](./Images/structure.png)

1. View Component: displaying. for example, a list of cell or just an element。
2. Container Component: combine the view components. For example, conbine some components as a list, or switch between different components(Loading, Error, Empty). And the root component is also a containter component.

### ItemComponent

1. 基础组件, 0个section 多个item  需要用容器包裹
2. cell内容内部实现
3. 需使用容器ItemGroupComponent嵌套

### SectionComponent

1. 基础组件, 一个Section 多个items
2. cell、header、footer内容内部实现
3. headerVIew继承此组件
4. footerVIew继承此组件

### HeaderFooterSectionComponent

1. 基础组件, 一个Section 多个items
2. Header以headerComponent为主
3. Footer以footerComponent为主
4. cell内容内部实现

### ItemGroupComponent

1. 容器组件, 一个Section 多个items
2. Header以headerComponent为主
3. Footer以footerComponent为主
4. 子视图以subComponents为主

### SectionGroupComponent

1. 容器组件, 多个Section
2. 子视图subComponents嵌套ItemComponent、SectionComponent、HeaderFooterSectionComponent等容器组件

### RootComponent

1. 根容器组件，绑定collectionView或tableView
2. 多个Section
3. 子视图subComponents嵌套SectionComponent等容器组件

### StatusComponent

1. 状态机容器组件
2. 用与切换Loading、Empty、Normal视图

![](./Images/example.png)

An example how it 

![](./Images/structure2.png)

We need to do is only the red part.

# Attension

Use `size`, `inset` first, then override the `delegate` api.

# Some Question

As use the system api, `indexPath` is the `UICollectionView`'s location. It is not the index of component's dataSource.

