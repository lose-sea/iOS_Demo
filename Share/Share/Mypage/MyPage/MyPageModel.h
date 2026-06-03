//
//  MyPageModel.h
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserModel.h"



@interface MyPageModel : NSObject
@property (nonatomic, strong) UIImage* avatar;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, strong) NSString* massage;
@property (nonatomic, strong) NSString* signature;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) UserModel* user; 


@property (nonatomic, assign) NSInteger saveCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) NSInteger viewCount;
@end


