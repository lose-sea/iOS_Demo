//
//  SearchPageModel.m
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import "SearchPageModel.h"

@implementation SearchPageModel
- (instancetype) init {
    self.articles = [[NSMutableArray alloc] init];
    self.categorys = [[NSArray alloc] init];
    self.recommends = [[NSArray alloc] init];
    self.timers = [[NSArray alloc] init];
    return self; 
}
@end
