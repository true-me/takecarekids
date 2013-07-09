//
//  RegardViewCell.m
//  WakeMeUp
//
//  Created by 黄 晶 on 13-6-3.
//  Copyright (c) 2013年 黄 晶. All rights reserved.
//

#import "RegardViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RegardViewCell

@synthesize userIconBackView,userIcon,userNick,userDesc,relationBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        userIconBackView = [[UIImageView alloc] init];
        userIconBackView.frame = CGRectMake(16, 10, 38, 38);
        userIconBackView.backgroundColor = [UIColor clearColor];
        userIconBackView.image = [UIImage imageNamed:@"avatar_frame.png"];
        [self addSubview:userIconBackView];
        
        userIcon = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"avatar_default.png"]];
        userIcon.delegate = self;
        userIcon.frame = CGRectMake(4, 4, 30, 30);
        userIcon.backgroundColor = [UIColor clearColor];
//        userIcon.image = [UIImage imageNamed:@"avatar_default.png"];
        userIcon.layer.cornerRadius = 15;
        userIcon.layer.masksToBounds = YES;
        userIcon.userInteractionEnabled = YES;
        [userIconBackView addSubview:userIcon];
        
        userNick = [[UILabel alloc] init];
        userNick.frame = CGRectMake(62, 12, 200, 18);
        userNick.backgroundColor = [UIColor clearColor];
        userNick.textAlignment = UITextAlignmentLeft;
        userNick.font = [UIFont fontWithName:FONT_M size:16.0f];
        userNick.textColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:76/255.0f alpha:1];
        userNick.text = @"<无名>";
        [self addSubview:userNick];
        
        userDesc = [[UILabel alloc] init];
        userDesc.frame = CGRectMake(62, 30, 200, 18);
        userDesc.backgroundColor = [UIColor clearColor];
        userDesc.textAlignment = UITextAlignmentLeft;
        userDesc.font = [UIFont fontWithName:FONT_M size:12.0f];
        userDesc.textColor = [UIColor colorWithRed:166/255.0f green:166/255.0f blue:166/255.0f alpha:1];
        userDesc.text = @"暂无描述";
        [self addSubview:userDesc];
        

        
        relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        relationBtn.frame = CGRectMake(272, 18, 12, 18);
        relationBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        relationBtn.backgroundColor = [UIColor clearColor];
//        [relationBtn setBackgroundImage:[[UIImage imageNamed:@"btn_home_arrow_r_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10] forState:UIControlStateNormal];
//        [relationBtn setBackgroundImage:[[UIImage imageNamed:@"btn_home_arrow_r_normal_pressed.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10] forState:UIControlStateHighlighted];
        [relationBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_arrow_r_normal.png"]  forState:UIControlStateNormal];
        [relationBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_arrow_r_normal_pressed.png"]  forState:UIControlStateHighlighted];

        //relationBtn.titleLabel.layer.borderWidth = 1.0f;
        [relationBtn.titleLabel setFont:[UIFont fontWithName:FONT_M size:24]];
        [relationBtn.titleLabel sizeToFit];
        relationBtn.contentEdgeInsets = UIEdgeInsetsMake(
                                                7.0, 0.0, 0.0, 0);
//        [relationBtn setTitle:@"+" forState:UIControlStateNormal];
//        [relationBtn setTitle:@"+" forState:UIControlStateHighlighted];
        [self addSubview:relationBtn];
//        [relationBtn setHidden:YES];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)setRelation:(NSInteger)relType
{
    UIImage *bgImg = nil;
    UIImage *bgImgPressed = nil;
//    NSString *title = nil;
    
    [relationBtn.titleLabel setFont:[UIFont fontWithName:FONT_M size:24]];
    [relationBtn.titleLabel sizeToFit];
    relationBtn.contentEdgeInsets = UIEdgeInsetsMake(
                                                     7.0, 0.0, 0.0, 0);
    switch (relType)
    {
        case 1:
            // 无关系
            bgImg = [[UIImage imageNamed:@"btn_social_red_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            bgImgPressed =[[UIImage imageNamed:@"btn_social_red_pressed.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            [relationBtn setTitle:@"+" forState:UIControlStateNormal];
            [relationBtn setTitle:@"+" forState:UIControlStateHighlighted];
            break;
        case 2:
            // 我关注的人
            bgImg = [[UIImage imageNamed:@"btn_social_gray_normal"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            bgImgPressed =[[UIImage imageNamed:@"btn_social_gray_pressed.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            [relationBtn setTitle:@">" forState:UIControlStateNormal];
            [relationBtn setTitle:@">" forState:UIControlStateHighlighted];
            break;
        case 3:
            // 关注我的
            bgImg = [[UIImage imageNamed:@"icon_followed.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            bgImgPressed =[[UIImage imageNamed:@"icon_followed.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            [relationBtn setTitle:@"<" forState:UIControlStateNormal];
            [relationBtn setTitle:@"<" forState:UIControlStateHighlighted];
            break;
        case 4:
            // 互相关注
            bgImg = [[UIImage imageNamed:@"icon_followed_both.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            bgImgPressed =[[UIImage imageNamed:@"icon_followed_both.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            break;
        default:
            // 无关系
            bgImg = [[UIImage imageNamed:@"btn_social_red_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            bgImgPressed =[[UIImage imageNamed:@"btn_social_red_pressed.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:10];
            break;
    }
 
    [relationBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    [relationBtn setBackgroundImage:bgImgPressed forState:UIControlStateHighlighted];
}

@end
