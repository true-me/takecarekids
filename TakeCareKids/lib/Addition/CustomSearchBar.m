//
//  CustomSearchBar.m
//  INCITYLite
//
//  Created by Jeffrey Ma on 9/24/12.
//
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code

    }
    return self;
}

- (void)layoutSubviews
{
    self.backgroundColor = [UIColor clearColor];
    
	UITextField *searchField = nil;
	UIImageView *bgView = nil;
  	UISegmentedControl *segView = nil;
	for (UIView *subview in self.subviews)
    {
        NSString *viewName = [NSString stringWithUTF8String:object_getClassName(subview)];
        DLog(@"subview=%@", viewName);
        if([viewName isEqualToString:@"UISearchBarTextField"])
        {
			searchField = (UITextField *)subview;
//            searchField.textColor = [UIColor whiteColor];
//            [searchField setBackground: [UIImage imageNamed:@"search_text_bg.png"] ];
//            [searchField setBackgroundColor:[UIColor clearColor]];
//            //[searchField setBorderStyle:UITextBorderStyleRoundedRect];
//            [searchField setBorderStyle:UITextBorderStyleNone];
//            UIImage *image = [UIImage imageNamed: @"search_zoom_white.png"];
//            UIImageView *iView = [[UIImageView alloc] initWithImage:image];
//            searchField.leftView = iView;
//            [iView release];
		}
        if([viewName isEqualToString:@"UISearchBarBackground"])
        {
            //
            [subview removeFromSuperview];
        }
        
        if([viewName isEqualToString:@"UISegmentedControl"])
        {
            //segView = (UISegmentedControl *)subview;
            [subview setHidden:YES];
        }
        
        if([viewName isEqualToString:@"UINavigationButton"])          
        {            
            UIButton *btn = (UIButton *)subview;            
            [btn setTitle:@"取消" forState:UIControlStateNormal];            
        }
        
        if([viewName isEqualToString:@"UIImageView"])
        {
            bgView = (UIImageView *)subview;
        }
	}

    if (!segView)
    {

    }
    
    if(searchField != nil)
    {
        searchField.placeholder = @"搜索";
        [searchField setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14]];
        searchField.textColor = [UIColor whiteColor];
        if ( searchField.isFirstResponder)
        {
            [searchField setBackground: [UIImage imageNamed:@"search_text_bg.png"]];
        } else
        {
            [searchField setBackground: [UIImage imageNamed:@"search_text_bg.png"] ];
        }
        
        UIImage *imgMagnifier = [UIImage imageNamed:@"search_zoom_white.png"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:imgMagnifier];
        searchField.leftView = imageView;
        [imageView release];
        
//        if(!self.isLeftViewChanged){
//            UIImage *imgMagnifier = [UIImage imageNamed:@"search_zoom_white.png"];
//            UIImageView *imageView = [[UIImageView alloc]initWithImage:imgMagnifier];
//            searchField.leftView = imageView;
//            
//            [imageView release];
//            self.isLeftViewChanged = TRUE;
//        }
	}
    
    
    if (!bgView)
    {
        bgView = [[UIImageView alloc] initWithFrame:self.frame];
        bgView.contentMode = UIViewContentModeScaleToFill;
        [bgView setImage:[UIImage imageNamed:@"search_bg.png"]];
        [self insertSubview:bgView atIndex:0];
        [bgView release];
    }

	[super layoutSubviews];
}
//4输入搜索文字时隐藏搜索按钮，清空时显示

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];    
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{    
    searchBar.showsScopeBar = NO;    
    [searchBar sizeToFit];    
    [searchBar setShowsCancelButton:NO animated:YES];    
    return YES;    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
