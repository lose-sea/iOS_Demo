//
//  MyWCDB+WCTTableCoding.h
//  WCDB_test
//
//  Created by lose_sea on 2026/9/1.
//

#import "MyWCDB.h"
#import <WCDBObjc/WCDBObjc.h>

@interface MyWCDB (WCTTableCoding) <WCTTableCoding>

/*
WCDB_PROPERTY(<#property1#>)
WCDB_PROPERTY(<#property2#>)
WCDB_PROPERTY(<#property3#>)
WCDB_PROPERTY(<#property4#>)
WCDB_PROPERTY(<#.........#>)
 */

WCDB_PROPERTY(userID)
WCDB_PROPERTY(name)
WCDB_PROPERTY(array)



@end
