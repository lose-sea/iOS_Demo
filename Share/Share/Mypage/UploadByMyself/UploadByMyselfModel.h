//
//  UploadByMyselfModel.h
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import <Foundation/Foundation.h>
#import "CustomCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadByMyselfModel : NSObject
@property (nonatomic, strong) NSMutableArray* articlesOfTime;
@property (nonatomic, strong) NSMutableArray* articlesOfRecommend;
@property (nonatomic, strong) NSMutableArray* articlesOfShare; 
 
@end

NS_ASSUME_NONNULL_END
