//
//  RecommendCell.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "PlayListCell.h"

NS_ASSUME_NONNULL_BEGIN
@interface RecommendTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView* collectionView; 
@end

NS_ASSUME_NONNULL_END
