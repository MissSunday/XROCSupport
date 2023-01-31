#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XROCSupport.h"
#import "XRBaseViewController.h"
#import "XRPCH.h"
#import "XRTool.h"
#import "NSObject+Property.h"
#import "NSString+STRegex.h"
#import "UIImage+ReColor.h"

FOUNDATION_EXPORT double XROCSupportVersionNumber;
FOUNDATION_EXPORT const unsigned char XROCSupportVersionString[];

