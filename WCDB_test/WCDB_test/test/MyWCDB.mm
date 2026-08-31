//
//  MyWCDB.mm
//  WCDB_test
//
//  Created by lose_sea on 2026/8/31.
//

#import "MyWCDB+WCTTableCoding.h"
#import "MyWCDB.h"
#import <WCDB/WCDB.h>

@implementation MyWCDB

/*
WCDB_IMPLEMENTATION(MyWCDB)
WCDB_SYNTHESIZE(<#property1#>)
WCDB_SYNTHESIZE(<#property2#>)
WCDB_SYNTHESIZE(<#property3#>)
WCDB_SYNTHESIZE(<#property4#>)
WCDB_SYNTHESIZE_COLUMN(<#property5#>, "<#column name#>")   // Custom column name

WCDB_PRIMARY_AUTO_INCREMENT(<#property#>)

WCDB_INDEX(<#_index_subfix#>, <#property#>)
 */

// 必须的宏，用于绑定类名
WCDB_IMPLEMENTATION(MyWCDB)


// 将属性绑定到数据库表的字段
WCDB_SYNTHESIZE(userId)
WCDB_SYNTHESIZE(name)
WCDB_SYNTHESIZE(age)
WCDB_SYNTHESIZE(email)

// 将 userId 设置为自增主键
WCDB_PRIMARY_AUTO_INCREMENT(userId)

// 可选：添加索引以提升查询性能
WCDB_INDEX("_index_name", name)

// 可选：设置非空约束
WCDB_NOT_NULL(name)
WCDB_NOT_NULL(email)




@end
