//
//  Information.h
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Information : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSInteger count;


- (instancetype) initWithName: (NSString*) name count: (NSInteger) count;
@end

NS_ASSUME_NONNULL_END
