//
//  Searchpage.m
//  zara
//
//  Created by lose_sea on 2026/5/5.
//

#import "Searchpage.h"

@interface Searchpage ()
// 分栏控件
@property (nonatomic, strong) UISegmentedControl* segmentedControl;

// 滚动视图
@property (nonatomic, strong) UIScrollView* scrollView;
// 滚动视图的图片名称
@property (nonatomic, strong) NSMutableArray* imageNames;



//定时器, 使视图自动轮播
@property (nonatomic, strong) NSTimer* timer;

@end

@implementation Searchpage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    // 设置分栏控件
    [self setSegmentedControl];
    
    // 设置滚动视图
    [self setInterface];
    
    // 设置定时器
    [self setTimer];
}





// 设置分栏控件
- (void) setSegmentedControl {
    NSArray *items = @[@"女士", @"儿童", @"男士"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems: items];
    
    // 背景颜色
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    
    // 设置默认选中的索引
    self.segmentedControl.selectedSegmentIndex = 0;
    
    // 分栏控件的宽度可变, 高度不可变
    self.segmentedControl.frame = CGRectMake(0, 20, self.view.bounds.size.width, 40);
    
    // 1. 设置【没选中】的文字颜色 → 黑色
    [self.segmentedControl setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor whiteColor]
    } forState: UIControlStateNormal];

    // 2. 设置【选中】的文字颜色 → 白色
    [self.segmentedControl setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor redColor]
    } forState: UIControlStateSelected];
    
    // 设置滑块颜色
    self.segmentedControl.selectedSegmentTintColor = [UIColor greenColor];
    
    
    // 设置分栏控件的文字颜色
    self.segmentedControl.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview: self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(80);
            make.left.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view);
            make.height.mas_equalTo(60);
    }];
    
    
    
    // 为分栏控件添加事件, 当滑动分栏控件的时候, 滚动视图也随之翻页
    // 当标签发生变化的时候调用事件
    [self.segmentedControl addTarget: self action: @selector(segmentChanged:) forControlEvents: UIControlEventValueChanged];
}



// 设置滚动界面
- (void) setInterface {
    //设置导航栏不透明, 使视图从导航栏下发开始, 不会被导航栏遮盖
    self.navigationController.navigationBar.translucent = NO;
    
    // 设置无限轮播视图
    // 在开头和末尾设置临时视图
    self.imageNames = [[NSMutableArray alloc] init];
    [self.imageNames addObject: @"3.jpg"];
    for (int i = 1; i <= 3; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i];
        [self.imageNames addObject: imageName];
    }
    [self.imageNames addObject: @"1.jpg"];
    
    // 设置滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(160);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-80);
    }];
    
    NSLog(@"%f", self.scrollView.bounds.size.width);
    
    // 强制刷新视图, 使约束生效
    [self.view layoutIfNeeded];
    
    NSLog(@"%f", self.scrollView.bounds.size.width); 
    
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * self.imageNames.count, 0);
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
     
    // 滚动视图的相关配置
    // 允许滑动
    self.scrollView.scrollEnabled = YES;
    // 按页滑动
    self.scrollView.pagingEnabled = YES;
    
    for (int i = 0; i < self.imageNames.count; i++) {
        NSString* imageName = self.imageNames[i];
        UIImage* image = [UIImage imageNamed: imageName];
        UIImageView* iView = [[UIImageView alloc] initWithImage: image];
        [self.scrollView addSubview: iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.scrollView.bounds.size.width * i);
            make.top.mas_equalTo(self.scrollView);
            make.width.mas_equalTo(self.scrollView.mas_width);
            make.height.mas_equalTo(self.scrollView.mas_height);
        }];
    }
    
    // 设置滚动视图的代理为当前控制器
    self.scrollView.delegate = self;
}


- (void) setTimer {
    // repeats: YES: 重复执行
    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector: @selector(nextPage) userInfo: nil repeats: YES];
}

- (void) stopTimer {
    // 停止定时器并从运行循环中移除
    [self.timer invalidate];
    // 置为空,防止多次创建
    self.timer = nil;
}

// 定时器事件, 定时翻页
- (void) nextPage {
    NSInteger nextIndex = self.segmentedControl.selectedSegmentIndex + 1;
    if (nextIndex == 3) {
        nextIndex = 0;
    }
    self.segmentedControl.selectedSegmentIndex = nextIndex;
    
    // 需要手动改变滚动视图
    [self segmentChanged: self.segmentedControl];
}

// 分栏控件点击响应
- (void)segmentChanged:(UISegmentedControl *) sender {
    
    // 在滑动分栏控件的时候, 关闭定时器
    [self stopTimer];
    
    NSInteger index = sender.selectedSegmentIndex;
    
    // 当分栏控件的索引发生改变,滚动视图也跟随滚动到相对应的页面
    // 设置当前scrollView的左边界
    CGFloat left = self.view.bounds.size.width * (index + 1);
    // 调用方法滚动到相应的页面
    // 滑动到指定的坐标 (x, y)
    // YES: 带动画
    [self.scrollView setContentOffset: CGPointMake(left, 0)  animated: NO];
    
    // 在用户点击分栏控件切换视图后, 再开启定时器
    [self setTimer];
}


// 获取当前滚动视图页码
- (NSInteger)currentPage {
    // 获取滚动视图的坐标
    // 计算出是当前视图的页码
    CGFloat width = self.scrollView.bounds.size.width;
    return self.scrollView.contentOffset.x / width - 1;
}



// 滑动完成后更新分栏控件
// 在滑倒临时页面的时候进行跳转
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

//    CGFloat page = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    
    CGFloat page = [self currentPage];
    if (page == -1) {
        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width * (self.imageNames.count - 2), 0) animated: NO];
        page = [self currentPage];
    } else if (page == self.imageNames.count - 2) {
        [self.scrollView setContentOffset: CGPointMake(self.scrollView.bounds.size.width, 0) animated: NO];
        page = [self currentPage];
    }
    
    self.segmentedControl.selectedSegmentIndex = page;
    
    // 滑动完成后, 开启定时器
    [self setTimer];
}



// 当用户滑动视图的时候, 关闭定时器
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}


// 滑动过程中实时更新（可选）
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSInteger currentPage = [self currentPage];
//    if (self.segmentedControl.selectedSegmentIndex != currentPage) {
//        self.segmentedControl.selectedSegmentIndex = currentPage;
//    }
//}





































// 设置导航控制器
// 将分栏控制器加入到导航栏中
- (void) setNavigationController {
    // 在导航栏设置分栏控制器
    NSArray *items = @[@"女士", @"儿童", @"男士"];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems: items];
    
    // 背景颜色
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    
    // 设置默认选中的索引
    self.segmentedControl.selectedSegmentIndex = 0;
    
    // 分栏控件的宽度可变, 高度不可变
    self.segmentedControl.frame = CGRectMake(0, 20, self.view.bounds.size.width, 40);
    
    // 1. 设置【没选中】的文字颜色 → 黑色
    [self.segmentedControl setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor whiteColor]
    } forState: UIControlStateNormal];

    // 2. 设置【选中】的文字颜色 → 白色
    [self.segmentedControl setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor redColor]
    } forState: UIControlStateSelected];
    
    // 设置滑块颜色
    self.segmentedControl.selectedSegmentTintColor = [UIColor greenColor];
    
    
    // 设置分栏控件的文字颜色
    self.segmentedControl.backgroundColor = [UIColor blackColor];
    
    self.segmentedControl.frame = CGRectMake(100, 200, self.view.bounds.size.width, 40);
    
//     设置导航栏标题视图
    self.navigationItem.titleView = self.segmentedControl;

//    [self.view addSubview: self.segmentedControl];
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
