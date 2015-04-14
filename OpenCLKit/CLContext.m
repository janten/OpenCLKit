//
//  CLContext.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLContext.h"
#import "CLDevice.h"

@interface CLContext ()
@property (readwrite) NSArray *devices;
@property cl_context context;
@property cl_command_queue *commandQueues;
@end

@implementation CLContext

- (instancetype)initWithDevice:(CLDevice *)device {
	return [self initWithDevices:@[device]];
}

- (instancetype)initWithDevices:(NSArray *)devices {
	if (devices.count == 0) {
		return nil;
	}

	self = [super init];
	self.devices = [NSArray arrayWithArray:devices];

	cl_device_id *device_ids = malloc(sizeof(cl_device_id) * devices.count);
	
	for (NSUInteger i = 0; i < devices.count; i++) {
		CLDevice *device = devices[i];
		device_ids[i] = device.deviceId;
	}

	self.commandQueues = malloc(sizeof(cl_command_queue) * devices.count);
	cl_context context;
	clCreateContextAndCommandQueueAPPLE(NULL, (cl_uint)devices.count, device_ids, NULL, NULL, 0, &context, self.commandQueues);
	self.context = context;
	free(device_ids);
	return self;
}

@end
