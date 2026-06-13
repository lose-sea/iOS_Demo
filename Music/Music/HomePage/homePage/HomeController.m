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
    
    for (int i = 0; i < 12; i++) {
        NSString* songCoverName = [NSString stringWithFormat: @"%d.jpg", i + 36];
        UIImage* songCover = [UIImage imageNamed: songCoverName];
        Song* song = [[Song alloc] initWithCover: songCover Name: @"我真的很爱你" Artist: @"林俊杰"];
        [self.homeModel.songs addObject: song];
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
        return 300;
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
        label.text = @"近期云村热播 >";
        label.font = [UIFont boldSystemFontOfSize: 20];
        [header addSubview: label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(header).offset(10);
            make.bottom.mas_equalTo(header);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(50);
        }];
        return header;
    } else {
        return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        RecommendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"RecommendTableViewCellID" forIndexPath: indexPath];
        cell.sectionType = indexPath.section;
        if (indexPath.section == 0) {
            [cell.collectionView registerClass: [DailyRecommendCell class] forCellWithReuseIdentifier: @"DailyRecommendCellID"];
            cell.collectionView.delegate = self;
            cell.collectionView.dataSource = self;
            return cell;
        } else {
            [cell.collectionView registerClass: [RecommendPlayListCell class] forCellWithReuseIdentifier: @"RecommendPlayListCellID"];
            cell.collectionView.delegate = self;
            cell.collectionView.dataSource = self;
            return cell;
        }
    } else {
        HotSongTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"HotSongTableViewCellID" forIndexPath: indexPath];
        cell.sectionType = indexPath.section; 
        [cell.collectionView registerClass: [HotSongCell class] forCellWithReuseIdentifier: @"HotSongCellID"];
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
- (UITableViewCell*) findSuperViewOfCell: (UICollectionView*) collectionView {
    // 向上遍历，找到collectionView 对应的 RecommendTableViewCell
    UIView *superView = collectionView.superview;
    while (superView && ![superView isKindOfClass:[RecommendTableViewCell class]] && ![superView isKindOfClass: [HotSongTableViewCell class]]) {
        superView = superView.superview;
    }
    if ([superView isKindOfClass: [RecommendTableViewCell class]]) {
        return (RecommendTableViewCell*)superView;
    } else {
        return (HotSongTableViewCell*)superView;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    RecommendTableViewCell* cell = [self findSuperViewOfCell: collectionView];
    if (cell.sectionType == 0) {
        return 6;
    } else if (cell.sectionType == 1) {
        return 7;
    }
    return 12; 
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
    } else if (view.sectionType == 1) {
        RecommendPlayListCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"RecommendPlayListCellID" forIndexPath: indexPath];
        cell.iView.image = self.homeModel.RecommendSongListImages[indexPath.item];
        cell.label.text = @" \"你在我心里是个很烂很烂的人\"";
        return cell;
    } else {
        HotSongCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HotSongCellID" forIndexPath: indexPath];
        Song* song = self.homeModel.songs[indexPath.item];
        cell.song = song;
        [cell configWithSong: song];
        
        [cell.playButton addTarget: self action: @selector(pressPlayButton) forControlEvents: UIControlEventTouchUpInside];
        return cell;
    }
}

- (void) pressPlayButton {
    NSLog(@"点击了播放按钮");
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
