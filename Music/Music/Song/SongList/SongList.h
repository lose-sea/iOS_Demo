//
//  SongLIst.h
//  Music
//
//  Created by lose_sea on 2026/7/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SongList : NSObject
@property (nonatomic, strong) UIImage* songListCover;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* message;
@end

NS_ASSUME_NONNULL_END
