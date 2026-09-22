//
//  PlayerDetailShowViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "PlayerDetailShowView.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetailShowViewController : UIViewController
@property (nonatomic, strong) Song* song;
@property (nonatomic, strong) PlayerDetailShowView* playerDetailShowViewController;

@end

NS_ASSUME_NONNULL_END
