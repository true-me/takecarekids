//
//  CustomTabBarItem.h
//  INCITYLite
//
//  Created by Jeffrey Ma on 8/31/12.
//
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UITabBarItem {
    UIImage *customHighlightedImage;
    UIImage *customNormalImage;
}

@property (nonatomic, retain) UIImage *customHighlightedImage;
@property (nonatomic, retain) UIImage *customNormalImage;

- (id)initWithTitle:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
                tag:(NSInteger)tag;
@end
