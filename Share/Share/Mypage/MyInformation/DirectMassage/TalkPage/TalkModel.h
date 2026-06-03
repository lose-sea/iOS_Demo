//
//  TalkModel.h
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TalkModel : NSObject
@property (nonatomic, strong) NSMutableArray* messagesOfMe;
@property (nonatomic, strong) NSMutableArray* messageOfOther; 
@end

NS_ASSUME_NONNULL_END
