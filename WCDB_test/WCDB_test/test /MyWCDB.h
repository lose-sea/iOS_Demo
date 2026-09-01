//
//  MyWCDB.h
//  WCDB_test
//
//  Created by lose_sea on 2026/9/1.
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

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSArray* array; 

@end
