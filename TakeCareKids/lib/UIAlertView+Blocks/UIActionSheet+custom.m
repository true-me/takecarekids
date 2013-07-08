//
//  UIActionSheet+custom.m
//  WakeMeUp
//
//  Created by Jeffrey Ma on 6/27/13.
//  Copyright (c) 2013 黄 晶. All rights reserved.
//

#import "UIActionSheet+custom.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";
@implementation UIActionSheet (custom)
-(id)initWithcancelButtonItem:(RIButtonItem *)inCancelButtonItem destructiveButtonItem:(RIButtonItem *)inDestructiveItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    if((self = [self initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, RIButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for(RIButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:item.label];
        }
        
        if(inDestructiveItem)
        {
            [buttonsArray addObject:inDestructiveItem];
            NSInteger destIndex = [self addButtonWithTitle:inDestructiveItem.label];
            [self setDestructiveButtonIndex:destIndex];
        }
        if(inCancelButtonItem)
        {
            [buttonsArray addObject:inCancelButtonItem];
            NSInteger cancelIndex = [self addButtonWithTitle:inCancelButtonItem.label];
            [self setCancelButtonIndex:cancelIndex];
        }
        
        objc_setAssociatedObject(self, CFBridgingRetain(RI_BUTTON_ASS_KEY), buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        //        [self retain]; // keep yourself around!
    }
    return self;
}

- (NSInteger)addButtonItem:(RIButtonItem *)item
{
    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, CFBridgingRetain(RI_BUTTON_ASS_KEY));
	
	NSInteger buttonIndex = [self addButtonWithTitle:item.label];
	[buttonsArray addObject:item];
	
	return buttonIndex;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != -1)
    {
        NSArray *buttonsArray = objc_getAssociatedObject(self, (CFBridgingRetain(RI_BUTTON_ASS_KEY)));
        RIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if(item.action)
            item.action();
        objc_setAssociatedObject(self, CFBridgingRetain(RI_BUTTON_ASS_KEY), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // [self release]; // and release yourself!
}

@end
