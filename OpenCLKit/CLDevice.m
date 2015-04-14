//
//  CLDevice.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLDevice.h"

@interface CLDevice ()
@property (readwrite) CLPlatform *platform;
@property cl_device_id deviceId;
@end

@implementation CLDevice

- (instancetype)initWithPlatform:(CLPlatform *)platform deviceId:(cl_device_id)device_id {
	self = [super init];
	self.platform = platform;
	self.deviceId = device_id;
	return self;
}

- (NSString *)deviceInfo:(cl_device_info)device_info {
	const int info_max = 2048;
	char info[info_max];
	clGetDeviceInfo(self.deviceId, device_info, info_max, info, NULL);
	return [NSString stringWithUTF8String:info];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ %@", self.vendor, self.name];
}

#pragma mark - Properties
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
