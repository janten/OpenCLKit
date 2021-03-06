//
//  CLDevice.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLDevice.h"
#import "CLPlatform.h"

@implementation CLDevice

+ (instancetype)deviceWithId:(cl_device_id)device_id {
	CLDevice *device = [[CLDevice alloc] initWithDeviceId:device_id];
	return device;
}

- (instancetype)initWithDeviceId:(cl_device_id)device_id {
	self = [super init];
	_deviceId = device_id;
	return self;
}

- (NSString *)deviceInfo:(cl_device_info)device_info {
	const int info_max = 2048;
	char info[info_max];
	clGetDeviceInfo(self.deviceId, device_info, info_max, info, NULL);
	return [NSString stringWithUTF8String:info];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@ %@)", [super description], self.vendor, self.name];
}

- (void)dealloc {
	NSLog(@"Dealloc: %@", [self description]);
}

#pragma mark - Properties
- (CLPlatform *)platform {
	cl_platform_id platform_id;
	clGetDeviceInfo(self.deviceId, CL_DEVICE_PLATFORM, sizeof(cl_platform_id), &platform_id, NULL);
	return [CLPlatform platformWithId:platform_id];
}

- (NSString *)name {
	return [self deviceInfo:CL_DEVICE_NAME];
}

- (NSString *)vendor {
	return [self deviceInfo:CL_DEVICE_VENDOR];
}

- (NSArray *)extensions {
	NSArray *extensions = [[self deviceInfo:CL_DEVICE_EXTENSIONS] componentsSeparatedByString:@" "];
	return extensions;
}

- (NSString *)driverVersion {
	return [self deviceInfo:CL_DRIVER_VERSION];
}

- (NSString *)version {
	return [self deviceInfo:CL_DEVICE_VERSION];
}

- (cl_device_type)deviceType {
	cl_device_type type;
	clGetDeviceInfo(self.deviceId, CL_DEVICE_TYPE, sizeof(cl_device_type), &type, NULL);
	return type;
}

@end
