//
//  DrawViewController.h
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DrawViewController : UIViewController
@property (nonatomic, strong) UIViewController* mainViewControlelr;
@property (nonatomic, strong) UIViewController* menuViewContorller;

@property (nonatomic, assign) BOOL drawerOpen;

-(instancetype) initWithMainViewControlelr: (UIViewController*) main menuViewController: (UIViewController*) menuViewController;


- (void) openDrawer;
- (void) closeDrawer;
- (void) toggleDrawer;
@end

NS_ASSUME_NONNULL_END




