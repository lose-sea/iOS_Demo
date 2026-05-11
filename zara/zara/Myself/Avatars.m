//
//  avatars.m
//  zara
//
//  Created by lose_sea on 2026/5/8.
//

#import "Avatars.h"

@interface Avatars ()
@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation Avatars

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"头像"; 
    // Do any additional setup after loading the view.
    [self setDataArray];
    [self setCollectionView];

}

- (void) setCollectionView {
    // 设置布局
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置每个cell的大小
    flowLayout.itemSize = CGSizeMake(100, 100);
    
    // 设置同一行中cell的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    // 行与行之间的间距  
    flowLayout.minimumLineSpacing = 10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame: self.view.bounds collectionViewLayout: flowLayout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview: self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        //上, 左, 下, 右
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(100, 20, 100, 20));
    }];
    

    // 注册cell
    [self.collectionView registerClass: [UICollectionViewCell class] forCellWithReuseIdentifier: @"cellID"];
    
    // 设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

// 设置数据
- (void) setDataArray {
    self.images = [[NSMutableArray alloc] init];
    for (int i = 0; i < 30; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.images addObject: image];
    }
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

// 配置cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"cellID" forIndexPath: indexPath];
    UIImageView* iView = [[UIImageView alloc] initWithImage: self.images[indexPath.row]];
    cell.backgroundView = iView;
    return cell; 
}

// 设置点击事件
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    AvatarWillChange* vc = [[AvatarWillChange alloc] init];
    vc.image = ((UIImageView*)[collectionView cellForItemAtIndexPath: indexPath].backgroundView).image;
    [self.navigationController pushViewController: vc animated: YES]; 
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
