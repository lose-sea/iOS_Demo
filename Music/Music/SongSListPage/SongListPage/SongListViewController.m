//
//  SongListViewController.m
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import "SongListViewController.h"

@interface SongListViewController ()

@end

@implementation SongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.v
    self.tabBarController.tabBar.hidden = YES;
    [self setUpData];
}

- (void) viewWillAppear:(BOOL)animated {
    self.songListView.playView.song = self.songListModel.user.song;
    [self.songListView.playView configWithSong: self.songListModel.user.song];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: YES];
    self.tabBarController.tabBar.hidden = NO; 
}

- (void) setUpData {
    self.songListModel = [[SongListModel alloc] init];
    self.songListView  = [[SongListView alloc] init];
    
    self.songListView.coverView.image = self.songListModel.songList.coverImage;
    
    for (int i = 0; i < 20; i++) {
        NSString* songCoverName = [NSString stringWithFormat: @"%d.jpg", i + 26];
        UIImage* songCover = [UIImage imageNamed: songCoverName];
        Song* song = [[Song alloc] initWithCover: songCover Name: @"其实雨也没多大" Artist: @"大碗小面 - 玻璃 (cover汤令山)"];
        [self.songListModel.songs addObject: song];
    }
    
    [self.view addSubview: self.songListView];
    [self.songListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.songListView.tableView.delegate = self;
    self.songListView.tableView.dataSource = self; 
    
    self.songListView.coverView.image = self.songList.coverImage;
    self.songListView.nameLabel.text = self.songList.name;
    self.songListView.authorLabel.text = self.songList.author;
}


#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    songCell* cell = [tableView dequeueReusableCellWithIdentifier: @"SongCellID" forIndexPath: indexPath];
    cell.song = self.songListModel.songs[indexPath.row];
    [cell configWithSong: self.songListModel.songs[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    songCell* cell = [tableView cellForRowAtIndexPath: indexPath];
    self.songListModel.user.song = cell.song;
    self.songListView.playView.song = cell.song;
    [self.songListView.playView configWithSong: self.songListModel.user.song]; 
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
