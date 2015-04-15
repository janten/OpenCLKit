//
//  CLCommandQueue.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 15.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLCommandQueue.h"
#import "CLDevice.h"

@implementation CLCommandQueue

- (instancetype)initWithCommandQueue:(cl_command_queue)queue {
	self = [super init];
	_commandQueue = queue;
	return self;
}

- (void)dealloc {
	clReleaseCommandQueue(self.commandQueue);
}

@end
