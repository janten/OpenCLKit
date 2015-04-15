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

@interface CLContext ()
@property (readwrite) NSArray *devices;
@property NSArray *commandQueues;
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

	cl_command_queue *queues = malloc(sizeof(cl_command_queue) * devices.count);
	cl_context context;
	clCreateContextAndCommandQueueAPPLE(NULL, (cl_uint)devices.count, device_ids, NULL, NULL, 0, &context, queues);
	_context = context;
	free(device_ids);
	NSMutableArray *commandQueues = [NSMutableArray arrayWithCapacity:devices.count];
	
	for (NSUInteger i = 0; i < devices.count; i++) {
		CLCommandQueue *queue = [[CLCommandQueue alloc] initWithCommandQueue:queues[i]];
		[commandQueues addObject:queue];
	}
	
	self.commandQueues = [NSArray arrayWithArray:commandQueues];
	return self;
}

- (void)dealloc {
	clReleaseContext(self.context);
}

- (CLCommandQueue *)commandQueueForDevice:(CLDevice *)device {
	NSUInteger index = [self.devices indexOfObject:device];

	if (index == NSNotFound) {
		return nil;
	}
	
	return self.commandQueues[index];
}

@end
