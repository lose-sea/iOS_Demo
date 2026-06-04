//
//  UserModel.h
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UserModel : NSObject
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSString* massage;
@property (nonatomic, strong) NSString* signature;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, strong) NSString* email; 

@property (nonatomic, assign) NSInteger saveCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger viewCount;


+ (instancetype) shareInstance; 
@end


