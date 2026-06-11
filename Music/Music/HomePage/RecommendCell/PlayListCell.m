//
//  PlayListCell.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "PlayListCell.h"

@implementation PlayListCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}

- (void) setUpInterface {
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    self.tagLabel = [[UILabel alloc] init];
    self.messageLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
