//
//  AViewController.m
//  XROCSupport_Example
//
//  Created by ext.wangxiaoran3 on 2023/2/1.
//  Copyright © 2023 ext.wangxiaoran3. All rights reserved.
//

#import "AViewController.h"
#import "RACVC.h"
//#import "XRHookTool2.h"
#import "XRHookTool.h"
typedef void(^block)(NSString *str);

@interface AViewController ()
@property(nonatomic,strong)UIView *bgView;

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [NSBundle xr_navBackImage];


    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 150, 150)];
    imv.image = image;
    imv.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:imv];
    
    
    
    [self.view addSubview:self.bgView];
    

  
    
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self.navigationController pushViewController:[RACVC new] animated:YES];
    
    
    method_exchangeImplementations(class_getInstanceMethod(self.class, @selector(ttt)), class_getInstanceMethod(self.class, @selector(yyy)));
    
    
    [self ttt];
    
}


-(void)ttt{
    
    NSLog(@"ttt");
}
-(void)yyy{
    NSLog(@"yyy");
}







@end
