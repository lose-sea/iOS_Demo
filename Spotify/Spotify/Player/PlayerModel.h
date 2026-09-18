//
//  PlayerModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

/// 任何界面可监听此通知来刷新自己的播放相关 UI（miniPlayer、tabBar 角标等）
UIKIT_EXTERN NSString *const PlayerModelDidChangeNotification;

@interface PlayerModel : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong, nullable) Song *song;
@property (nonatomic, assign) BOOL isPlay;

@end

NS_ASSUME_NONNULL_END
