//
//  UIImageView+Spotify.m
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import "UIImageView+Spotify.h"
#import <SDWebImage/SDWebImage.h>

@implementation UIImageView (Spotify)

- (void)sp_setImageWithSource:(NSString *)source placeholder:(NSString *)placeholderName {
    UIImage *placeholder = placeholderName.length > 0 ? [UIImage imageNamed:placeholderName] : nil;

    if ([source hasPrefix:@"http"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:source]
                placeholderImage:placeholder
                         options:SDWebImageRetryFailed];
        return;
    }

    if (source.length > 0) {
        self.image = [UIImage imageNamed:source] ?: placeholder;
        return;
    }

    self.image = placeholder;
}

@end
