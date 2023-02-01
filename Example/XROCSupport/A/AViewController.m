//
//  AViewController.m
//  XROCSupport_Example
//
//  Created by ext.wangxiaoran3 on 2023/2/1.
//  Copyright © 2023 ext.wangxiaoran3. All rights reserved.
//

#import "AViewController.h"
#import "RACVC.h"
@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [NSBundle xr_navBackImage];



    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 150, 150)];
    imv.image = image;
    imv.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imv];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController pushViewController:[RACVC new] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
