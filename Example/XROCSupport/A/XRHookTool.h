//
//  XRHookTool.h
//  XROCSupport_Example
//
//  Created by ext.wangxiaoran3 on 2023/2/13.
//  Copyright © 2023 ext.wangxiaoran3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
NS_ASSUME_NONNULL_BEGIN



CF_EXPORT void (* exchangeP)(Method _Nonnull m1, Method _Nonnull m2);


@interface XRHookTool : NSObject

@end

NS_ASSUME_NONNULL_END
