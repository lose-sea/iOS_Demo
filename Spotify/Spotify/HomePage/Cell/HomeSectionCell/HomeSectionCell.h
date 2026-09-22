//
//  HomeSectionCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>
#import "HomeSection.h"

NS_ASSUME_NONNULL_BEGIN

/// 分区容器 cell 复用标识
UIKIT_EXTERN NSString *const HomeSectionCellID;

@class HomeCard;
@class HomeSectionCell;

@protocol HomeSectionCellDelegate <NSObject>

/// 点击了分区内的某张卡片
- (void)homeSectionCell:(HomeSectionCell *)cell didSelectCard:(HomeCard *)card atIndex:(NSInteger)index;

@end

/// 一个横向滑动分区：分区标题 + 横向 UICollectionView
@interface HomeSectionCell : UITableViewCell

@property (nonatomic, weak, nullable) id<HomeSectionCellDelegate> delegate;

+ (CGFloat)heightForSection:(HomeSection *)section;

- (void)configureWithSection:(HomeSection *)section;

@end

NS_ASSUME_NONNULL_END
