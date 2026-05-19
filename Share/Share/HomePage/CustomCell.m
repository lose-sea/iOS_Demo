//
//  CustomCell.m
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import "CustomCell.h"

@implementation CustomCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style  reuseIdentifier: reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void) setUI {
    // 图片
    self.iView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.massageLabel = [[UILabel alloc] init];
    self.authorLabel = [[UILabel alloc] init];
    
    self.likeImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"heart"]];
    self.lookImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"eye"]];
    self.saveImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"star"]];
    
    self.likeLabel = [[UILabel alloc] init];
    self.lookLabel = [[UILabel alloc] init];
    self.saveLable = [[UILabel alloc] init];
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
