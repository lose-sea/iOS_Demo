//
//  Song.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Singer;
NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject
@property (nonatomic, strong) UIImage *songCover;
@property (nonatomic, strong) NSString *songName;
@property (nonatomic, strong) Singer *singer;
@property (nonatomic, assign) BOOL isFavourite;
@end

NS_ASSUME_NONNULL_END
