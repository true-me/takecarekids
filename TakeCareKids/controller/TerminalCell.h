//
//  RegardViewCell.h
//  WakeMeUp
//
//  Created by 黄 晶 on 13-6-3.
//  Copyright (c) 2013年 黄 晶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"

@interface RegardViewCell : UITableViewCell<EGOImageViewDelegate, EGOImageButtonDelegate> {
    UIImageView *userIconBackView;
    EGOImageView *userIcon;
    UILabel *userNick;
    UILabel *userDesc;
    
    EGOImageButton *relationBtn;
}

@property (nonatomic,strong) UIImageView *userIconBackView;
@property (nonatomic,strong) EGOImageView *userIcon;
@property (nonatomic,strong) UILabel *userNick;
@property (nonatomic,strong) UILabel *userDesc;
@property (nonatomic,strong) EGOImageButton *relationBtn;
- (void)setRelation:(NSInteger)relType;

@end
