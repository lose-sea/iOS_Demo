//
//  ArticlePageModel.h
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import <Foundation/Foundation.h>
#import "article.h"
NS_ASSUME_NONNULL_BEGIN

@interface ArticlePageModel : NSObject
@property (nonatomic, strong) article* article;
@property (nonatomic, strong) NSMutableArray* images;
@end


NS_ASSUME_NONNULL_END
