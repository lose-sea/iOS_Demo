//
//  GenderCell.h
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface GenderCell : UITableViewCell
@property (nonatomic, strong) UILabel* tagLabel;
@property (nonatomic, strong) UIButton* maleButton;
@property (nonatomic, strong) UILabel* maleLabel;
@property (nonatomic, strong) UIButton* femaleButton;
@property (nonatomic, strong) UILabel* femaleLabel;
@end

NS_ASSUME_NONNULL_END
