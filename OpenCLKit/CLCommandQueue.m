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
#import "CLKernelArgument.h"
#import "CLUtilities.h"

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
	cl_int error;
	
	for (NSUInteger i = 0; i < globalDimensions.count; i++) {
		NSNumber *dimension = globalDimensions[i];
		global_size[i] = [dimension longLongValue];
	}
	
	for (CLKernelArgument *argument in kernel.arguments) {
		cl_mem buffer = argument.buffer;
		error = clEnqueueWriteBuffer(self.commandQueue,
									 buffer,
									 CL_FALSE,
									 0,
									 argument.data.length,
									 argument.data.bytes,
									 0,
									 NULL,
									 NULL);
		[CLUtilities checkError:error message:@"Enqueue buffer"];
		error = clSetKernelArg(kernel.kernel, argument.index, sizeof(cl_mem), &buffer);
		NSString *message = [NSString stringWithFormat:@"Set argument %@", argument];
		[CLUtilities checkError:error message:message];
	}
	
	error = clEnqueueNDRangeKernel(self.commandQueue,
								   kernel.kernel,
								   (cl_uint)globalDimensions.count,
								   NULL,
								   global_size,
								   NULL,
								   0,
								   NULL,
								   NULL);
	[CLUtilities checkError:error message:@"Enqueue kernel"];
}

- (void)readDataForArgument:(CLKernelArgument *)argument {
	if (![argument.data isKindOfClass:[NSMutableData class]]) {
		return;
	}
	
	NSMutableData *data = (NSMutableData *)argument.data;
	cl_mem buffer = argument.buffer;
	cl_int error = clEnqueueReadBuffer(self.commandQueue,
									   buffer,
									   CL_TRUE,
									   0,
									   data.length,
									   data.mutableBytes,
									   0,
									   NULL,
									   NULL);
	NSString *message = [NSString stringWithFormat:@"Read data for %@", argument];
	[CLUtilities checkError:error message:message];
}

@end
