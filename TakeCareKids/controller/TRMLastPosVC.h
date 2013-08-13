//
//  MapDemoVC.h
//  TakeCareKids
//
//  Created by Jeffrey Ma on 7/19/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface MapDemoVC : UIViewController<BMKMapViewDelegate>
@property (nonatomic, retain) IBOutlet BMKMapView* mpView;

@end
