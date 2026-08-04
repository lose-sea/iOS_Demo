//
//  Model.h
//  网络请求
//
//  Created by lose_sea on 2026/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherLocation : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* localtime;
@end

@interface WeatherCurrent :  NSObject
@property (nonatomic, assign) double temp_c;
@end

@interface Model : NSObject
@property (nonatomic, strong) WeatherLocation* location;
@property (nonatomic, strong) WeatherCurrent* current;
@end

NS_ASSUME_NONNULL_END
