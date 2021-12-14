#import "DDCollectionViewComponent.h"
#import "DDCollectionViewComponent+Private.h"
#import "DDCollectionViewComponent+Cache.h"
#import "DDCollectionViewSectionGroupComponent.h"

const CGFloat DDComponentAutomaticDimension = CGFLOAT_MAX;

@implementation DDCollectionViewBaseComponent
@synthesize collectionView=_collectionView;
@synthesize dataSourceCacheEnable=_dataSourceCacheEnable;
//@synthesize sizeCacheEnable=_sizeCacheEnable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceCacheEnable = YES;
//        _sizeCacheEnable = YES;
    }
    return self;
}

- (DDCollectionViewRootComponent *)rootComponent {
    return self.superComponent.rootComponent;
}

- (void)setSuperComponent:(DDCollectionViewBaseComponent *)superComponent {
    _superComponent = superComponent;
    self.collectionView = _superComponent.collectionView;
}

- (UICollectionView *)collectionView {
    return _collectionView ?: self.superComponent.collectionView;
}

- (NSInteger)firstItemOfSubComponent:(id<DDCollectionViewComponent>)subComp {
    return 0;
}

- (NSInteger)firstSectionOfSubComponent:(id<DDCollectionViewComponent>)subComp {
    return 0;
}

- (void)prepareCollectionView {}

- (void)reloadData {}

- (void)clearDataSourceCache {}
- (void)clearSizeCache {}

- (NSInteger)item {
    return [self.superComponent firstItemOfSubComponent:self];
}

- (NSInteger)section {
    return [self.superComponent firstSectionOfSubComponent:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(false, @"MUST override!");
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSAssert(false, @"MUST override!");
    return nil;
}

#pragma mark - convert

- (NSInteger)convertFromGlobalSection:(NSInteger)section {
    NSInteger differenceSection = ABS(section - self.section);
    return differenceSection;
}

- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath {
    NSInteger differenceSection = ABS(indexPath.section - self.section);
    NSInteger differenceItem = ABS(indexPath.item - self.item);
    return [NSIndexPath indexPathForItem:differenceItem inSection:differenceSection];
}

@end
