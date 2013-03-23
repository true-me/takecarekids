//
//  loginDelegate.h
//  DuoTin
//
//  Created by Tom  on 12/11/12.
//  Copyright (c) 2012 LionTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol loginDelegate <NSObject>
@optional
-(void)LoginRecieved;
-(void)LoginCompleted;
@end
