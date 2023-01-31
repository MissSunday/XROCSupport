//
//  XRViewController.m
//  XROCSupport
//
//  Created by ext.wangxiaoran3 on 11/24/2022.
//  Copyright (c) 2022 ext.wangxiaoran3. All rights reserved.
//

#import "XRViewController.h"
#import "XROCSupport.h"
@interface XRViewController ()

@end

@implementation XRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    XR_Scale(12);
    CGFloat a = kNavHeight;
    NSLog(@"--%f",a);
    
    UIFont *f = [UIFont ScaleFontOfSize:12];
    NSLog(@"%@",f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
