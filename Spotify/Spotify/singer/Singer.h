//
//  Singer.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Song;
NS_ASSUME_NONNULL_BEGIN

@interface Singer : NSObject
@property (nonatomic, strong) NSString *singerName;
@property (nonatomic, strong) UIImage *singerCover;
@property (nonatomic, strong) NSArray<Song*> *songs;

- (instancetype) initWithSingerName: (NSString*) name; 
@end

NS_ASSUME_NONNULL_END
