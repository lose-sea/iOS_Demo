//
//  tagCollectionVIewCell.m
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import "tagCollectionVIewCell.h"

@implementation tagCollectionVIewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self settagLabel];
    }
    return self; 
}


- (void) settagLabel {
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize: 16];
    [self.contentView addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 上左下右
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(5, 0, 5, self.contentView.bounds.size.width - 20));
    }];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
