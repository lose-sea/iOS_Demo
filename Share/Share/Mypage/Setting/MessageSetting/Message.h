//
//  Message.h
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BOOL isSelected;

- (instancetype) initWithName: (NSString*) name;
@end

NS_ASSUME_NONNULL_END
