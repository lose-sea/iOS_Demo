//
//  RecommendPlayListCell.h
//  Music
//
//  Created by lose_sea on 2026/6/12.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "SongList.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecommendPlayListCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* iView;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIButton* playButton;

@property (nonatomic, strong) SongList* songList;

- (void) configWitSongList: (SongList*) songList;
@end

NS_ASSUME_NONNULL_END
