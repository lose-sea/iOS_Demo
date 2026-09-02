//
//  MyWCDB.mm
//  WCDB_test
//
//  Created by lose_sea on 2026/9/1.
//

#import "MyWCDB+WCTTableCoding.h"
#import "MyWCDB.h"
#import <WCDBObjc/WCDBObjc.h>

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

WCDB_IMPLEMENTATION(MyWCDB)

WCDB_SYNTHESIZE(userID)
WCDB_SYNTHESIZE(name)
WCDB_SYNTHESIZE(array)

//// 自定义列名
//WCDB_SYNTHESIZE_COLUMN(<#property5#>, "<#column name#>")   // Custom column name

// 主键, 每次插入新纪录是自动加一
//WCDB_PRIMARY_AUTO_INCREMENT(userID)

// 数据库索引
// 为指定创建索引, 用于加速查询速度
//WCDB_INDEX(<#_index_subfix#>, <#property#>)

//WCDB_INDEX("id", userID)



@end
