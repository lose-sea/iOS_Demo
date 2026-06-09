//
//  ArticlePageModel.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "ArticlePageModel.h"

@implementation ArticlePageModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.article = [[article alloc] init];
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
