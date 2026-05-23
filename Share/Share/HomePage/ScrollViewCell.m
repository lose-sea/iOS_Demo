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
        [self setpageControl];
        [self setTimer];
    }
    return self;
}
// 添加 scrollView
- (void) setScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    // 按页翻动
    self.scrollView.pagingEnabled = YES;
    // 允许滑动
    self.scrollView.scrollEnabled = YES;
    
    [self.contentView addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.scrollView.delegate = self;
}


// 代码触发的滚动
//- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSInteger page = [self currentPage];
//    if (page == 0) {
//        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (self.homeModel.scrollImages.count - 2),  0) animated: NO];
//    } else if (page == self.homeModel.scrollImages.count - 1) {
//        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * 1, 0) animated: NO];
//    }
//    NSInteger offset = self.scrollView.contentOffset.x / self.contentView.bounds.size.width;
//    if (offset == self.homeModel.scrollImages.count - 1) {
//        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width, 0) animated: NO];
//    }
//}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger page = [self currentPage];
    if (page == 0) {
        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (self.homeModel.scrollImages.count - 2), 0) animated: NO];
    } else if (page == self.homeModel.scrollImages.count - 1) {
        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * 1, 0) animated: NO];
    }
}

// 手动滑动
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [self currentPage];
    if (page == 0) {
        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (self.homeModel.scrollImages.count - 2),  0) animated: NO];
    } else if (page == self.homeModel.scrollImages.count - 1) {
        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * 1, 0) animated: NO];
    }
    NSInteger offset = self.scrollView.contentOffset.x / self.contentView.bounds.size.width;
    if (offset == self.homeModel.scrollImages.count - 1) {
        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width, 0)];
    }
    [self setTimer];
}

// 添加 pageControl
- (void) setpageControl {
    self.pageControl = [[UIPageControl alloc] init];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    // 当只有一页时隐藏pgaeControl
    self.pageControl.hidesForSinglePage = YES;
    
    [self.contentView addSubview: self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    self.pageControl.currentPage = 0;
    
    [self.pageControl addTarget: self action: @selector(pageChange) forControlEvents: UIControlEventValueChanged];
}

#pragma mark - pageControl改变滑动scrollView
- (void) pageChange {
    [self stopTimer];
    
    NSInteger index = self.pageControl.currentPage;
    [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (index + 1), 0) animated: YES];
    
    [self setTimer];
}


- (void) configureData:(NSMutableArray *)images {
    // 设置总页数
    self.pageControl.numberOfPages = images.count - 2;
    
    self.scrollView.contentSize = CGSizeMake(self.contentView.bounds.size.width * images.count, self.contentView.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.contentView.bounds.size.width, 0);
    
    for (int i = 0; i < images.count; i++) {
        UIImage* image = images[i];
        UIImageView* iView = [[UIImageView alloc] initWithImage: image];
        iView.contentMode = UIViewContentModeScaleAspectFill;
        iView.clipsToBounds = YES;
        [self.scrollView addSubview:iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scrollView).offset(self.contentView.bounds.size.width * i);
            make.top.mas_equalTo(self.scrollView);
            make.width.height.mas_equalTo(self.contentView);
        }];
    }
}




#pragma mark - 滑动scrollView时更新pageControl
// 获取当前页码
- (CGFloat) currentPage {
    NSInteger page = (self.scrollView.contentOffset.x + 0.5 * self.scrollView.bounds.size.width) / self.contentView.bounds.size.width;
    return page;
}

// 滑动scrollView 更新pageControl
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = [self currentPage] - 1;
    if (page == self.homeModel.scrollImages.count - 2) {
        page = 0;
    } else if (page == -1) {
        page = self.pageControl.numberOfPages - 1;
    }
    self.pageControl.currentPage = page;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
    NSLog(@"开始滑动");
}


#pragma mark - 定时器
- (void) setTimer {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(nextPage) userInfo: nil repeats: YES];
    }
}

- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) nextPage {
    NSLog(@"=== nextPage 开始 ===");
    NSLog(@"1. 改变前 pageControl.currentPage = %ld", self.pageControl.currentPage);
    NSInteger page = self.pageControl.currentPage + 1;
    if (page == self.pageControl.numberOfPages) {
        page = 0;
    }
    self.pageControl.currentPage = page;
    if (page == 0) {
        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (page + 1), 0) animated: NO];
    } else {
        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (page + 1), 0) animated: YES];
    }
}





//- (void) layoutSubviews {
//    [super layoutSubviews];
//    
//    CGFloat width = self.scrollView.bounds.size.width;
//    CGFloat height = self.scrollView.bounds.size.height;
//    for (int i = 0; i < self.homeModel.scrollImages.count; i++) {
//        UIImageView* iView = [self.scrollView viewWithTag: 100 + i];
//        iView.frame = CGRectMake(width * i, 0, width, height);
//    }
//    self.scrollView.contentSize = CGSizeMake(width * self.homeModel.scrollImages.count, height);
//}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
