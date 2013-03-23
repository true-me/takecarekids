//
//  DesireCell.h
//  SmartCommunity
//
//  Created by Jeffrey Ma on 3/10/13.
//
//

#import <UIKit/UIKit.h>
#import "LPBaseCell.h"
#import "Group.h"
#import "JSTwitterCoreTextView.h"
#import "ListItem.h"
#import "POHorizontalList.h"

#define IMAGE_VIEW_HEIGHT 80.0f
#define PADDING_TOP 12.0
#define PADDING_LEFT 12.0
#define FONT_SIZE 13.0
#define FONT @"STHeitiSC-Light"

@class DesireCell;

@protocol DesireCellDelegate <NSObject>

-(void)cellImageDidTaped:(DesireCell *)theCell image:(UIImage*)image;
-(void)cellLinkDidTaped:(DesireCell *)theCell link:(NSString*)link;
-(void)cellTextDidTaped:(DesireCell *)theCell;

@end

@interface DesireCell : LPBaseCell <JSCoreTextViewDelegate>
{
    id<DesireCellDelegate> delegate;
    
    UIImageView *avatarImage;
    JSTwitterCoreTextView *_JSContentTF;
    UITextView *contentTF;
    UILabel *userNameLB;
    UIImageView *bgImage;
    UIImageView *contentImage;
    UIView *retwitterMainV;
    UIImageView *retwitterBgImage;
    UITextView *retwitterContentTF;
    JSTwitterCoreTextView *_JSRetitterContentTF;
    UIImageView *retwitterContentImage;
    NSIndexPath *cellIndexPath;
    
    UIImageView *desireBgImage;
}
@property (retain, nonatomic) IBOutlet UILabel *countLB;
@property (retain, nonatomic) IBOutlet UIImageView *avatarImage;
@property (retain, nonatomic) IBOutlet UITextView *contentTF;
@property (retain, nonatomic) IBOutlet UILabel *userNameLB;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *contentImage;
@property (retain, nonatomic) IBOutlet UIView *retwitterMainV;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterBgImage;
@property (retain, nonatomic) IBOutlet UITextView *retwitterContentTF;
@property (retain, nonatomic) IBOutlet UIImageView *retwitterContentImage;
@property (assign, nonatomic) id<DesireCellDelegate> delegate;
@property (retain, nonatomic) NSIndexPath *cellIndexPath;
@property (retain, nonatomic) IBOutlet UILabel *fromLB;
@property (retain, nonatomic) IBOutlet UILabel *timeLB;
@property (retain, nonatomic) IBOutlet UIImageView *vipImageView;
@property (retain, nonatomic) IBOutlet UIImageView *commentCountImageView;
@property (retain, nonatomic) IBOutlet UIImageView *retweetCountImageView;
@property (retain, nonatomic) IBOutlet UIImageView *haveImageFlagImageView;

@property (retain, nonatomic) IBOutlet UIImageView *desireBgImage;

@property (nonatomic,retain)JSTwitterCoreTextView *JSContentTF;
@property (nonatomic,retain)JSTwitterCoreTextView *JSRetitterContentTF;

-(CGFloat)setTFHeightWithImage:(BOOL)hasImage haveRetwitterImage:(BOOL)haveRetwitterImage;
-(void)updateCellTextWith:(Group *) group WithTableViewDelegate:(id) theDelegate;
+(CGFloat)getJSHeight:(NSString*)text jsViewWith:(CGFloat)with;
@end
