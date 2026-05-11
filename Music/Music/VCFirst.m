//
//  VCFirst.m
//  Music
//
//  Created by lose_sea on 2026/4/29.
//

#import "VCFirst.h"
@interface VCFirst ()

@end

@implementation VCFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏设置
    [self NavigationBarAppearance];
    // 添加导航栏按钮
    [self addButtonToNavigationBar];
    // 每日推荐
//    [self dailyRecommendation];
    [self hot01]; 

}

// 导航栏外观设置
- (void)  NavigationBarAppearance{
    // 设置导航栏是否透明
    // 使视图从导航栏的下方开始, 不会被导航栏遮蔽
    self.navigationController.navigationBar.translucent = NO;
    
    // 设置导航栏外观
    // 通过Appearan 来设置导航栏外观
    UINavigationBarAppearance* BarAppearace = [[UINavigationBarAppearance alloc] init];
    
    // 背景颜色
    BarAppearace.backgroundColor = [UIColor greenColor];
    
    // 标题设置
    BarAppearace.titleTextAttributes = @{
        // 字体颜色
        NSForegroundColorAttributeName: [UIColor redColor],
        // 字体大小
        NSFontAttributeName: [UIFont boldSystemFontOfSize: 30]
    };
    
    
    // 导航按钮设置
    BarAppearace.buttonAppearance.normal.titleTextAttributes = @{
        // 导航栏按钮文字颜色
        NSForegroundColorAttributeName: [UIColor redColor]
    };
    
    
    // 应用
    UINavigationBar* narbar = self.navigationController.navigationBar;
    narbar.standardAppearance = BarAppearace;
    narbar.scrollEdgeAppearance = BarAppearace;
}
 
// 添加导航栏按钮
- (void) addButtonToNavigationBar {
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle: @"next" style: UIBarButtonItemStylePlain target: self action: @selector(pressNext)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIBarButtonItem* crush = [[UIBarButtonItem alloc] initWithTitle: @"crush" style: UIBarButtonItemStylePlain target: self action: @selector(pressNext)];
    self.navigationItem.rightBarButtonItem = crush;
}

- (void) pressNext {
    
}


// 每日推荐, 使用 UICollectionView 实现
- (void) dailyRecommendation {
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"VCFirst";
    
    self.array = [[NSMutableArray alloc] init];
    //流式布局
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;  //  横向滚动
    
    // 每个cell的大小
    flowLayout.itemSize = CGSizeMake(100, 160);
    // 同一行中cell之间的间隔
    flowLayout.minimumLineSpacing = 20;
    // 行与行之间的大小
    flowLayout.minimumInteritemSpacing = 10;
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, 50 * 10, 100) collectionViewLayout: flowLayout];
    
    //设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
      
    
    UIImageView* iView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"7.jpg"]];
    collectionView.backgroundView = iView;
    [self.view addSubview: collectionView];
    
    // 注册cell
    [collectionView registerClass: [UICollectionViewCell  class] forCellWithReuseIdentifier: @"CollectionViewID"];
    
    for (int i = 0; i < 30; i++) {
        NSString* strName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        UIImage* image = [UIImage imageNamed: strName];
        [self.array addObject: image];
    }
}

// 实现协议方法
// 每组cell的个数
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (__kindof UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"CollectionViewID" forIndexPath: indexPath];
    cell.backgroundColor = [UIColor systemCyanColor];
    
    for (UIView* view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView* iView = [[UIImageView alloc] initWithImage: self.array[indexPath.item]];
    iView.frame = cell.contentView.bounds;
    [cell.contentView addSubview: iView];
    
    return cell;
}




// 每日推荐
// 使用 scrollView 实现
- (void) hot01 {
    self.title = @"VCFirst";
    self.view.backgroundColor = [UIColor greenColor];
    
//    滚动视图
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor systemCyanColor];
    [self.view addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(200);
    }];

    // 是否开启滚动效果
    // 设置为NO, 滑动就视图不会动
    _scrollView.scrollEnabled = YES;
    // 按页滚动
    self.scrollView.pagingEnabled = YES;
    // 是否可以边缘弹动效果
    // 默认为 YES
    self.scrollView.bounces = NO;
    
    // 是否开启 横向 / 纵向 弹动效果
    // 默认为NO
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    
    // 显示 横向 / 纵向 滚动条
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    
    // 设置画布大小
    // 高度设为 0 ,自适应
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 6, 0);
    
    for (int i = 0; i < 5; i++) {
        NSString* strName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        UIImage* image = [UIImage imageNamed: strName];
        UIImageView* iView = [[UIImageView alloc] initWithImage: image];
        
        [self.scrollView addSubview: iView];
        [iView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.scrollView);
            make.height.mas_equalTo(self.scrollView);
            make.width.mas_equalTo(self.scrollView);
            make.left.equalTo(self.scrollView.mas_left).offset(self.view.bounds.size.width * i);
        }];
        [self.array addObject: image];
    }
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
