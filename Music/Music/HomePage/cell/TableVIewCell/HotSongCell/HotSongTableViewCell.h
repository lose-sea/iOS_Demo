//
//  HotSongTableViewCell.h
//  Music
//
//  Created by lose_sea on 2026/6/13.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "HotSongCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HotSongTableViewCell : UITableViewCell
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) NSInteger sectionType; 
@end

NS_ASSUME_NONNULL_END
