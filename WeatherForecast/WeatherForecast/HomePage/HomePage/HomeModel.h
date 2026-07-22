//
//  HomeModel.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject
//@property (nonatomic, strong) NSMutableArray* saveCities;
@property (nonatomic, strong) NSMutableArray* dicts;

@property (nonatomic, strong) NSMutableArray* homeCities;

+ (instancetype) shareInstance;
@end

NS_ASSUME_NONNULL_END
