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
        singer.singerCover = [UIImage imageNamed:d[@"singerImg"]];

        Song *song = [[Song alloc] init];
        song.songName = d[@"title"];
        song.songCover = [UIImage imageNamed:d[@"image"]];
        song.singer = singer;
        song.isFavourite = NO;
        [songs addObject:song];
    }
    return [songs copy];
}


+ (NSArray<NSDictionary *> *)samplePlaylistCards {
    return @[
        @{@"image": @"1.jpg",  @"title": @"Daily Mix 1",    @"desc": @"根据你的口味生成"},
        @{@"image": @"2.jpg",  @"title": @"发现周刊",        @"desc": @"每周为你更新的新音乐"},
        @{@"image": @"3.jpg",  @"title": @"热门华语",        @"desc": @"当下最火的华语歌曲"},
        @{@"image": @"4.jpg",  @"title": @"专注轻音乐",      @"desc": @"写代码时的最佳伴侣"},
        @{@"image": @"5.jpg",  @"title": @"复古派对",        @"desc": @"80、90 年代经典金曲"},
        @{@"image": @"6.jpg",  @"title": @"深夜独处",        @"desc": @"安静的夜晚，安静的歌"},
        @{@"image": @"7.jpg",  @"title": @"运动节拍",        @"desc": @"高燃 BPM 助你燃脂"},
        @{@"image": @"8.jpg",  @"title": @"轻松午后",        @"desc": @"慵懒时光，慢慢享受"}
    ];
}


@end
