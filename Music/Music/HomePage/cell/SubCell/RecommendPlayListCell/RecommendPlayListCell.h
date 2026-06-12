//
//  RecommendPlayListCell.h
//  Music
//
//  Created by lose_sea on 2026/6/12.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface RecommendPlayListCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* iView;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIButton* playButton; 
@end

NS_ASSUME_NONNULL_END
