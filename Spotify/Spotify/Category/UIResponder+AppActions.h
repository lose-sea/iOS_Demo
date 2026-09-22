//
//  UIResponder+AppActions.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 响应者链全局动作声明
///
/// 只用于 @selector() 取选择器（配合 UIApplication sendAction:to:nil from:... 沿响应者链派发），
/// 真正的实现分散在链上的容器里（见下），禁止直接调用（本分类无实现）。
///
/// openMenu             → DrawerViewController 实现
/// openPlayerDetailPage → DrawerViewController 实现
@interface UIResponder (AppActions)

- (void)openMenu;
- (void)openPlayerDetailPage;

@end

NS_ASSUME_NONNULL_END
