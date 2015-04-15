//
//  CLCommandQueue.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 15.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLCommandQueue.h"
#import "CLDevice.h"
#import "CLKernel.h"

@implementation CLCommandQueue

- (instancetype)initWithCommandQueue:(cl_command_queue)queue {
	self = [super init];
	_commandQueue = queue;
	return self;
}

- (void)dealloc {
	clReleaseCommandQueue(self.commandQueue);
}

- (void)enqueueKernel:(CLKernel *)kernel globalDimensions:(NSArray *)globalDimensions {
	size_t global_size[] = {0, 0, 0};
	
	for (NSUInteger i = 0; i < globalDimensions.count; i++) {
		NSNumber *dimension = globalDimensions[i];
		global_size[i] = [dimension longLongValue];
	}
	
	clEnqueueNDRangeKernel(self.commandQueue,
						   kernel.kernel,
						   (cl_uint)globalDimensions.count,
						   NULL,
						   global_size,
						   NULL,
						   0,
						   NULL,
						   NULL);
}


@end
