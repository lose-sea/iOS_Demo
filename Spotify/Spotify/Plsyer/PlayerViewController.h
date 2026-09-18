//
//  PlayerViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <UIKit/UIKit.h>
#import "PlayerModel.h"
#import "PlayerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayerViewController : UIViewController
@property (nonatomic, strong) PlayerModel* playerModel;
@property (nonatomic, strong) PlayerView* playerView; 
@end

NS_ASSUME_NONNULL_END
