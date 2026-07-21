//
//  NetworkManager.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/21.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    static NetworkManager* instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self; 
}


@end
