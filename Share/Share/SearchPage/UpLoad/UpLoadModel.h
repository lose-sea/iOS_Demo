//
//  UpLoadModel.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadModel : NSObject
@property (nonatomic, strong) NSArray* tags;
@property (nonatomic, strong) NSArray* categorys;
@property (nonatomic, assign) BOOL agreeDownLoad;
@property (nonatomic, assign) BOOL isFold;
@end

NS_ASSUME_NONNULL_END
