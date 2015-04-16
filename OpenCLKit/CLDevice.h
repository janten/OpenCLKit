//
//  CLDevice.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLPlatform;

@interface CLDevice : NSObject

@property (readonly) cl_device_id deviceId;
@property (readonly) cl_device_type deviceType;
@property (readonly) CLPlatform *platform;
@property (readonly) NSArray *extensions;
@property (readonly) NSString *driverVersion;
@property (readonly) NSString *name;
@property (readonly) NSString *vendor;
@property (readonly) NSString *version;

- (instancetype)initWithPlatform:(CLPlatform *)platform deviceId:(cl_device_id)device_id NS_DESIGNATED_INITIALIZER;

@end
