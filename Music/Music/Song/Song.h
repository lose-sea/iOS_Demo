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
@property (nonatomic, strong) UIImage* coverImage;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* artist;

- (instancetype) initWithCover: (UIImage*) coverImage Name: (NSString*) name Artist: (NSString*) artist;
@end

NS_ASSUME_NONNULL_END
