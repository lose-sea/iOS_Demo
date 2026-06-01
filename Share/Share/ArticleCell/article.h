//
//  article.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface article : NSObject
@property (nonatomic,strong) UIImage* image;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* massage;
@property (nonatomic, strong) NSString* author;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isSave;

@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger saveCount;


- (instancetype) initWitImage: (UIImage*) image Name: (NSString*) name autoor: (NSString*) author massage: (NSString*) massage ;
@end

NS_ASSUME_NONNULL_END
