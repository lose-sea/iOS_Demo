//
//  HomeView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import "HomeView.h"
#import "PlayerModel.h"

#pragma mark - 常量

NSString *const HomePlaylistCardsCellID = @"HomePlaylistCardsCell";
NSString *const HomeSongCellID = @"HomeSongCell";

static const CGFloat kCardCoverSide = 150.0;
static const CGFloat kCardHeight = 188.0;
static const CGFloat kCardsRowHeight = kCardHeight + 24.0; // 上下各 12pt
static const CGFloat kMiniPlayerReservedHeight = 64.0 + 24.0; // 64高 + 上下各12



#pragma mark - HomeView

@implementation HomeView

- (instancetype)init {
    if ((self = [super init])) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    
}

@end
