//
//  SearchPageModel.h
//  Share
//
//  Created by lose_sea on 2026/5/24.
//

#import <Foundation/Foundation.h>
#import "article.h"


@interface SearchPageModel : NSObject
@property (nonatomic, strong) NSMutableArray* tags; 

@property (nonatomic, strong) NSArray* categorys;
@property (nonatomic, strong) NSArray* recommends;
@property (nonatomic, strong) NSArray* timers;
@property (nonatomic, strong) NSMutableArray* coverImages;
@property (nonatomic, strong) NSMutableArray* articles; 
@end


