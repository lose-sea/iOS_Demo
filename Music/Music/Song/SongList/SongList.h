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
@property (nonatomic, strong) UIImage* coverImage;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* author; 

- (instancetype) initWithCover: (UIImage*) cover Name: (NSString*) name message: (NSString*) message; 
@end

NS_ASSUME_NONNULL_END
