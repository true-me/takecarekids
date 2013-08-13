//
//  WLVC.m
//  TakeCareKids
//
//  Created by Jeffrey Ma on 7/19/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//

#import "WLVC.h"

@interface WLVC ()

@end

@implementation WLVC
@synthesize mpView = _mpView;

- (void)dealloc
{
    if (_mpView) {
        [_mpView release];
        _mpView = nil;
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [_mpView viewWillAppear];
    _mpView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mpView viewWillDisappear];
    _mpView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
