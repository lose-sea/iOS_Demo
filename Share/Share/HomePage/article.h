//
//  article.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface article : UIViewController
@property (nonatomic,strong) UIImage* iamge;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* massage;
@property (nonatomic, strong) NSString* author;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger saveCount; 
@end

NS_ASSUME_NONNULL_END
