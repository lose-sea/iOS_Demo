//
//  UserModel.h
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import <Foundation/Foundation.h>



@interface UserModel : NSObject
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* password;

+ (instancetype) shareInstance; 
@end


