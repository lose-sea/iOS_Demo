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
    self.homeModel.scrollImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 19];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.scrollImages addObject: image];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.bounds.size.width * (self.homeModel.scrollImages.count + 2),  self.contentView.bounds.size.height);
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
