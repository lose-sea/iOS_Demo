//
//  SearchViewController.m
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import "SearchViewController.h"
#import "SearchView.h"
#import "SearchHistorySectionCell.h"
#import "SearchGuessSectionCell.h"
#import "SearchRankSectionCell.h"
#import "SearchRankCardCell.h"
#import "SearchResultShowViewController.h"

static NSString * const kHistoryKey = @"SearchHistoryKeywords";
/// 最多保留几条历史记录（横向胶囊，超过就把最旧的挤掉）
static const NSInteger kMaxHistoryCount = 5;

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource,
                                    UISearchResultsUpdating, UISearchControllerDelegate,
                                    SearchHistorySectionCellDelegate,
                                    SearchGuessSectionCellDelegate,
                                    SearchRankSectionCellDelegate>

@property (nonatomic, strong) SearchView *searchView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultShowViewController *resultsViewController;

@property (nonatomic, copy) NSArray<NSString *> *historyWords;
@property (nonatomic, copy) NSArray<NSString *> *guessWords;
@property (nonatomic, copy) NSArray<SearchRankCard *> *rankCards;

/// 输入节流的待执行请求
@property (nonatomic, strong, nullable) dispatch_block_t pendingSearchBlock;

@end

@implementation SearchViewController

- (void)loadView {
    SearchView *searchView = [[SearchView alloc] init];
    self.searchView = searchView;
    self.view = searchView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self loadHistory];
    [self setUpSearchController];
    [self setUpTableView];
}

#pragma mark - 数据

- (void)loadData {
    // 猜你喜欢 / 排行榜：先用本地占位词，点击时会真的走网络搜索
    self.guessWords = @[@"海屿你", @"emo伤感天花板", @"儿歌多多", @"罗生门", @"红色高跟鞋", @"薛之谦"];

    SearchRankItem *item1 = [self rankItem:1 title:@"明知故犯" tag:@"爆"];
    SearchRankItem *item2 = [self rankItem:2 title:@"甲乙丙丁" tag:@"爆"];
    SearchRankItem *item3 = [self rankItem:3 title:@"两难pt2" tag:@"爆"];
    SearchRankItem *item4 = [self rankItem:4 title:@"茶汤" tag:@"热"];
    SearchRankItem *item5 = [self rankItem:5 title:@"特别的人" tag:@"↑"];    SearchRankItem *item6 = [self rankItem:6 title:@"琵琶曲" tag:nil];
    SearchRankItem *item7 = [self rankItem:7 title:@"我不难过" tag:nil];
    SearchRankItem *item8 = [self rankItem:8 title:@"Taylor Swift" tag:nil];

    SearchRankCard *hotSearchCard = [SearchRankCard cardWithTitle:@"热搜榜"
                                                            items:@[item1, item2, item3, item4, item5, item6, item7, item8]];
    SearchRankCard *hotSongCard = [SearchRankCard cardWithTitle:@"热歌榜"
                                                          items:@[
        [self rankItem:1 title:@"明知故犯" tag:nil],
        [self rankItem:2 title:@"海屿你" tag:nil],
        [self rankItem:3 title:@"如果呢" tag:nil],
        [self rankItem:4 title:@"甲乙丙丁" tag:nil],
        [self rankItem:5 title:@"我不难过" tag:nil],
        [self rankItem:6 title:@"忘不掉的" tag:nil],
        [self rankItem:7 title:@"茶汤" tag:nil],
        [self rankItem:8 title:@"碎碎念" tag:nil]
    ]];
    self.rankCards = @[hotSearchCard, hotSongCard];
}

- (SearchRankItem *)rankItem:(NSInteger)rank title:(NSString *)title tag:(NSString *)tag {
    SearchRankItem *item = [[SearchRankItem alloc] init];
    item.rank = rank;
    item.title = title;
    item.tag = tag;
    item.tagHighlighted = tag.length > 0 && ![tag isEqualToString:@"↑"];   // 爆/热 红底，↑ 绿色
    return item;
}

#pragma mark - 搜索记录

// 读取时顺手裁到上限，避免之前存过的数据超过 5 条
- (void)loadHistory {
    NSArray<NSString *> *stored = [[NSUserDefaults standardUserDefaults] stringArrayForKey:kHistoryKey] ?: @[];
    if (stored.count > kMaxHistoryCount) {
        stored = [stored subarrayWithRange:NSMakeRange(0, kMaxHistoryCount)];
        [[NSUserDefaults standardUserDefaults] setObject:stored forKey:kHistoryKey];
    }
    self.historyWords = stored;
}

// 去重置顶，最多保留 kMaxHistoryCount 条
- (void)saveKeyword:(NSString *)keyword {
    NSMutableArray<NSString *> *words = [self.historyWords mutableCopy] ?: [NSMutableArray array];
    [words removeObject:keyword];
    [words insertObject:keyword atIndex:0];
    if (words.count > kMaxHistoryCount) {
        [words removeObjectsInRange:NSMakeRange(kMaxHistoryCount, words.count - kMaxHistoryCount)];
    }
    self.historyWords = [words copy];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyWords forKey:kHistoryKey];
    [self reloadHistorySection];
}

- (void)removeKeywordAtIndex:(NSInteger)index {
    if (index >= self.historyWords.count) return;
    NSMutableArray<NSString *> *words = [self.historyWords mutableCopy];
    [words removeObjectAtIndex:index];
    self.historyWords = [words copy];
    [[NSUserDefaults standardUserDefaults] setObject:self.historyWords forKey:kHistoryKey];
    [self reloadHistorySection];
}

- (void)reloadHistorySection {
    [self.searchView.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                             withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setUpTableView {
    self.searchView.tableView.delegate = self;
    self.searchView.tableView.dataSource = self;
    [self.searchView.tableView reloadData];
}

#pragma mark - 搜索控制器

- (void)setUpSearchController {
    self.resultsViewController = [[SearchResultShowViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsViewController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"歌曲、歌手、专辑";

    // 系统标准搜索框（iOS 26 上自动渲染为新的玻璃样式）
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;   // 必须有，否则结果页无法正确呈现
}

#pragma mark - UISearchResultsUpdating

// 输入节流 0.3s：连续打字只在最后一次触发请求
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyword = searchController.searchBar.text ?: @"";
    NSLog(@"[Search] 输入变化：%@", keyword);

    [self cancelPendingSearch];

    __weak typeof(self) weakSelf = self;
    self.pendingSearchBlock = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS, ^{
        [weakSelf.resultsViewController searchWithKeyword:keyword];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   self.pendingSearchBlock);
}

- (void)cancelPendingSearch {
    if (self.pendingSearchBlock) {
        dispatch_block_cancel(self.pendingSearchBlock);
        self.pendingSearchBlock = nil;
    }
}

#pragma mark - 发起搜索

// 点击历史记录 / 热词 / 榜单行
- (void)startSearchWithKeyword:(NSString *)keyword {
    if (keyword.length == 0) return;

    [self cancelPendingSearch];
    [self saveKeyword:keyword];
    self.searchController.searchBar.text = keyword;
    [self.resultsViewController searchWithKeyword:keyword];
    [self.searchController setActive:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;   // 搜索记录 / 猜你喜欢 / 排行榜
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 搜索记录是「一个横向容器 cell」显示全部历史，不是一行一条；没有记录时整个分区隐藏
    if (section == 0) return self.historyWords.count > 0 ? 1 : 0;
    return 1;   // 猜你喜欢 / 排行榜各一个容器 cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SearchGuessSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchGuessSectionCell"];
        if (!cell) {
            cell = [[SearchGuessSectionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:@"SearchGuessSectionCell"];
        }
        cell.delegate = self;
        [cell configureWithWords:self.guessWords];
        return cell;
    }

    if (indexPath.section == 2) {
        SearchRankSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchRankSectionCell"];
        if (!cell) {
            cell = [[SearchRankSectionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"SearchRankSectionCell"];
        }
        cell.delegate = self;
        [cell configureWithCards:self.rankCards];
        return cell;
    }

    // 搜索记录：横向胶囊
    SearchHistorySectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistorySectionCell"];
    if (!cell) {
        cell = [[SearchHistorySectionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"SearchHistorySectionCell"];
    }
    cell.delegate = self;
    [cell configureWithWords:self.historyWords];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.historyWords.count > 0) return @"搜索记录";
    return nil;   // 猜你喜欢 / 排行榜的标题在容器 cell 里
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return [SearchGuessSectionCell heightForWordCount:self.guessWords.count];
    }
    if (indexPath.section == 2) {
        return [SearchRankSectionCell height];
    }
    return [SearchHistorySectionCell height];   // 搜索记录：一条横向胶囊
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.historyWords.count > 0) return 40.0;
    return (section == 0) ? 8.0 : 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 历史记录的点击由 SearchHistorySectionCell 内部的 collectionView 处理
}

#pragma mark - SearchHistorySectionCellDelegate

- (void)historySectionCell:(SearchHistorySectionCell *)cell didSelectWord:(NSString *)word {
    [self startSearchWithKeyword:word];
}

- (void)historySectionCell:(SearchHistorySectionCell *)cell didDeleteWordAtIndex:(NSInteger)index {
    [self removeKeywordAtIndex:index];
}

#pragma mark - SearchGuessSectionCellDelegate

- (void)guessSectionCell:(SearchGuessSectionCell *)cell didSelectWord:(NSString *)word {
    [self startSearchWithKeyword:word];
}

#pragma mark - SearchRankSectionCellDelegate

- (void)rankSectionCell:(SearchRankSectionCell *)cell didSelectWord:(NSString *)word {
    [self startSearchWithKeyword:word];
}

@end
