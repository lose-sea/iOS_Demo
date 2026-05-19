//
//  CustomCell.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCell : UITableViewCell
@property (nonatomic, strong) UIImageView* iView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* massageLabel;
@property (nonatomic, strong) UILabel* authorLabel;

@property (nonatomic, strong) UIImageView* likeImageView;
@property (nonatomic, strong) UIImageView* lookImageView;
@property (nonatomic, strong) UIImageView* saveImageView;

@property (nonatomic, strong) UILabel* likeLabel;
@property (nonatomic, strong) UILabel* lookLabel;
@property (nonatomic, strong) UILabel* saveLable; 
@end

NS_ASSUME_NONNULL_END
