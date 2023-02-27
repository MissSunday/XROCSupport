//
//  AViewController.m
//  XROCSupport_Example
//
//  Created by ext.wangxiaoran3 on 2023/2/1.
//  Copyright © 2023 ext.wangxiaoran3. All rights reserved.
//

#import "AViewController.h"
#import "RACVC.h"
#import <CoreLocation/CoreLocation.h>
#import <NetworkExtension/NetworkExtension.h>
//#import "XRHookTool2.h"
#import "XRHookTool.h"
typedef void(^block)(NSString *str);

@interface AViewController ()<CLLocationManagerDelegate>

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
    
    CLLocationManager *locatonManager = [[CLLocationManager alloc]init];
    
    locatonManager.delegate = self;
    
    
    
    [locatonManager requestLocation];
    
    
//    CLLocationDegrees lat = 12.1231231231;
//    CLLocationDegrees log = 123.1231321;
//
//    CLLocation *lo = [[CLLocation alloc]init];
//    if (lo.altitude == 0.0 || lo.verticalAccuracy == -1.0) {
//        NSLog(@"定位信息已被篡改！");
//    }
    
  
    
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    
    
    
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




-(void)fff:(int)aaaa{
    
    if (![[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {return;}
        dispatch_queue_t queue = dispatch_queue_create("com.leopardpan.HotspotHelper", 0);
        [NEHotspotHelper registerWithOptions:nil queue:queue handler: ^(NEHotspotHelperCommand * cmd) {
            if(cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
                for (NEHotspotNetwork* network  in cmd.networkList) {
                    NSLog(@"network.SSID = %@",network.SSID);
                }
            }
        }];
    
}



@end
