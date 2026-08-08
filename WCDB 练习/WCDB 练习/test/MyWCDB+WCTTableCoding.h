//
//  MyWCDB+WCTTableCoding.h
//  WCDB 练习
//
//  Created by lose_sea on 2026/8/8.
//

#import "MyWCDB.h"
#import <WCDB/WCDB.h>

@interface MyWCDB (WCTTableCoding) <WCTTableCoding>


// 声明ORM属性
WCDB_PROPERTY(text)
WCDB_PROPERTY(array)
WCDB_PROPERTY(myId)


@end
