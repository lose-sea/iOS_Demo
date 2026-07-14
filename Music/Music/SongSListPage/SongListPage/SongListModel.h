//
//  SongListModel.h
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import <Foundation/Foundation.h>
#import "SongList.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongListModel : NSObject
@property (nonatomic, strong) SongList* songList;
@property (nonatomic, strong) NSMutableArray* songs;
@end

NS_ASSUME_NONNULL_END
