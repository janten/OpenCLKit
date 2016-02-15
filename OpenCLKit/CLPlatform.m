//
//  CLPlatform.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLPlatform.h"
#import "CLDevice.h"
#import "CLContext.h"

@interface CLPlatform ()
@property (readwrite) cl_platform_id platformId;
@end

@implementation CLPlatform

+ (NSArray *)platforms {
	const int platforms_max = 128;
	cl_platform_id platforms[platforms_max];
	cl_uint platform_count;
	clGetPlatformIDs(platforms_max, platforms, &platform_count);
	NSMutableArray *mutableResult = [NSMutableArray arrayWithCapacity:platform_count];

	for (cl_uint i = 0; i < platform_count; i++) {
		CLPlatform *platform = [[CLPlatform alloc] initWithPlatformId:platforms[i]];
		[mutableResult addObject:platform];
	}
	
	NSArray *result = [NSArray arrayWithArray:mutableResult];
	return result;
}

+ (instancetype)platformWithId:(cl_platform_id)platform_id {
	return [[CLPlatform alloc] initWithPlatformId:platform_id];
}

- (instancetype)initWithPlatformId:(cl_platform_id)platform_id {
	self = [super init];
	self.platformId = platform_id;
	return self;
}

- (void)dealloc {
	NSLog(@"Dealloc: %@", [self description]);
}

- (NSArray *)devices {
	return [self devicesOfType:CL_DEVICE_TYPE_ALL];
}

- (NSArray *)devicesOfType:(cl_device_type)device_type {
	const int devices_max = 128;
	cl_device_id devices[devices_max];
	cl_uint device_count;
	clGetDeviceIDs(self.platformId, device_type, devices_max, devices, &device_count);
	NSMutableArray *mutableResult = [NSMutableArray arrayWithCapacity:device_count];

	for (cl_uint i = 0; i < device_count; i++) {
		CLDevice *device = [[CLDevice alloc] initWithDeviceId:devices[i]];
		[mutableResult addObject:device];
	}
	
	NSArray *result = [NSArray arrayWithArray:mutableResult];
	return result;
}

- (NSString *)platformInfo:(cl_platform_info)platform_info {
	const int info_max = 1024;
	char info[info_max];
	clGetPlatformInfo(self.platformId, platform_info, info_max, info, NULL);
	return [NSString stringWithUTF8String:info];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@ %@)", [super description], self.name, self.version];
}

#pragma mark - Comparison
- (NSUInteger)hash {
	return (NSUInteger)self.platformId;
}

- (BOOL)isEqual:(id)object {
	
	if ([object isKindOfClass:[self class]] && [object platformId] == self.platformId) {
		return YES;
	}
	
	return NO;
}

#pragma mark - Properties
- (NSString *)profile {
	return [self platformInfo:CL_PLATFORM_PROFILE];
}

- (NSString *)version {
	return [self platformInfo:CL_PLATFORM_VERSION];
}

- (NSString *)name {
	return [self platformInfo:CL_PLATFORM_NAME];
}

- (NSString *)vendor {
	return [self platformInfo:CL_PLATFORM_VENDOR];
}

- (NSArray *)extensions {
	return [[self platformInfo:CL_PLATFORM_EXTENSIONS] componentsSeparatedByString:@" "];
}

@end
