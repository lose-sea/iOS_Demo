//
//  ActivityCell.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ActivityCell.h"

@implementation ActivityCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setIView];
        [self setLabel];
    }
    return self;
}

- (void) setIView {
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.imageView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
    self.iView.contentMode = UIViewContentModeScaleAspectFill;
    self.iView.clipsToBounds = YES;
}


- (void) setLabel {
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            make.left.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView);
    }];
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
