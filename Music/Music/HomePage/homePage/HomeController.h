//
//  HomeController.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "HomeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) HomeModel* homeModel;
@property (nonatomic, strong) HomeView* homeView;
@end

NS_ASSUME_NONNULL_END
