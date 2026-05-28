//
//  ArticlesCategoryModel.h
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import <Foundation/Foundation.h>
#import "article.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArticlesCategoryModel : NSObject
@property (nonatomic, strong) NSMutableArray* featuredArticles;
@property (nonatomic, strong) NSMutableArray* hotArticles;
@property (nonatomic, strong) NSMutableArray* allArticles;
@end

NS_ASSUME_NONNULL_END
