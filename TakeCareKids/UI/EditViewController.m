//
//  Created by Matt Greenfield on 24/05/12
//  Copyright (c) 2012 Big Paua. All rights reserved
//  http://bigpaua.com/
//

#import "EditViewController.h"
#import "MGScrollView.h"
#import "MGStyledBox.h"
#import "MGBoxLine.h"

#define ANIM_SPEED 0.6

@implementation EditViewController {
    MGScrollView *scroller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
    [self setUpTitleView:@"亲情号码"];
    [self initNavBarButton];
    
    // sue me, Gruber!
    self.view.backgroundColor =
    [UIColor colorWithRed:0.82 green:0.82 blue:0.85 alpha:1];
    
//    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    
    // make an MGScrollView for holding boxes
    CGRect frame = CGRectMake(0, 0, 320, 460 - 44 - 49);
    scroller = [[MGScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scroller];
    scroller.alwaysBounceVertical = YES;
    scroller.delegate = self;
    
    // add a moveable box
    //[self addBox:nil];
    
    //
    //    // add a new MGBox to the MGScrollView
    //    MGStyledBox *box1 = [MGStyledBox box];
    //    [scroller.boxes addObject:box1];
    //
    //    // add some MGBoxLines to the box
    //    MGBoxLine *head1 =
    //            [MGBoxLine lineWithLeft:@"Left And Right Content" right:nil];
    //    head1.font = headerFont;
    //    [box1.topLines addObject:head1];
    //
    //    UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectZero];
    //    toggle.on = YES;
    //    MGBoxLine *line1 =
    //            [MGBoxLine lineWithLeft:@"NSString and UISwitch" right:toggle];
    //    [box1.topLines addObject:line1];
    //
    //    MGStyledBox *box2 = [MGStyledBox box];
    //    [scroller.boxes addObject:box2];
    //
    //    MGBoxLine *head2 = [MGBoxLine lineWithLeft:@"Multiline Content" right:nil];
    //    head2.font = headerFont;
    //    [box2.topLines addObject:head2];
    //
    //    NSString *blah = @"Multiline content is automatically sized and formatted "
    //            "given an NSString, UIFont, and desired padding.";
    //    MGBoxLine *multi = [MGBoxLine multilineWithText:blah font:nil padding:24];
    //    [box2.topLines addObject:multi];
    //
    //    MGStyledBox *box3 = [MGStyledBox box];
    //    [scroller.boxes addObject:box3];
    //
    //    MGBoxLine *head3 =
    //            [MGBoxLine lineWithLeft:@"NSStrings, UIImages, and UIViews"
    //                    right:nil];
    //    head3.font = headerFont;
    //    [box3.topLines addObject:head3];
    //
    //    NSString *lineContentWords =
    //            @"Content can be arbitrary arrays of elements.\n\n"
    //                    "UIImages are automatically wrapped in UIImageViews and "
    //                    "NSStrings are automatically wrapped in UILabels.\n\n"
    //                    "Content elements are automatically laid out "
    //                    "according to the line's itemPadding and "
    //                    "linePadding property values.";
    //    MGBoxLine *wordsLine =
    //            [MGBoxLine multilineWithText:lineContentWords font:nil padding:24];
    //    [box3.topLines addObject:wordsLine];
    //
    //    UIImage *img = [UIImage imageNamed:@"home"];
    //    NSArray *imgLineLeft =
    //            [NSArray arrayWithObjects:img, @"An NSString after a UIImage", nil];
    //    MGBoxLine *imgLine = [MGBoxLine lineWithLeft:imgLineLeft right:nil];
    //    [box3.topLines addObject:imgLine];
    
    // draw all the boxes and animate as appropriate
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
    [scroller flashScrollIndicators];
    [scroller release];
}

- (void)addBox:(UIButton *)sender {
    MGStyledBox *box = [MGStyledBox box];
    MGBox *parentBox = [self parentBoxOf:sender];
    if (parentBox) {
        int i = [scroller.boxes indexOfObject:parentBox];
        [scroller.boxes insertObject:box atIndex:i + 1];
    } else {
        [scroller.boxes addObject:box];
    }
    
    //    UIButton *up = [self button:@"上" for:@selector(moveUp:)];
    //    UIButton *down = [self button:@"下" for:@selector(moveDown:)];
//    UIButton *add = [self button:@"添加" for:@selector(addBoxForPerson:)];
//    UIButton *save = [self button:@"保存" for:@selector(saveBox:)];
    //    UIButton *remove = [self button:@"删除" for:@selector(removeBox:)];
    //    UIButton *shuffle = [self button:@"shuffle" for:@selector(shuffle)];
    
    //    NSArray *left = [NSArray arrayWithObjects:up, down, nil];
    NSArray *right = [NSArray arrayWithObjects: nil];
    // NSArray *right = [NSArray arrayWithObjects:shuffle, remove, add, nil];
    
    
    MGBoxLine *line = [MGBoxLine lineWithLeft:nil right:right];
    [box.topLines addObject:line];
    
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
    [scroller flashScrollIndicators];
}

- (void)removeBox:(UIButton *)sender {
    MGBox *parentBox = [self parentBoxOf:sender];
    [scroller.boxes removeObject:parentBox];
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
}

- (void)moveUp:(UIButton *)sender {
    MGBox *parentBox = [self parentBoxOf:sender];
    int i = [scroller.boxes indexOfObject:parentBox];
    if (!i) {
        return;
    }
    [scroller.boxes removeObject:parentBox];
    [scroller.boxes insertObject:parentBox atIndex:i - 1];
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
}

- (void)moveDown:(UIButton *)sender {
    MGBox *parentBox = [self parentBoxOf:sender];
    int i = [scroller.boxes indexOfObject:parentBox];
    if (i == [scroller.boxes count] - 1) {
        return;
    }
    [scroller.boxes removeObject:parentBox];
    [scroller.boxes insertObject:parentBox atIndex:i + 1];
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
}

- (MGBox *)parentBoxOf:(UIView *)view {
    while (![view.superview isKindOfClass:[MGBox class]])
    {
        if (!view.superview) {
            return nil;
        }
        view = view.superview;
    }
    return (MGBox *)view.superview;
}

- (UIButton *)button:(NSString *)title for:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [button setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9]
                 forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.2 alpha:0.9]
                       forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    CGSize size = [title sizeWithFont:button.titleLabel.font];
    button.frame = CGRectMake(0, 0, size.width + 18, 26);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:selector
     forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 3;
    button.backgroundColor = self.view.backgroundColor;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 1);
    button.layer.shadowRadius = 0.8;
    button.layer.shadowOpacity = 0.6;
    return button;
}

- (void)shuffle {
    NSMutableArray *shuffled =
    [NSMutableArray arrayWithCapacity:[scroller.boxes count]];
    for (id box in scroller.boxes) {
        int i = arc4random() % ([shuffled count] + 1);
        [shuffled insertObject:box atIndex:i];
    }
    scroller.boxes = shuffled;
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
}

#pragma mark - UIScrollViewDelegate (for snapping boxes to edges)

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [(MGScrollView *)scrollView snapToNearestBox];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [(MGScrollView *)scrollView snapToNearestBox];
    }
}

#pragma mark - Editable list methods
- (void)addBoxForPerson:(UIButton *)sender {
    MGStyledBox *box = [MGStyledBox box];
    if (scroller.boxes.count > 0)
    {
//        MGBox *firstBox = [scroller.boxes objectAtIndex:0];
        [scroller.boxes insertObject:box atIndex:0];
    }
    else
    {
        [scroller.boxes addObject:box];
    }
//    MGBox *parentBox = [self parentBoxOf:sender];
//    if (parentBox) {
//        int i = [scroller.boxes indexOfObject:parentBox];
//        [scroller.boxes insertObject:box atIndex:i + 1];
//    } else {
//        [scroller.boxes addObject:box];
//    }
    
    UIFont *headerFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    
    CGRect f = CGRectMake(10, 10, 200, 30);
	UITextField *textField1 = [[[UITextField alloc] initWithFrame:f] autorelease];
    textField1.placeholder = @"家人姓名";
    //	[textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[textField1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField1 setAutocorrectionType:UITextAutocorrectionTypeNo];

    [textField1 setDelegate:self];
    [textField1 setTag:1];
    [textField1 setReturnKeyType:UIReturnKeyDone];
//    [textField1 setClearsOnBeginEditing:YES];//UITextField 的是否出现一件清除按钮
    [textField1 setBorderStyle:UITextBorderStyleLine];//UITextField 的边框
    //[textField1 setBackground:[UIImage imageNamed:@"my.png"]];//UITextField 的背景，注意只有UITextBorderStyleNone的时候改属性有效
    [textField1 setClearButtonMode:UITextFieldViewModeWhileEditing];//UITextField 的一件清除按钮是否出现
    [textField1 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    [textField1 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventTouchUpInside];
//    [textField1 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventTouchUpOutside];
//    [textField1 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventValueChanged];
//    [textField1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    MGBoxLine *head2 = [MGBoxLine lineWithLeft:textField1 right:nil];
    head2.font = headerFont;
    [box.topLines addObject:head2];
//    [textField1 release];
    NSLog(@"%d", [textField1 retainCount]);
    
	UITextField *textField2 = [[[UITextField alloc] initWithFrame:f] autorelease];
    textField2.placeholder = @"手机号码";
    //	[textField setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[textField2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField2 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField2 setDelegate:self];
    [textField2 setTag:2];
    [textField2 setReturnKeyType:UIReturnKeyDone];
//    [textField2 setClearsOnBeginEditing:YES];//UITextField 的是否出现一件清除按钮
    [textField2 setBorderStyle:UITextBorderStyleLine];//UITextField 的边框
    //[textField1 setBackground:[UIImage imageNamed:@"my.png"]];//UITextField 的背景，注意只有UITextBorderStyleNone的时候改属性有效
    [textField2 setClearButtonMode:UITextFieldViewModeWhileEditing];//UITextField 的一件清除按钮是否出现
    [textField2 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    [textField2 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventTouchUpInside];
//    [textField2 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventTouchUpOutside];
//    [textField2 addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventValueChanged];
//    [textField2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    MGBoxLine *head3 = [MGBoxLine lineWithLeft:textField2 right:nil];
    head3.font = headerFont;
    [box.topLines addObject:head3];
//    [textField2 release];
    
    //    NSString *blah = @"15829670000";
    //    MGBoxLine *multi = [MGBoxLine multilineWithText:blah font:nil padding:24];
    //    [box.topLines addObject:multi];
    
    
    UIButton *up = [self button:@"上" for:@selector(moveUp:)];
    UIButton *down = [self button:@"下" for:@selector(moveDown:)];
    //    UIButton *add = [self button:@"添加" for:@selector(addBox:)];
    UIButton *remove = [self button:@"删除" for:@selector(removeBox:)];
    //    UIButton *shuffle = [self button:@"shuffle" for:@selector(shuffle)];
    
    NSArray *left = [NSArray arrayWithObjects:up, down, nil];
    NSArray *right = [NSArray arrayWithObjects:remove, nil];
    // NSArray *right = [NSArray arrayWithObjects:shuffle, remove, add, nil];
    
    
    MGBoxLine *line = [MGBoxLine lineWithLeft:left right:right];
    [box.topLines addObject:line];
    
    [scroller drawBoxesWithSpeed:ANIM_SPEED];
    [scroller flashScrollIndicators];
}

- (void)saveBox:(UIButton *)sender
{

    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"保存成功";
    [HUD showAnimated:YES whileExecutingBlock:^{
        for (MGStyledBox *boxOne in scroller.boxes)
        {
            for (id objOne in boxOne.topLines)
            {
                if ([objOne isKindOfClass:[MGBoxLine class]])
                {
                    MGBoxLine *blOne = (MGBoxLine *) objOne;
                    for (id cntOne in blOne.contentsLeft)
                    {
                        if ([cntOne isKindOfClass:[UITextField class]])
                        {
                            UITextField *tfOne = (UITextField *)cntOne;
                            NSLog(@"%@", tfOne.text);
                        }
                    }
                }
            }
        };
        sleep(1.5f);
    } completionBlock:^{
        [HUD removeFromSuperview];
        [HUD release];
        HUD = nil;
    }];
}




// UITextFieldDelegate代理类方法，限制输入内容长度;
-(void)textFieldFinished:(id)sender
{
    UITextField *txtfield = (UITextField *)sender;
    NSLog(@"textFieldFinished=%@",  txtfield.text);
    [sender resignFirstResponder];
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing=%@",  textField.text);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing=%@",  textField.text);   
}

- (void) textFieldDidChange:(id)sender
{
    UITextField *txtField = (UITextField *)sender;
    NSLog(@"textFieldDidChange=%@", txtField.text);
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"shouldChangeCharactersInRange=%@, %@",  textField.text, string);
//    if (textField.tag == 1 && range.location >= 20)
//    {
//        return NO;
//    }else if(textField.tag == 2 && range.location >= 5)
//    {
//        return NO;
//    }else if ((textField.tag == 3 || textField.tag == 4) && range.location >= 12){
//        return NO;
//    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) initNavBarButton
{
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 68.0f, 30.0f)];
    [leftLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.shadowColor = [UIColor colorWithRed:0.0f
                                            green:0.0f
                                             blue:0.0f
                                            alpha:0.4f];
    leftLabel.shadowOffset = CGSizeMake(0.0f, 0.9f);
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.text = @"添加";
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:leftLabel.frame];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right.png"] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right-hl.png"] forState:UIControlStateHighlighted];
    //    [leftButton addTarget:self action:@selector(setupLockRect:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(addBoxForPerson:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:leftLabel];
    [self setUpLeftButton: leftButton];
    [leftButton release];
    
    
    UILabel * sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 30.0f)];
    [sendLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:13.0f]];
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.shadowColor = [UIColor colorWithRed:0.0f
                                            green:0.0f
                                             blue:0.0f
                                            alpha:0.4f];
    sendLabel.shadowOffset = CGSizeMake(0.0f, 0.9f);
    sendLabel.backgroundColor = [UIColor clearColor];
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.text = @"保存";
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:sendLabel.frame];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right.png"] forState:UIControlStateNormal];
    //    [rightButton setImage:[UIImage imageNamed:@"navbar-right-hl.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(saveBox:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addSubview:sendLabel];
    [self setUpRightButton: rightButton];
    [rightButton release];

}

@end
