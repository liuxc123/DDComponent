#import "DDCollectionViewComponent.h"
#import "DDCollectionViewSectionComponent.h"
#import "DDCollectionViewSectionGroupComponent.h"

/**
 This component is for status changing.
 For example, a request should has 'Loading', 'Error', 'Empty Data', 'Normal Data'.
 And the component should show 'Loading' when request is loading.
 */
@interface DDCollectionViewStatusComponent : DDCollectionViewBaseComponent

/**
 You can change the state by this property.
 You must reloadData by yourself after currentState changed!
 */
@property (strong, nonatomic, nullable) NSString *currentState;
@property (readonly, nonatomic, nullable) DDCollectionViewBaseComponent *currentComponent;

- (DDCollectionViewBaseComponent * _Nullable)componentForState:(NSString * _Nullable)state;

/**
 @param comp Component for the state
 @param state Nil will do nothing
 */
- (void)setComponent:(DDCollectionViewBaseComponent * _Nullable)comp forState:(NSString * _Nullable)state;

@end


/**
 Like DDCollectionViewStatusComponent, but the header and footer will use statusComponent properties,
 not the subComponent's properties.
 */
@interface DDCollectionViewHeaderFooterStatusComponent : DDCollectionViewStatusComponent

@property (strong, nonatomic, nullable) __kindof DDCollectionViewSectionComponent *headerComponent;
@property (strong, nonatomic, nullable) __kindof DDCollectionViewSectionComponent *footerComponent;
@property (strong, nonatomic, nullable) __kindof DDCollectionViewSectionComponent *headerFooterComponent;

@end
