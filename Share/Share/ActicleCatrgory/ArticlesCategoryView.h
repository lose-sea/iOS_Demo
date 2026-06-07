//
//  ArticlesCategoryView.h
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import <UIKit/UIKit.h>
#import "article.h"
#import <Masonry/Masonry.h>
#import "CustomCell.h"




@interface ArticlesCategoryView : UIView
@property (nonatomic, strong) UIScrollView* scrollView; 
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UITableView* featuredTableView;
@property (nonatomic, strong) UITableView* hotTableView;
@property (nonatomic, strong) UITableView* allTableView;
@end

