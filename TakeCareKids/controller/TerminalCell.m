//
//  RegardViewCell.m
//  WakeMeUp
//
//  Created by 黄 晶 on 13-6-3.
//  Copyright (c) 2013年 黄 晶. All rights reserved.
//

#import "TerminalCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TerminalCell

@synthesize userIconBackView = _userIconBackView,userIcon = _userIcon;
@synthesize lblName = _lblName, lblId = _lblId, lblNum = _lblNum;

- (void)dealloc
{
    [_userIcon release];
    [_lblName release];
    [_lblId release];
    [_lblNum release];
    [_userIconBackView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userIconBackView = [[UIImageView alloc] init];
        self.userIconBackView.frame = CGRectMake(16, 10, 38, 38);
        self.userIconBackView.backgroundColor = [UIColor clearColor];
        self.userIconBackView.image = [UIImage imageNamed:@"avatar_frame.png"];
        [self addSubview:self.userIconBackView];
        [_userIconBackView release];
        
        self.userIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"avatar_default.png"]];
        self.userIcon.delegate = self;
        self.userIcon.frame = CGRectMake(4, 4, 30, 30);
        self.userIcon.backgroundColor = [UIColor clearColor];
        self.userIcon.layer.cornerRadius = 15;
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.userInteractionEnabled = YES;
        [self.userIconBackView addSubview:self.userIcon];
        [_userIcon release];
        
        self.lblId = [[UILabel alloc] init];
        self.lblId.frame = CGRectMake(62, 12, 48, 18);
        self.lblId.backgroundColor = [UIColor clearColor];
        self.lblId.textAlignment = UITextAlignmentLeft;
        self.lblId.font = [UIFont fontWithName:FONT_M size:12.0f];
        self.lblId.textColor = [UIColor colorWithRed:166/255.0f green:166/255.0f blue:166/255.0f alpha:1];
        self.lblId.text = @"";
        [self addSubview:self.lblId];
        
        self.lblName = [[UILabel alloc] init];
        self.lblName.frame = CGRectMake(110, 12, 100, 18);
        self.lblName.backgroundColor = [UIColor clearColor];
        self.lblName.textAlignment = UITextAlignmentLeft;
        self.lblName.font = [UIFont fontWithName:FONT_M size:16.0f];
        self.lblName.textColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:76/255.0f alpha:1];
        self.lblName.text = @"<无名>";
        [self addSubview:self.lblName];
        

        self.lblNum = [[UILabel alloc] init];
        self.lblNum.frame = CGRectMake(62, 30, 200, 18);
        self.lblNum.backgroundColor = [UIColor clearColor];
        self.lblNum.textAlignment = UITextAlignmentLeft;
        self.lblNum.font = [UIFont fontWithName:FONT_M size:16.0f];
        self.lblNum.textColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:76/255.0f alpha:1];
        self.lblNum.text = @"";
        [self addSubview:self.lblNum];
        
        [_lblNum release];
        [_lblName release];
        [_lblId release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    
}
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    
}
- (void)TouchesEnded:(NSSet *)touches
{
    
}

@end
