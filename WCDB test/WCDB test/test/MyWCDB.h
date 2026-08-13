//
//  MyWCDB.h
//  WCDB 练习
//
//  Created by lose_sea on 2026/8/8.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>

@interface MyWCDB : NSObject <WCTTableCoding>


@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSArray* array;
@property (nonatomic, assign) NSInteger myId;  //添加主键




/*
 // An ORM type can be any C types or any ObjC classes which conforms to NSCoding or WCTColumnCoding protocol.
 // An ORM property must contains a setter which can be private
@property (nonatomic, retain) NSString *<#property1#>;
@property (nonatomic, assign) NSInteger <#property2#>;
@property (nonatomic, assign) float <#property3#>;
@property (nonatomic, strong) NSArray *<#property4#>;
@property (nonatomic, readonly) NSDate *<#..........#>;
 */

@end
