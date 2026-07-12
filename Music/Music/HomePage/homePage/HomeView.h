//
//  HomeView.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import "RecommendTableViewCell.h"
#import "HotSongTableViewCell.h"
#import "PlayView.h"



@interface HomeView : UIView
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIScrollView* scrollView; 
@property (nonatomic, strong) PlayView* playView;
@end
