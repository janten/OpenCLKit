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

/**
 *  Initialize a CLDevice instance for the given device_id on the given 
 *  platform. You should not call this method directly. Use [CLPlatform 
 *  devicesOfType:] instead.
 *
 *  @param platform  The platform with which the device is associated.
 *  @param device_id The opaque device identifier.
 *
 *  @return A CLDevice object.
 */
- (instancetype)initWithPlatform:(CLPlatform *)platform deviceId:(cl_device_id)device_id NS_DESIGNATED_INITIALIZER;

@end
