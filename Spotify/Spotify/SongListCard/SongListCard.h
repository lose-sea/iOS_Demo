//
//  PlayListView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SongListCard : UIView
@property (nonatomic, strong) UIImageView* coverImageView;
@property (nonatomic, strong) UILabel* playListNameLabel;

@end

NS_ASSUME_NONNULL_END
