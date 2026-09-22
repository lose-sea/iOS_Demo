//
//  HomeModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeModel.h"
#import "Singer.h"

@implementation HomeModel

+ (NSArray<Song *> *)sampleSongs {
    NSArray *raw = @[
        @{@"image": @"9.jpg",  @"title": @"晴天",             @"singer": @"周杰伦", @"singerImg": @"21.jpg"},
        @{@"image": @"10.jpg", @"title": @"Blinding Lights",  @"singer": @"The Weeknd", @"singerImg": @"22.jpg"},
        @{@"image": @"11.jpg", @"title": @"夜曲",             @"singer": @"周杰伦", @"singerImg": @"21.jpg"},
        @{@"image": @"12.jpg", @"title": @"Shape of You",     @"singer": @"Ed Sheeran", @"singerImg": @"23.jpg"},
        @{@"image": @"13.jpg", @"title": @"稻香",             @"singer": @"周杰伦", @"singerImg": @"21.jpg"},
        @{@"image": @"14.jpg", @"title": @"Levitating",       @"singer": @"Dua Lipa", @"singerImg": @"24.jpg"},
        @{@"image": @"15.jpg", @"title": @"七里香",           @"singer": @"周杰伦", @"singerImg": @"21.jpg"},
        @{@"image": @"16.jpg", @"title": @"Bad Guy",          @"singer": @"Billie Eilish", @"singerImg": @"25.jpg"},
        @{@"image": @"17.jpg", @"title": @"后来",             @"singer": @"刘若英", @"singerImg": @"26.jpg"},
        @{@"image": @"18.jpg", @"title": @"Watermelon Sugar", @"singer": @"Harry Styles", @"singerImg": @"27.jpg"},
        @{@"image": @"19.jpg", @"title": @"平凡之路",         @"singer": @"朴树", @"singerImg": @"28.jpg"},
        @{@"image": @"20.jpg", @"title": @"Stay",             @"singer": @"The Kid LAROI, Justin Bieber", @"singerImg": @"29.jpg"},
    ];

    NSMutableArray<Song *> *songs = [NSMutableArray array];
    for (NSDictionary *d in raw) {
        Singer *singer = [[Singer alloc] init];
        singer.singerName = d[@"singer"];
        singer.avatarURL = d[@"singerImg"];

        Song *song = [[Song alloc] init];
        song.songName = d[@"title"];
        song.coverURL = d[@"image"];
        song.singer = singer;
        song.isFavourite = NO;
        [songs addObject:song];
    }
    return [songs copy];
}



#pragma mark - 首页分区

+ (NSArray<HomeSection *> *)sampleSections {
    return @[
        [self shortcutSection],
        [self todaySection],
        [self likedArtistSection],
        [self favouriteArtistSection],
        [self radioSection],
        [self albumSection]
    ];
}

/// 顶部快捷入口：左图右文小卡，无标题
+ (HomeSection *)shortcutSection {
    HomeSection *section = [[HomeSection alloc] init];
    section.title = @"";
    section.type = HomeSectionTypeShortcut;
    section.cards = @[
        [self cardWithImage:@"1.jpg" title:@"薛之谦全曲合集" subtitle:@"薛之谦" badge:nil],
        [self cardWithImage:@"2.jpg" title:@"香皂泡 合辑" subtitle:@"合辑" badge:nil]
    ];
    return section;
}

/// 今日推荐：方形封面 + 歌名 + 歌手
+ (HomeSection *)todaySection {
    HomeSection *section = [[HomeSection alloc] init];
    section.title = @"今日推荐";
    section.type = HomeSectionTypePlaylist;
    section.cards = @[
        [self cardWithImage:@"9.jpg"  title:@"晴天"             subtitle:@"周杰伦"               badge:nil],
        [self cardWithImage:@"10.jpg" title:@"Blinding Lights"  subtitle:@"The Weeknd"           badge:nil],
        [self cardWithImage:@"11.jpg" title:@"夜曲"             subtitle:@"周杰伦"               badge:nil],
        [self cardWithImage:@"12.jpg" title:@"Shape of You"     subtitle:@"Ed Sheeran"           badge:nil],
        [self cardWithImage:@"13.jpg" title:@"稻香"             subtitle:@"周杰伦"               badge:nil],
        [self cardWithImage:@"14.jpg" title:@"Levitating"       subtitle:@"Dua Lipa"             badge:nil],
        [self cardWithImage:@"15.jpg" title:@"七里香"           subtitle:@"周杰伦"               badge:nil],
        [self cardWithImage:@"16.jpg" title:@"Bad Guy"          subtitle:@"Billie Eilish"        badge:nil]
    ];
    return section;
}

/// 你喜欢的艺人：封面 + 中间横幅名字 + 下方描述
+ (HomeSection *)likedArtistSection {
    HomeSection *section = [[HomeSection alloc] init];
    section.title = @"你喜欢的艺人";
    section.type = HomeSectionTypeArtist;
    section.cards = @[
        [self cardWithImage:@"21.jpg" title:@"周杰伦"        subtitle:@"华语流行 · 48 首歌曲" badge:nil],
        [self cardWithImage:@"22.jpg" title:@"The Weeknd"    subtitle:@"R&B · 32 首歌曲"      badge:nil],
        [self cardWithImage:@"23.jpg" title:@"Ed Sheeran"    subtitle:@"民谣 · 27 首歌曲"     badge:nil],
        [self cardWithImage:@"24.jpg" title:@"Dua Lipa"      subtitle:@"流行 · 21 首歌曲"      badge:nil],
        [self cardWithImage:@"25.jpg" title:@"Billie Eilish" subtitle:@"另类 · 18 首歌曲"      badge:nil]
    ];
    return section;
}

/// 你最喜欢的艺人：圆形头像 + 名字
+ (HomeSection *)favouriteArtistSection {
    HomeSection *section = [[HomeSection alloc] init];
    section.title = @"你最喜欢的艺人";
    section.type = HomeSectionTypeCircle;
    section.cards = @[
        [self cardWithImage:@"21.jpg" title:@"周杰伦"        subtitle:@"" badge:nil],
        [self cardWithImage:@"26.jpg" title:@"刘若英"        subtitle:@"" badge:nil],
        [self cardWithImage:@"28.jpg" title:@"朴树"          subtitle:@"" badge:nil],
        [self cardWithImage:@"27.jpg" title:@"Harry Styles"  subtitle:@"" badge:nil],
        [self cardWithImage:@"29.jpg" title:@"Justin Bieber" subtitle:@"" badge:nil],
        [self cardWithImage:@"25.jpg" title:@"Billie Eilish" subtitle:@"" badge:nil]
    ];
    return section;
}

/// 推荐电台：彩色卡片 + 「电台」角标
+ (HomeSection *)radioSection {
    HomeSection *section = [[HomeSection alloc] init];
    section.title = @"推荐电台";
    section.type = HomeSectionTypeRadio;
    section.cards = @[
        [self cardWithImage:@"30.jpg" title:@"深夜电台"   subtitle:@"安静的夜晚"   badge:@"电台"],
        [self cardWithImage:@"31.jpg" title:@"通勤必听"   subtitle:@"路上不无聊"   badge:@"电台"],
        [self cardWithImage:@"32.jpg" title:@"华语新歌"   subtitle:@"每周更新"     badge:@"电台"],
        [self cardWithImage:@"33.jpg" title:@"运动节拍"   subtitle:@"高燃 BPM"     badge:@"电台"],
        [self cardWithImage:@"34.jpg" title:@"专注轻音乐" subtitle:@"写代码专用"   badge:@"电台"]
    ];
    return section;
}

/// 收录你喜爱歌曲的专辑
+ (HomeSection *)albumSection {
    HomeSection *section = [[HomeSection alloc] init];
    section.title = @"收录你喜爱歌曲的专辑";
    section.type = HomeSectionTypePlaylist;
    section.cards = @[
        [self cardWithImage:@"35.jpg" title:@"七里香"       subtitle:@"周杰伦"        badge:nil],
        [self cardWithImage:@"36.jpg" title:@"After Hours"  subtitle:@"The Weeknd"    badge:nil],
        [self cardWithImage:@"37.jpg" title:@"后来"         subtitle:@"刘若英"        badge:nil],
        [self cardWithImage:@"38.jpg" title:@"÷ (Divide)"   subtitle:@"Ed Sheeran"    badge:nil],
        [self cardWithImage:@"39.jpg" title:@"Future Nostalgia" subtitle:@"Dua Lipa"  badge:nil],
        [self cardWithImage:@"40.jpg" title:@"平凡之路"     subtitle:@"朴树"          badge:nil]
    ];
    return section;
}

#pragma mark - Private

+ (HomeCard *)cardWithImage:(NSString *)imageURL
                      title:(NSString *)title
                   subtitle:(NSString *)subtitle
                      badge:(NSString * _Nullable)badge {
    HomeCard *card = [[HomeCard alloc] init];
    card.imageURL = imageURL;
    card.title = title;
    card.subtitle = subtitle;
    card.badge = badge;
    return card;
}


@end
