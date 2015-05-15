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
#import "CLBuffer.h"

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
	size_t global_size[] = {0, 0, 0};
	size_t *local_size = NULL;
	
    for (CLKernelArgument *argument in kernel.arguments) {
        if (argument.buffer != nil) {
            clEnqueueWriteBuffer(self.commandQueue,
                                 argument.buffer.buffer,
                                 CL_FALSE,
                                 0,
                                 argument.buffer.length,
                                 argument.buffer.bytes,
                                 0,
                                 NULL,
                                 NULL);
        }
    }
    
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

- (NSData *)dataFromBuffer:(CLBuffer *)buffer {
	NSMutableData *data = [NSMutableData dataWithCapacity:buffer.length];
	cl_int error = clEnqueueReadBuffer(self.commandQueue,
									   buffer.buffer,
									   CL_TRUE,
									   0,
									   buffer.length,
									   data.mutableBytes,
									   0,
									   NULL,
									   NULL);
	NSString *message = [NSString stringWithFormat:@"Read data for %@", buffer];
	[CLUtilities checkError:error message:message];
    return data;
}

@end
