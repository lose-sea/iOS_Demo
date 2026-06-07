//
//  LoginModel.m
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import "LoginModel.h"

@interface LoginModel ()

@end

@implementation LoginModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.autoLogin = NO;
        self.user = [[UserModel alloc] init]; 
    }
    return self; 
}

@end
