//
//  SearchResultShowView.h
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import <UIKit/UIKit.h>
#import "SearchPageModel.h"
#import "CustomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchResultShowView : UIView
@property (nonatomic, strong) SearchPageModel* searchPageModel;
@property (nonatomic, strong) UITableView* tableView; 
@end

NS_ASSUME_NONNULL_END
