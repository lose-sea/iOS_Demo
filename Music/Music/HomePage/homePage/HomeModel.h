//
//  HomeModel.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface HomeModel : NSObject
@property (nonatomic, strong) NSMutableArray* DailyRecommendImages;

@property (nonatomic, strong) NSMutableArray* RecommendSongListImages;

@property (nonatomic, strong) NSMutableArray* songLists; 

@property (nonatomic, strong) NSMutableArray* songs;

@property (nonatomic, strong) UserModel* user;
@end

