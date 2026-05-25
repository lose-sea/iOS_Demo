//
//  SearchPageModel.h
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import <Foundation/Foundation.h>
#import "article.h"
NS_ASSUME_NONNULL_BEGIN

@interface SearchPageModel : NSObject
@property (nonatomic, strong) NSArray* categorys;
@property (nonatomic, strong) NSArray* recommends;
@property (nonatomic, strong) NSArray* timers;

@property (nonatomic, strong) NSArray* articles; 
@end

NS_ASSUME_NONNULL_END
