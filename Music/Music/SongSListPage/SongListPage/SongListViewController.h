//
//  SongListViewController.h
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import <UIKit/UIKit.h>
#import "SongListModel.h"
#import "SongListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
@property (nonatomic, strong) SongListModel* songListModel;
@property (nonatomic, strong) SongListView* songSListView; 
@end

NS_ASSUME_NONNULL_END
