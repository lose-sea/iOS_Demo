//
//  ArticlesCategoryModel.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ArticlesCategoryModel.h"

@implementation ArticlesCategoryModel
- (instancetype) init{
    self = [super init];
    if (self) {
        [self setData];
    }
    return self;
}


- (void) setData {
    self.featuredArticles = [[NSMutableArray alloc] init];
    self.hotArticles = [[NSMutableArray alloc] init];
    self.allArticles = [[NSMutableArray alloc] init];
}
@end
