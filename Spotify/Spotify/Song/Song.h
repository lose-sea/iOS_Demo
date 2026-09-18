//
//  Song.h
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject
@property (nonatomic, strong) UIImage* songCocver;
@property (nonatomic, strong) NSString* songName;
@property (nonatomic, strong) NSString* songer;
@end

NS_ASSUME_NONNULL_END
