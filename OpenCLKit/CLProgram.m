//
//  CLProgram.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLProgram.h"
#import "CLContext.h"
#import "CLDevice.h"

@interface CLProgram ()

@property (readwrite) CLContext *context;
@property cl_program program;
@property cl_kernel *kernels;

@end

@implementation CLProgram

- (instancetype)initWithContext:(CLContext *)context source:(NSString *)source {
	self = [super init];
	self.context = context;
	[self buildWithSource:source];
	return self;
}

- (instancetype)initWithContext:(CLContext *)context URL:(NSURL *)URL {
	NSString *source = [NSString stringWithContentsOfURL:URL
												encoding:NSUTF8StringEncoding
												   error:nil];
	return [self initWithContext:context source:source];
}

- (void)buildWithSource:(NSString *)sourceCode {
	NSArray *devices = self.context.devices;
	cl_device_id *device_ids = malloc(sizeof(cl_device_type) * devices.count);
	
	for (NSUInteger i = 0; i < devices.count; i++) {
		CLDevice *device = devices[i];
		device_ids[i] = device.deviceId;
	}
	
	const cl_uint kernels_max = 128;
	cl_kernel kernels[kernels_max];
	size_t source_size = sourceCode.length;
	const char *source = sourceCode.UTF8String;
	clCreateProgramAndKernelsWithSourceAPPLE(self.context.context,
											 1,
											 &source,
											 &source_size,
											 (cl_uint)self.context.devices.count,
											 device_ids,
											 NULL,
											 0,
											 NULL,
											 &_program,
											 kernels);
	free(device_ids);
}

- (void)enqueueKernel:(NSString *)name {
	clEnqueueNDRangeKernel(self.context., <#cl_kernel#>, <#cl_uint#>, <#const size_t *#>, <#const size_t *#>, <#const size_t *#>, <#cl_uint#>, <#const cl_event *#>, <#cl_event *#>)
}

#pragma mark - Properties
- (NSArray *)kernelNames {
	const int kernel_names_max = 2048;
	char kernel_names[kernel_names_max];
	clGetProgramInfo(self.program, CL_PROGRAM_KERNEL_NAMES, kernel_names_max, kernel_names, NULL);
	NSString *kernelNames = [NSString stringWithUTF8String:kernel_names];
	return [kernelNames componentsSeparatedByString:@";"];
}

@end
