//
//  NetworkManager.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
// 参数1: 请求地址
// 参数2: 查询参数, 键值对字典, 会自动拼接到url后
// 参数3: 长Block回调
    // 没有返回值
    // 本身可以传 nil
    // 参数1: 返回的 JSON 回调  请求失败 json = nil
    // 参数2: 请求错误对象      请求成功 error = nil
    //
- (void) GET: (NSString*) urlString

  parameters: (NSDictionary* _Nullable) parameters
  completion: (void (^ _Nullable)(NSDictionary* _Nullable json, NSError* _Nullable error)) complete;

// 请求所有

// 取消特定 URL 请求
- (void) cacelRequestForURL: (NSString*) urlString;
@end

NS_ASSUME_NONNULL_END
