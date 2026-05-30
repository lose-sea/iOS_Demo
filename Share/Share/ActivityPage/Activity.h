//
//  Activitiy.h
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import <UIKit/UIKit.h>


@interface Activity : NSObject
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) NSString* massage;
@property (nonatomic, assign) BOOL isEnd; 

- (instancetype) initWithImage: (UIImage*) image massage: (NSString*) massage; 
@end

