//
//  ImageShowCell.m
//  Share
//
//  Created by lose_sea on 2026/5/27.
//

#import "ImageShowCell.h"

@implementation ImageShowCell
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isSelected = NO;
        
        [self setIView];
        [self setselectImageView];
    }
    return self;
}

- (void) setIView {
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
    }];
}


- (void) setselectImageView {
    self.selectImageView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, self.bounds.size.width - 20, self.bounds.size.height - 20, 0));
    }];
    self.selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.selectImageView.clipsToBounds = YES;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
