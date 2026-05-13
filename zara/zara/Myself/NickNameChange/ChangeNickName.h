//
//  ChangeNickName.h
//  zara
//
//  Created by lose_sea on 2026/5/12.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 

NS_ASSUME_NONNULL_BEGIN


@protocol ChangeNickName <NSObject>

- (void) vcChangeNickName: (id) vcChangeNickName didSendText: (NSString*) nickName;

@end

@interface ChangeNickName : UIViewController
@property (nonatomic, strong) NSString* nickname; 
@property (nonatomic, strong) UITextField* textField;

@property (nonatomic, weak) id <ChangeNickName> delegate;
@end

NS_ASSUME_NONNULL_END
