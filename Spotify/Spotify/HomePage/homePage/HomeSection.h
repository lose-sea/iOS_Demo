//
//  HomeSection.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <Foundation/Foundation.h>
#import "HomeCard.h"

NS_ASSUME_NONNULL_BEGIN

/// 首页分区展示样式
typedef NS_ENUM(NSUInteger, HomeSectionType) {
    /// 顶部快捷入口：左图右文小卡
    HomeSectionTypeShortcut = 0,
    /// 大卡：方形封面 + 标题 + 副标题
    HomeSectionTypePlaylist,
    /// 封面 + 中间横幅 + 副标题
    HomeSectionTypeArtist,
    /// 圆形头像 + 名字
    HomeSectionTypeCircle,
    /// 彩色卡片 + 角标 + 标题
    HomeSectionTypeRadio
};

/// 首页一个横向滑动分区
@interface HomeSection : NSObject

/// 分区标题，为空则不显示
@property (nonatomic, copy) NSString *title;
///  分区的展示样式
@property (nonatomic, assign) HomeSectionType type;

///  分区中所有卡片
@property (nonatomic, copy) NSArray<HomeCard *> *cards;

@end

NS_ASSUME_NONNULL_END
