//
//  homepage.m
//  zara
//
//  Created by lose_sea on 2026/5/5.
//

#import "Homepage.h"

@interface Homepage ()
// 页面控制器
@property (nonatomic, strong) UIPageControl* pageControl;

// 滚动视图
@property (nonatomic, strong) UIScrollView* scrollView;
// 定时器
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation Homepage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor blackColor];
    
//    self.view.backgroundColor = [UIColor systemCyanColor];
    
    // 导航栏颜色设置
//    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self setNavigationController];
    [self setTimer];
    
    // 设置界面
    [self setInterface];
    [self setPageControl];

}



#pragma mark - 定时器

// 开启定时器
- (void) setTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 2 target: self selector: @selector(nextPage) userInfo: nil repeats: YES];
}

// 获取当前页码
- (NSInteger) currentPage {
    NSInteger page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    return page;
}

// 定时器方法
// 通过 UIPageControl 来控制翻页
- (void) nextPage {
    NSInteger index = self.pageControl.currentPage + 1;
    if (index == 3) {
        index = 0;
    }
    self.pageControl.currentPage = index;
    [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (index + 1), 0) animated:YES];
}
// 关闭定时器
- (void) stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}




#pragma mark - 界面, 滚动视图
// 设置界面
- (void) setInterface {
    // 设置标签
    UIImage* imaegZara = [UIImage imageNamed: @"1.png"];
    UIImageView* ZaraView = [[UIImageView alloc] initWithImage: imaegZara];
//    ZaraView.backgroundColor = [UIColor blackColor];
    [self.view addSubview: ZaraView];
    [ZaraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(60);
        make.left.mas_equalTo(self.view).offset(20);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(180);
    }];
    
    
    //设置滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor systemCyanColor];
    [self.view addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(200);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.mas_width);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-100);
    }];
    
    // 设置代理
    self.scrollView.delegate = self;
    

    // 设置允许滑动
    self.scrollView.scrollEnabled = YES;
    
    // 按页滑动
    self.scrollView.pagingEnabled = YES;
    
    // 显示 横向 / 纵向 滚动条
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    // 超出视图的部分裁剪
    self.scrollView.clipsToBounds = YES;
    
    
    // 设置无限轮播视图
    // 在开头和末尾设置临时视图用于跳转
    // 设置图片名称Array
    NSMutableArray* imageNames = [[NSMutableArray alloc] init];
    [imageNames addObject: @"3.jpg"];
    for (int i = 0; i < 3; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        [imageNames addObject: imageName];
    }
    [imageNames addObject: @"1.jpg"];
    
    
    // 设置画布大小
    // 高度自适应(横向滚动,纵向不滚动)
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 5, 0);
    
    // 开始跳过第一个临时视图, 显示第一个视图
    // 从索引 1 开始显示
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    
    // 添加图片
    for (int i = 0; i < imageNames.count; i++) {
        NSString* imageName = imageNames[i];
        UIImage* image = [UIImage imageNamed: imageName];
        UIImageView* iView = [[UIImageView alloc] initWithImage: image];
        
        // 强制把图片拉伸、压扁，让它完全填满整个框 (图片会变形)
        iView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview: iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.bounds.size.width * i);
            make.top.mas_equalTo(self.scrollView);
            make.height.mas_equalTo(self.scrollView);
            make.width.mas_equalTo(self.scrollView);
        }];
    }
}


// 设置代理方法
// 当将要滑动滚动视图的时候关闭定时器
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

//// 在滑动过程中实时给更新pageControl
//- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger page = [self currentPage];
//    
//    if (page == 0) {
//        self.pageControl.currentPage = 2;
//    } else if (page == 4) {
//        self.pageControl.currentPage = 0;
//    } else {
//        self.pageControl.currentPage = page - 1; 
//    }
//}


// 当视图切换到临时视图的时候进行跳转
// 在滑动完成时候更新 UIPageControl
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = [self currentPage];
    
    if (page == 0) {
        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * 3, 0) animated: NO];
        self.pageControl.currentPage = 2;
    } else if (page == 4) {
        [scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * 1, 0) animated: NO];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = page - 1;
    }
    // 开启定时器
    [self setTimer];
}


#pragma mark - 导航栏
// 设置导航栏外观
- (void) setNavigationController {
    // 导航栏透明
    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    // 往导航栏中添加一个搜索按钮
    UIBarButtonItem* search = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSearch target: self action: @selector(pressSearch)];
    
    self.navigationItem.rightBarButtonItem = search;
}

// 按钮事件
- (void) pressSearch {
    NSLog(@"点击了搜索");
}



#pragma mark - UIPageControl
- (void) setPageControl {
    self.pageControl = [[UIPageControl alloc] init];
    
    // 设置总页数
    self.pageControl.numberOfPages = 3;
    
    // 设置当前页码
    self.pageControl.currentPage = 0;
    
    // 设置当前页指示器的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    // 设置其他页的指示器的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    // 隐藏 pageControl
    // 当只有一页的时候隐藏
    self.pageControl.hidesForSinglePage = YES;
    
    // 添加事件
    [self.pageControl addTarget: self
                         action: @selector(pageControlChange)
               forControlEvents: UIControlEventValueChanged];
    
    [self.view addSubview: self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
    }];
}

// 更新 pageControl 当前页
- (void) pageControlChange {
    [self stopTimer];
    NSInteger index = self.pageControl.currentPage;
    [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (index + 1), 0) animated:YES];
    [self setTimer];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

