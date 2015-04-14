//
//  CLPlatform.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenCL;

@class CLContext;

@interface CLPlatform : NSObject

@property (readonly) NSString *profile;
@property (readonly) NSString *version;
@property (readonly) NSString *name;
@property (readonly) NSString *vendor;
@property (readonly) NSArray *extensions;

+ (NSArray *)platforms;

- (instancetype)initWithPlatformId:(cl_platform_id)platform_id NS_DESIGNATED_INITIALIZER;
- (NSArray *)devices;
- (NSArray *)devicesOfType:(cl_device_type)device_type;
- (NSString *)platformInfo:(cl_platform_info)platform_info;

@end
