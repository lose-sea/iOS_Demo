//
//  Song.h
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Song : NSObject
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* songer;
@end

NS_ASSUME_NONNULL_END
