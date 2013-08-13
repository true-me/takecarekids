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

@interface RouteLineCell : UITableViewCell<EGOImageViewDelegate, EGOImageButtonDelegate>
{

}

@property (nonatomic,strong) UIImageView *userIconBackView;
@property (nonatomic,strong) EGOImageView *userIcon;
@property (nonatomic,strong) UILabel *lblId;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblNum;

@end
