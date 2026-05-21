//
//  ScrollViewCell.m
//  Share
//
//  Created by lose_sea on 2026/5/20.
//

#import "ScrollViewCell.h"

@implementation ScrollViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setScrollView];
    }
    return self;
}

- (void) setScrollView {
    self.homeModel = [[HomepageModel alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.bounds.size.width * (self.homeModel.scrollImages.count + 2),  self.contentView.bounds.size.height);
}

- (void) configureData:(NSMutableArray *)images {
    for (int i = 0; i < images.count; i++) {
        UIImage* image = images[i];
        UIImageView* iView = [[UIImageView alloc] initWithImage: image];
        [self.contentView addSubview: iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.contentView.bounds.size.width * i);
                    make.top.mas_equalTo(self.contentView);
                    make.width.height.mas_equalTo(self.contentView);
        }]; 
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
