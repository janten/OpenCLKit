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
#import "CLCommandQueue.h"
#import "CLKernel.h"

@interface CLProgram ()

@property (readwrite) CLContext *context;
@property cl_program program;
@property (readonly) NSArray *kernelNames;

@end

@implementation CLProgram
@synthesize kernelNames = _kernelNames;
@synthesize kernels = _kernels;

- (instancetype)initWithContext:(CLContext *)context source:(NSString *)source {
	self = [super init];
	self.context = context;
	const char *source_code = source.UTF8String;
	cl_int error = CL_SUCCESS;
	self.program = clCreateProgramWithSource(self.context.context, 1, &source_code, NULL, &error);

	if (error != CL_SUCCESS) {
		NSLog(@"Could not create program: %d", error);
		return nil;
	}
	
	NSArray *devices = self.context.devices;
	cl_device_id *device_ids = malloc(sizeof(cl_device_type) * devices.count);
	
	for (NSUInteger i = 0; i < devices.count; i++) {
		CLDevice *device = devices[i];
		device_ids[i] = device.deviceId;
	}

	clBuildProgram(self.program, (cl_uint)devices.count, device_ids, "-cl-kernel-arg-info", NULL, NULL);
	free(device_ids);
	
	return self;
}

- (instancetype)initWithContext:(CLContext *)context URL:(NSURL *)URL {
	NSString *source = [NSString stringWithContentsOfURL:URL
												encoding:NSUTF8StringEncoding
												   error:nil];
	return [self initWithContext:context source:source];
}

- (void)dealloc {
	clReleaseProgram(self.program);
}

- (cl_build_status)buildStatusForDevice:(CLDevice *)device {
	cl_build_status status;
	clGetProgramBuildInfo(self.program, device.deviceId, CL_PROGRAM_BUILD_STATUS, sizeof(status), &status, NULL);
	return status;
}

- (NSString *)buildLogForDevice:(CLDevice *)device {
	const int build_log_max = 4096;
	char build_log[build_log_max];
	clGetProgramBuildInfo(self.program, device.deviceId, CL_PROGRAM_BUILD_LOG, build_log_max, build_log, NULL);
	return [NSString stringWithUTF8String:build_log];
}

#pragma mark - Properties
- (NSArray *)kernelNames {
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		const int kernel_names_max = 2048;
		char kernel_names[kernel_names_max];
		clGetProgramInfo(self.program, CL_PROGRAM_KERNEL_NAMES, kernel_names_max, kernel_names, NULL);
		NSString *kernelNameString = [NSString stringWithUTF8String:kernel_names];
		NSArray *rawKernelNames = [kernelNameString componentsSeparatedByString:@";"];
		NSMutableArray *kernelNames = [NSMutableArray arrayWithCapacity:rawKernelNames.count];
		NSCharacterSet *charactersToTrim = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		
		for (NSString *rawKernelName in rawKernelNames) {
			NSString *kernelName = [rawKernelName stringByTrimmingCharactersInSet:charactersToTrim];
			[kernelNames addObject:kernelName];
		}
		
		_kernelNames = [NSArray arrayWithArray:kernelNames];
	});
	
	return _kernelNames;
}

- (NSArray *)kernels {
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		NSMutableArray *kernels = [NSMutableArray arrayWithCapacity:self.kernelNames.count];
		cl_int error = CL_SUCCESS;
		
		for (NSString *kernelName in self.kernelNames) {
			cl_kernel native_kernel = clCreateKernel(self.program, kernelName.UTF8String, &error);
			
			if (error == CL_SUCCESS) {
				CLKernel *kernel = [[CLKernel alloc] initWithProgram:self kernel:native_kernel];
				[kernels addObject:kernel];
			}
			
		}

		_kernels = [NSArray arrayWithArray:kernels];
	});
	
	return _kernels;
}

@end
