//
//  PlayListCell.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface DailyRecommendCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* iView;
@property (nonatomic, strong) UILabel* tagLabel;
@property (nonatomic, strong) UILabel* messageLabel;

@end

NS_ASSUME_NONNULL_END
