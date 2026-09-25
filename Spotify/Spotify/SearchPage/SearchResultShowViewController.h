//
//  SearchResultShowViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 搜索结果页：UISearchController 激活时展示，tableView 列出搜索到的歌曲
@interface SearchResultShowViewController : UIViewController

/// 触发一次搜索（空串 = 清空结果回到提示态）
- (void)searchWithKeyword:(NSString *)keyword;

@end

NS_ASSUME_NONNULL_END
