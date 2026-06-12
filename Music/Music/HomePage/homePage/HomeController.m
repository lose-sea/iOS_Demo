//
//  HomeController.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "HomeController.h"
@interface HomeController ()

@end

@implementation HomeController      
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    

    
    // Do any additional setup after loading the view.
    
    [self setUpData];
    [self setUpNavigation];
}
- (void) setUpNavigation {
    UIBarButtonItem* menus = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"text.justify"] style: UIBarButtonItemStylePlain target: self action: @selector(pressMenuButton)];
    self.navigationItem.leftBarButtonItem = menus;
}

- (void) pressMenuButton {
    NSLog(@"点击了菜单按钮");
}

- (void)setUpData {
    self.homeModel = [[HomeModel alloc] init];
    for (int i = 20; i < 30; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 1];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.DailyRecommendImages addObject: image];
    }
    
    for (int i = 0; i < 13; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d.jpg", i + 11];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.homeModel.RecommendSongListImages addObject: image];
    }
    
//    UIImageView* backView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"40.jpg"]];
//    [self.view addSubview: backView];
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view);
//    }];
    
    
    self.homeView = [[HomeView alloc] init];
    [self.view addSubview: self.homeView];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.homeView.tableView.delegate = self;
    self.homeView.tableView.dataSource = self;
}




#pragma mark - UITableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
 
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; 
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 || section == 2) {
        return 60;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 170;
    } else {
        return 200;
    }
}





- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView* header = [[UIView alloc] init];
        UILabel* label = [[UILabel alloc] init];
        label.text = @"推荐歌单 >";
        label.font = [UIFont boldSystemFontOfSize: 20];
        [header addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(header).offset(10);
            make.bottom.mas_equalTo(header);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
        return header;
    } if (section == 2) {
        UIView* header = [[UIView alloc] init];
        UILabel* label = [[UILabel alloc] init];
        label.text = @"云村最近热播 >";
        label.font = [UIFont boldSystemFontOfSize: 20];
        [header addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(header).offset(10);
            make.bottom.mas_equalTo(header);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
        return header;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"RecommendTableViewCellID" forIndexPath: indexPath];
    if (indexPath.section == 0) {
//        RecommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"RecommendTableViewCellID" forIndexPath: indexPath];
        cell.sectionType = indexPath.section;
        [cell.collectionView registerClass: [DailyRecommendCell class] forCellWithReuseIdentifier: @"PlayListCellID"];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        return cell;
    } else/* if (indexPath.section == 1)*/ {
//        RecommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"RecommendTableViewCellID" forIndexPath: indexPath];
        cell.sectionType = indexPath.section;
        [cell.collectionView registerClass: [RecommendPlayListCell class] forCellWithReuseIdentifier: @"RecommendPlayListCellID"];
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - UICollectionView

// 找到 collectionView 对应的 tableViewCell
- (RecommendTableViewCell*) findSuperViewOfCell: (UICollectionView*) collectionView {
    // 向上遍历，找到collectionView 对应的 RecommendTableViewCell
    UIView *superView = collectionView.superview;
    while (superView && ![superView isKindOfClass:[RecommendTableViewCell class]]) {
        superView = superView.superview;
    }
    return (RecommendTableViewCell*)superView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RecommendTableViewCell* cell = [self findSuperViewOfCell: collectionView];
    if (cell.sectionType == 0) {
        return 6;
    } else {
        return 7;
    }
    return 6;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RecommendTableViewCell* view = [self findSuperViewOfCell: collectionView];
    if (view.sectionType == 0) {
        DailyRecommendCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"DailyRecommendCellID" forIndexPath: indexPath];
        cell.backgroundColor = [UIColor systemBlueColor];
        cell.tagLabel.text = @"每日推荐";
        cell.iView.image = self.homeModel.DailyRecommendImages[indexPath.item];
        cell.messageLabel.text = @"今晚星星很少, 思念很长";
        return cell;
    } else /*if (view.sectionType == 1)*/ {
        RecommendPlayListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"RecommendPlayListCellID" forIndexPath: indexPath];
        cell.iView.image = self.homeModel.RecommendSongListImages[indexPath.item];
        cell.label.text = @"深夜emo: 跟遗憾吧,我们连最后一张合照都没有";
        return cell;
    }
//    return nil;
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
