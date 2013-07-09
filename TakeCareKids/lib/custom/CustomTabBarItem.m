//
//  CustomTabBarItem.m
//  INCITYLite
//
//  Created by Jeffrey Ma on 8/31/12.
//
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem

@synthesize customHighlightedImage;
@synthesize customNormalImage;

- (id)initWithTitle:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
                tag:(NSInteger)tag
{

    self = [super initWithTitle:title image:nil tag:tag];
    if(self)
    {
        [self setCustomNormalImage:normalImage];
        [self setCustomHighlightedImage:highlightedImage];
    }
//    [self initWithTitle:title
//                  image:nil
//                    tag:tag];
    return self;
}

- (void) dealloc
{
    RELEASE_SAFELY(customHighlightedImage);
    RELEASE_SAFELY(customNormalImage);
    [super dealloc];
}

-(UIImage *) selectedImage
{
    return self.customHighlightedImage;
}

-(UIImage *) unselectedImage
{
    return self.customNormalImage;
}

@end