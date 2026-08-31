//
//  MyWCDB+WCTTableCoding.h
//  WCDB_test
//
//  Created by lose_sea on 2026/8/31.
//

#import "MyWCDB.h"
#import <WCDB/WCDB.h>

@interface MyWCDB (WCTTableCoding) <WCTTableCoding>

/*
WCDB_PROPERTY(<#property1#>)
WCDB_PROPERTY(<#property2#>)
WCDB_PROPERTY(<#property3#>)
WCDB_PROPERTY(<#property4#>)
WCDB_PROPERTY(<#.........#>)
 */

// 用 WCDB_PROPERTY 宏声明需要绑定到数据库的字段
WCDB_PROPERTY(userId)
WCDB_PROPERTY(name)
WCDB_PROPERTY(age)
WCDB_PROPERTY(email)

@end
