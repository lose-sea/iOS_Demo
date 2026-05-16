//
//  Model.h
//  zara
//
//  Created by lose_sea on 2026/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* NickName;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* signature;

@property (nonatomic, strong) NSMutableArray* pictures; 

+ (instancetype) shareinstance; 
@end

NS_ASSUME_NONNULL_END
