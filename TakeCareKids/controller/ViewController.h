//
//  ViewController.h
//  BaiduMapDemo01
//
//  Created by JINGANG on 12-11-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface ViewController : UIViewController<BMKGeneralDelegate>
{
        BMKMapManager *_mapManager;     
}

@end
