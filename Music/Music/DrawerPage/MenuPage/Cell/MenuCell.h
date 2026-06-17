//
//  MenuCell.h
//  Music
//
//  Created by lose_sea on 2026/6/16.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface MenuCell : UITableViewCell
@property (nonatomic, strong) UIImageView* tagView;
@property (nonatomic, strong) UILabel* tagLabel;

@property (nonatomic, strong) UIView* iView;
@end

NS_ASSUME_NONNULL_END
