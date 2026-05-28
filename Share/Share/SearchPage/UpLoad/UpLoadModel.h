//
//  UpLoadModel.h
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadModel : NSObject
@property (nonatomic, strong) NSMutableArray* tags;
@property (nonatomic, strong) NSMutableArray* categorys;
@property (nonatomic, assign) BOOL agreeDownLoad;
@property (nonatomic, assign) BOOL isFold;

@property (nonatomic, strong) NSMutableArray* coverImages; 
@end

NS_ASSUME_NONNULL_END
