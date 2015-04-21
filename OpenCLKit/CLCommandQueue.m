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
#import "CLContext.h"

@implementation CLCommandQueue

- (instancetype)initWithDevice:(CLDevice *)device context:(CLContext *)context {
	self = [super init];
	cl_int error = CL_SUCCESS;
	_commandQueue = clCreateCommandQueue(context.context, device.deviceId, 0, &error);
	_device = device;
	_context = context;
	[CLUtilities checkError:error message:@"Create command queue"];
	return self;
}

- (void)dealloc {
	NSLog(@"Dealloc: %@", [self description]);
	clReleaseCommandQueue(self.commandQueue);
}

- (void)enqueueKernel:(CLKernel *)kernel globalDimensions:(NSArray *)globalDimensions {
	[self enqueueKernel:kernel globalDimensions:globalDimensions localDimensions:nil];
}

- (void)enqueueKernel:(CLKernel *)kernel globalDimensions:(NSArray *)globalDimensions localDimensions:(NSArray *)localDimensions {
	cl_int error;

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

	size_t global_size[] = {0, 0, 0};
	size_t *local_size = NULL;
	
	for (NSUInteger i = 0; i < globalDimensions.count; i++) {
		NSNumber *dimension = globalDimensions[i];
		global_size[i] = [dimension longLongValue];
	}

	if (localDimensions != nil) {
		size_t size[] = {0, 0, 0};

		for (NSUInteger i = 0; i < localDimensions.count; i++) {
			NSNumber *dimension = localDimensions[i];
			size[i] = [dimension longLongValue];
		}
		
		local_size = size;
	}
	
	error = clEnqueueNDRangeKernel(self.commandQueue,
								   kernel.kernel,
								   (cl_uint)globalDimensions.count,
								   NULL,
								   global_size,
								   local_size,
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
