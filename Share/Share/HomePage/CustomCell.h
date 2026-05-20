//
//  CustomCell.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "article.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) article* article;

@property (nonatomic, strong) UIImageView* iView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* massageLabel;
@property (nonatomic, strong) UILabel* authorLabel;

@property (nonatomic, strong) UIImageView* likeImageView;
@property (nonatomic, strong) UIImageView* viewImageView;
@property (nonatomic, strong) UIImageView* saveImageView;

@property (nonatomic, strong) UILabel* likeLabel;
@property (nonatomic, strong) UILabel* viewLabel;
@property (nonatomic, strong) UILabel* saveLabel;



- (void) setData: (article*) article; 
@end

NS_ASSUME_NONNULL_END
