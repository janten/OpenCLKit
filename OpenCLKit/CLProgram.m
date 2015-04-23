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
#import "CLUtilities.h"

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
	[CLUtilities checkError:error message:@"Create program"];
	
	if (error != CL_SUCCESS) {
		return nil;
	}
	
	NSArray *devices = self.context.devices;
	cl_device_id *device_ids = malloc(sizeof(cl_device_id) * devices.count);
	
	for (NSUInteger i = 0; i < devices.count; i++) {
		CLDevice *device = devices[i];
		device_ids[i] = device.deviceId;
	}

	error = clBuildProgram(self.program, (cl_uint)devices.count, device_ids, "-cl-kernel-arg-info", NULL, NULL);
	[CLUtilities checkError:error message:@"Build program"];
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
	NSLog(@"Dealloc: %@", [self description]);
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

- (CLKernel *)kernelNamed:(NSString *)name {
	for (CLKernel *kernel in self.kernels) {
		if ([kernel.name isEqualToString:name]) {
			return kernel;
		}
	}
	
	return nil;
}

#pragma mark - Properties
- (NSArray *)kernelNames {
	if (_kernelNames == nil) {
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
	}
	
	return _kernelNames;
}

- (NSArray *)kernels {
	if (_kernels == nil) {
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
	}
	
	return _kernels;
}

@end
