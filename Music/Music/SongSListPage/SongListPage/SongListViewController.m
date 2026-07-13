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
    // Do any additional setup after loading the view.
    [self setUpData];
}

- (void) setUpData {
    self.songListModel = [[SongListModel alloc] init];
    self.songSListView  = [[SongListView alloc] init];
    
    self.songSListView.coverView.image = self.songListModel.songList.coverImage; 
    
}

#pragma mark - UITableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
