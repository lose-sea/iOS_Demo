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
    
    
    self.selectedLabel = [[UILabel alloc] init];
    [self.selectImageView addSubview: self.selectedLabel];
    [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.selectImageView);
    }];
    
    self.selectedLabel.clipsToBounds = YES;
    self.selectedLabel.layer.cornerRadius = 10;
    self.selectedLabel.backgroundColor = [UIColor systemBlueColor];
    self.selectedLabel.hidden = YES;
    self.selectedLabel.textAlignment = NSTextAlignmentCenter;
    self.selectedLabel.textColor = [UIColor labelColor];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // 清空图片视图
    self.iView.image = nil;
    
    // 隐藏并清空选中角标
    self.selectedLabel.hidden = YES;
    self.selectedLabel.text = nil;
    self.isSelected = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
