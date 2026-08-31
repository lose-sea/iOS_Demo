//
//  MyWCDB.h
//  WCDB_test
//
//  Created by lose_sea on 2026/8/31.
//

#import <Foundation/Foundation.h>

@interface MyWCDB : NSObject

/*
 // An ORM type can be any C types or any ObjC classes which conforms to NSCoding or WCTColumnCoding protocol.
 // An ORM property must contains a setter which can be private
 
 
@property (nonatomic, retain) NSString *<#property1#>;
@property (nonatomic, assign) NSInteger <#property2#>;
@property (nonatomic, assign) float <#property3#>;
@property (nonatomic, strong) NSArray *<#property4#>;
@property (nonatomic, readonly) NSDate *<#..........#>;
*/

// 定义一个用户模型, 包含一下属性
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString* email; 
@end
