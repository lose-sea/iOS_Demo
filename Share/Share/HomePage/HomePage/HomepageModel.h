//
//  HomepageModel.h
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "article.h"


@interface HomepageModel : NSObject
@property (nonatomic, strong) NSMutableArray<UIImage*>* scrollImages;
@property (nonatomic, strong) NSMutableArray<article*>* articles;
@end


