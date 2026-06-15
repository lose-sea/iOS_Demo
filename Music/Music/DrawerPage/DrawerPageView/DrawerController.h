//
//  DrawerController.h
//  Music
//
//  Created by lose_sea on 2026/6/14.
//

#import <UIKit/UIKit.h>
#import "DrawerModel.h"
#import "DrawerView.h"

#import "ViewController.h"
#import "HomeController.h"
#import "SearchController.h"
#import "NoteController.h"
#import "MyController.h"
#import "MenuViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawerController : UIViewController

@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIView* maskView;

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                       menuViewController:(UIViewController *)menuViewController;

- (void)openMenu;
- (void)closeMenu;
- (void)switchOpen; 
@end

NS_ASSUME_NONNULL_END
