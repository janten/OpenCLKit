//
//  CLPlatform.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLContext;

@interface CLPlatform : NSObject

@property (readonly) NSString *profile;
@property (readonly) NSString *version;
@property (readonly) NSString *name;
@property (readonly) NSString *vendor;
@property (readonly) NSArray *extensions;

/**
 *  Get all currently available platforms. The set of available platforms is
 *  unlikely to change at runtime, you may want to cache the results. Will
 *  return 128 platforms at most.
 *
 *  @return An NSArray of CLPlatform objects.
 */
+ (NSArray *)platforms;

/**
 *  Initializes the platform with an OpenCL opaque platform id. You should
 *  usually use [CLPlatform platforms] instead of calling this method directly.
 *  Validity of the platform id is not checked.
 *
 *  @param platform_id The opaque platform identifier used by OpenCL.
 *
 *  @return An initialized CLPlatform object.
 */
- (instancetype)initWithPlatformId:(cl_platform_id)platform_id NS_DESIGNATED_INITIALIZER;

/**
 *  Get all devices available on this platform. The same hardware device may be
 *  available on multiple platforms. A new set of CLDevice instances will be
 *  created each time you call this method. Calling this method is identical to
 *  calling devicesOfType: with device type CL_DEVICE_TYPE_ALL.
 *
 *  @return A NSArray of CLDevice objects.
 */
- (NSArray *)devices;

/**
 *  Get devices of the given type available on this platform.
 *
 *  @param device_type The type of the devices you want returned.
 *
 *  @return A NSArray of CLDevice objects.
 */
- (NSArray *)devicesOfType:(cl_device_type)device_type;

- (NSString *)platformInfo:(cl_platform_info)platform_info;

@end
