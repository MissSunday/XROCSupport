//
//  XRHookTool.m
//  XROCSupport_Example
//
//  Created by ext.wangxiaoran3 on 2023/2/13.
//  Copyright © 2023 ext.wangxiaoran3. All rights reserved.
//

#import "XRHookTool.h"
#import "fishhook.h"
@implementation XRHookTool
+ (void)load {
    //exchange方法防护
    struct rebinding exchange;
    exchange.name = "method_exchangeImplementations";
    exchange.replacement = my_exchange;
    exchange.replaced = (void *)&exchangeP;
    
    //set、get方法防护
    //setIMP
    struct rebinding setIMP;
    setIMP.name = "method_setImplementation";
    setIMP.replacement = hook_setImple;
    setIMP.replaced = (void *)&setIMP_p;
    
    //getIMP
//    struct rebinding getIMP;
//    getIMP.name = "method_getImplementation";
//    getIMP.replacement = my_exchange;
//    getIMP.replaced = (void *)&getIMP_p;

    
    struct rebinding bds[] = {exchange,setIMP};
    rebind_symbols(bds, 2);
    

}

//指针!这个可以暴露给外接!我自己的工程使用!!
void (*exchangeP)(Method _Nonnull m1, Method _Nonnull m2);

IMP _Nonnull (*setIMP_p)(Method _Nonnull m, IMP _Nonnull imp);
IMP _Nonnull (*getIMP_p)(Method _Nonnull m);


void my_exchange(Method _Nonnull m1, Method _Nonnull m2){
    NSLog(@"检测到正在调用method_exchangeImplementations!");
    if(m1 && m2){
        SEL sel1 = method_getName(m1);
        SEL sel2 = method_getName(m2);
        NSLog(@"%s <-> %s",[NSStringFromSelector(sel1) UTF8String],[NSStringFromSelector(sel2) UTF8String]);
    }
    exchangeP(m1,m2);
}
void hook_setImple(Method _Nonnull method, IMP _Nonnull imp){
    NSLog(@"检测到正在调用method_setImplementation");
    if(method){
        SEL sel = method_getName(method);
        NSLog(@"%s",[NSStringFromSelector(sel) UTF8String]);
    }
    setIMP_p(method,imp);
}
@end
