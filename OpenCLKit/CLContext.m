//
//  CLContext.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLContext.h"
#import "CLDevice.h"
#import "CLCommandQueue.h"
#import "CLUtilities.h"
#import "CLPlatform.h"

@implementation CLContext

- (instancetype)init {
	return [self initWithDevices:@[]];
}

- (instancetype)initWithDevice:(CLDevice *)device {
	return [self initWithDevices:@[device]];
}

- (instancetype)initWithDevices:(NSArray *)devices {

	if (devices.count == 0) {
		return nil;
	}

	self = [super init];
	cl_device_id *device_ids = malloc(sizeof(cl_device_id) * devices.count);
	
	for (NSUInteger i = 0; i < devices.count; i++) {
		CLDevice *device = devices[i];
		device_ids[i] = device.deviceId;
	}

	cl_int error = CL_SUCCESS;
	CLDevice *firstDevice = devices.firstObject;
	cl_context_properties properties[] = {CL_CONTEXT_PLATFORM, (cl_context_properties)firstDevice.platform.platformId, (cl_context_properties)0};
	_context = clCreateContext(properties, (cl_uint)devices.count, device_ids, NULL, NULL, &error);
	[CLUtilities checkError:error message:@"Create context and command queues"];
	free(device_ids);
	return self;
}

- (void)dealloc {
	NSLog(@"Dealloc: %@", [self description]);
	clReleaseContext(self.context);
}

#pragma mark - Properties
- (NSArray *)devices {
	NSMutableArray *devices = [NSMutableArray arrayWithCapacity:128];
	size_t device_id_size_max = sizeof(cl_device_id) * 128;
	cl_device_id *device_ids = malloc(device_id_size_max);
	size_t device_id_size_ret;
	clGetContextInfo(self.context, CL_CONTEXT_DEVICES, device_id_size_max, device_ids, &device_id_size_ret);
	NSUInteger deviceCount = device_id_size_ret/sizeof(cl_device_id);
	
	for (int i = 0; i < deviceCount; i++) {
		CLDevice *device = [CLDevice deviceWithId:device_ids[i]];
		[devices addObject:device];
	}

	free(device_ids);
	return devices;
}

@end
