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
    
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    
    // 设置圆角
    self.iView.clipsToBounds = YES;
    self.iView.layer.cornerRadius = 6;
    
    self.iView.layer.borderWidth = 1;
    self.iView.layer.borderColor = [UIColor labelColor].CGColor;
    
    self.iView.backgroundColor = [UIColor systemBackgroundColor];
    self.contentView.backgroundColor = [UIColor systemBackgroundColor];
    
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize: 16];
    self.label.backgroundColor = [UIColor systemBackgroundColor]; 
    [self.iView addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
//    self.label.clipsToBounds = YES;
//    self.label.layer.cornerRadius = 5;
    self.label.layer.borderColor = [UIColor clearColor].CGColor;
    self.label.numberOfLines = 1;
    [self.label sizeToFit];
    


    
    self.label.layer.borderWidth = 1;
//    self.label.layer.borderColor = [UIColor systemPinkColor].CGColor; 
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor systemGrayColor];
    
    self.label.backgroundColor = [UIColor systemBackgroundColor];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
