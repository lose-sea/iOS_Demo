//
//  Song.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>

@class Singer;
NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject

/// 封面地址：网络 URL 或本地资源名（由 View 层用 sp_setImageWithSource: 决定怎么加载）
@property (nonatomic, copy) NSString *coverURL;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, strong) Singer *singer;
@property (nonatomic, assign) BOOL isFavourite;

- (instancetype) initWithCoverURL: (NSString*) coverURL name: (NSString*) songName singer: (Singer*) singer;

@end

NS_ASSUME_NONNULL_END
